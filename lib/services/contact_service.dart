import 'package:http/http.dart'import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:services/snackbar_service.dart';
import 'package:http/http.dart';
import 'services/subscribe_contacts_service.dart';
import 'models/subscribe_contacts_model.dart';
import 'models/contact_model.dart';

part 'contact_model.g.dart';

class Contact {
  final String id;
  final String？ name;
  final String phoneNumber;
  final String? email;
  final String? label;
  String? avatarPath; // 新增属性

  Contact({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    this.label,
    this.avatarPath,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    id: json['id'],
    name: json['name'],
    phoneNumber: json['phone_number'],
    email: json['email'],
    label: json['label'],
    avatarPath: json['avatarPath'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone_number': phoneNumber,
    'email': email,
    'label': label,
    'avatarPath': avatarPath,
  };
}

class ContactService {
  final Database database;

  ContactService({required this.database});

  Future<List<Contact>> getAllContacts() async {
    final List<Map<String, dynamic>> maps = await database.query('contacts');
    return List.generate(maps.length, (i) => Contact.fromJson(maps[i]));
  }

  Future<Contact> getContactById(String id) async {
    final List<Map<String, dynamic>> maps =
        await database.query('contacts', where: 'id = ?', whereArgs: [id]);
    return Contact.fromJson(maps.first);
  }

  Future<void> addContact(Contact contact) async {
    await database.insert('contacts', contact.toJson());
  }

  Future<void> updateContact(Contact contact) async {
    await database.update('contacts', contact.toJson(), where: 'id = ?', whereArgs: [contact.id]);
  }

  Future<void> deleteContact(Contact contact) async {
    await database.delete('contacts', where: 'id = ?', whereArgs: [contact.id]);
  }

    Future<void> chooseAvatarAndSave(Contact contact) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final path = await saveFile(pickedFile.path);
      contact.avatarPath = path;
      await updateContact(contact);
    }
  }

  Future<String> saveFile(String filePath) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final newPath = '<span class="math-inline">\{appDocDir\.path\}/</span>{basename(filePath)}';
    final file = File(filePath);
    await file.copy(newPath);
    return newPath;
  }

  // Add the importContactsFromUrl function within the class
  Future<void> importContactsFromUrl(String vcfUrl) async {
    try {
      final response = await get(Uri.parse(vcfUrl));
      if (response.statusCode == 200) {
        final String vcfString = response.body;
        await _importVcfContacts('', vcfString); // Assuming path is not required for downloaded content
        SnackbarService.showSuccessSnackBar('Contacts imported successfully from URL!');
      } else {
        SnackbarService.showErrorSnackBar('Error downloading VCF: ${response.statusCode}');
      }
    } catch (error) {
      SnackbarService.showErrorSnackBar('Error importing contacts from URL: $error');
    }
  }

  // Add a function to show a dialog for entering the VCF URL
  Future<void> showImportFromUrlDialog() async {
    final TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Import Contacts from URL'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Enter VCF URL'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final vcfUrl = controller.text;
              await importContactsFromUrl(vcfUrl);
              Navigator.pop(context);
            },
            child: Text('Import'),
          ),
        ],
      ),
    );
  }

  // Add a function to handle the import button click
  Future<void> onImportButtonClick() async {
    // Show a dialog to enter the VCF URL
    await showImportFromUrlDialog();
  }
}  

Future<void> importContacts(String format) async {
  final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'vcf', 'json', 'txt']);

  if (result != null) {
    final String filePath = result.files.single.path!;
    switch (format) {
      case 'csv':
        await _importContactsFromFile(_importCsvContacts, path: filePath);
        break;
      case 'vcf':
        await _importContactsFromFile(_importVcfContacts, path: filePath);
        break;
      case 'json':
        await _importContactsFromFile(_importJsonContacts, path: filePath);
        break;
      case 'txt':
        await _importContactsFromFile(_importTxtContacts, path: filePath);
        break;
    }
      SnackbarService.showSuccessSnackBar('Contacts imported successfully!');
    } catch (error) {
      // Handle import errors
      print('Import error: $error');
      SnackbarService.showErrorSnackBar('Error importing contacts: $error');
    }
  } else {
    // Show error message if no file selected
    SnackbarService.showErrorSnackBar('No file selected for import');
  }
}

Future<void> _importContactsFromFile(
  Future<void> Function(String path, String filePath) importFunction, {
  required String path,
  required String filePath,
}) async {
  try {
    await importFunction(path, filePath);
  } catch (error) {
    // Handle import errors
    print('Import error: $error');
    // Show error message based on error type
    if (error is FilePickerError) {
      SnackbarService.showErrorSnackBar('文件选择错误: ${error.message}');
    } else if (error is FormatException) {
      SnackbarService.showErrorSnackBar('文件格式错误: ${error.message}');
    } else {
      SnackbarService.showErrorSnackBar('未知错误: $error');
    }
  }
}

Future<void> _importCsvContacts(String path, String filePath) async {
  final File csvFile = File('$path/$filePath');
  final List<String> lines = await csvFile.readAsLines();

  // Parse CSV lines and create contacts
  for (final String line in lines) {
    final List<String> values = line.split(',');
    final Contact contact = Contact(
      id: values[0],
      name: values[1],
      phoneNumber: values[2],
      email: values[3],
      label: values[4],
    );
    await addContact(contact);
  }
}

