import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:services/snackbar_service.dart';

part 'contact_model.g.dart';

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
      remark: values[4],
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
            contact.remark = value;
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
      remark: values[4],
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
}

// Implement export logic for each format, writing to the specified save path

Future<void> _exportCsvContacts(String savePath) async {
  // Get all contacts
  final List<Contact> contacts = await getAllContacts();

  // Create CSV file
  final File csvFile = File(savePath);
  final csvSink = csvFile.openWrite();

  // Write headers
  csvSink.writeln('id,name,phone_number,email,remark');

  // Write contact data
  for (final Contact contact in contacts) {
    csvSink.writeln('${contact.id},${contact.name},${contact.phoneNumber},${contact.email},${contact.remark}');
  }

  // Close the sink
  csvSink.close();
}

    