Future<void> _importVcfContacts(String path, String filePath) async {
  final File vcfFile = File('$path/$filePath');
  final String vcfString = await vcfFile.readAsString();

  // Split VCF string into lines
  final List<String> lines = vcfString.split('\n');

  // Parse VCF lines and create contacts
  for (final String line in lines) {
    if (line.startsWith('BEGIN:VCARD')) {
      final Contact contact = Contact();

      // Parse VCF properties
      while (!line.startsWith('END:VCARD')) {
        final List<String> parts = line.split(':');
        final String property = parts[0].trim();
        final String value = parts[1].trim();

        switch (property) {
          case 'FN':
            contact.name = value;
            break;
          case 'TEL':
            contact.phoneNumber = value;
            break;
          case 'EMAIL':
            contact.email = value;
            break;
          case 'NOTE':
            contact.label = value;
            break;
          case 'PHOTO;ENCODING=BASE64;TYPE=JPEG:':
            final base64Data = line.split(':')[1];
            final bytes = base64Decode(base64Data);
            final appDocDir = await getApplicationDocumentsDirectory();
            final fileName = '${basename(contact.id)}.jpg';
            final filePath = '${appDocDir.path}/$fileName';
            final file = File(filePath);
            await file.writeAsBytes(bytes);
            contact.avatarPath = filePath;
            break;
        }

        // Read next line
        line = lines[i];
      }

      // Add contact to database
      await addContact(contact);
    }
  }
}

Future<void> _importJsonContacts(String path, String filePath) async {
  final File jsonFile = File('$path/$filePath');
  final String jsonString = await jsonFile.readAsString();

  // Parse JSON and create contacts
  final List<dynamic> jsonData = jsonDecode(jsonString);
  for (final dynamic jsonDataItem in jsonData) {
    final Contact contact = Contact.fromJson(jsonDataItem);
    await addContact(contact);
  }
}

Future<void> _importTxtContacts(String path, String filePath) async {
  final File txtFile = File('$path/$filePath');
  final String txtString = await txtFile.readAsString();

  // Split TXT string into lines
  final List<String> lines = txtString.split('\n');

  // Parse TXT lines and create contacts
  for (final String line in lines) {
    final List<String> values = line.split(',');
    final Contact contact = Contact(
      id: values[0],
      name: values[1],
      phoneNumber: values[2],
      email: values[3],
      label: values[4],
    );
    await addContact(contact);

  Future<void> exportContacts(String format) async {
  // Get application documents directory
  final Directory directory = await getApplicationDocumentsDirectory();
  final String path = directory.path;

  // Show file picker and get save path
  final String savePath = await FilePicker.getSavePath(
    fileName: 'contacts.$format',
  );
    
  // If no path chosen, use default path
  if (savePath == null) {
    savePath = await _getDefaultDirectoryPath(); // 获取默认目录路径
    savePath += '/contacts.$format';
  }

  // Export based on format
  switch (format) {
    case 'csv':
      await _exportCsvContacts(savePath);
      break;
    case 'vcf':
      await _exportVcfContacts(savePath);
      break;
    case 'json':
      await _exportJsonContacts(savePath);
      break;
    case 'txt':
      await _exportTxtContacts(savePath);
      break;
  }
  try {
    SnackbarService.showSuccessSnackBar('Contacts exported successfully to $savePath');
  } catch (error) {
    // Handle export errors
    print('Export error: $error');
    SnackbarService.showErrorSnackBar('Error exporting contacts: $error');
  }
}

// Implement export logic for each format, writing to the specified save path

Future<void> _exportCsvContacts(String savePath) async {
  // Get all contacts
  final List<Contact> contacts = await getAllContacts();

  // Create CSV file
  final File csvFile = File(savePath);
  final csvSink = csvFile.openWrite();

  // Write headers
  csvSink.writeln('id,name,phone_number,email,label');

  // Write contact data
  for (final Contact contact in contacts) {
    csvSink.writeln('${contact.id},${contact.name},${contact.phoneNumber},${contact.email},${contact.label}');
  }

  // Close the sink
  csvSink.close();
}

  Future<void> _exportVcfContacts(String savePath) async {
  final List<Contact> contacts = await getAllContacts();
  final File vcfFile = File(savePath);
  final vcfSink = vcfFile.openWrite();

  for (final Contact contact in contacts) {
    // ... 写入 VCF 头信息
    vcfSink.writeln('BEGIN:VCARD');
    vcfSink.writeln('VERSION:3.0');
    vcfSink.writeln('N:${contact.name}'); // 新增 name
    vcfSink.writeln('FN:${contact.name}'); // 新增 name
    vcfSink.writeln('LABEL:${contact.label}'); // 新增 label
    
    // 写入联系人基本信息
    vcfSink.writeln('TEL;TYPE=CELL:${contact.phoneNumber}');
    vcfSink.writeln('EMAIL;TYPE=HOME:${contact.email}');

    // 写入头像（如果存在）
    if (contact.avatarPath != null) {
      vcfSink.writeln('PHOTO;ENCODING=BASE64;TYPE=JPEG:${base64Encode(File(contact.avatarPath!).readAsBytesSync())}');
    }

    // 写入 VCF 尾信息
    vcfSink.writeln('END:VCARD');
  }
  vcfSink.close();
}

Future<void> _exportJsonContacts(String savePath) async {
  final List<Contact> contacts = await getAllContacts();
  final File jsonFile = File(savePath);
  final jsonSink = jsonFile.openWrite();

  // 将所有联系人转换为 JSON 数组
  final json = jsonEncode(contacts.map((contact) => contact.toJson()).toList());

  // 写入文件
  jsonSink.write(json);
  jsonSink.close();
}
    

