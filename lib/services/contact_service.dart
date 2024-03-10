import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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

  Future<void> importContacts(String format, String filePath) async {
    // Get application documents directory
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;

    // Import based on format
    switch (format) {
      case 'csv':
        await _importCsvContacts(path, filePath);
        break;
      case 'vcf':
        await _importVcfContacts(path, filePath);
        break;
      case 'json':
        await _importJsonContacts(path, filePath);
        break;
      case 'txt':
        await _importTxtContacts(path, filePath);
        break;
    }
  }

  Future<void> exportContacts(String format) async {
    // Get application documents directory
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;

    // Export based on format
    switch (format) {
      case 'csv':
        await _exportCsvContacts(path);
        break;
      case 'vcf':
        await _exportVcfContacts(path);
        break;
      case 'json':
        await _exportJsonContacts(path);
        break;
      case 'txt':
        await _exportTxtContacts(path);
        break;
    }
  }

  // Implement import/export logic for each format

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
      );
      await addContact(contact);
    }
  }

  // TODO: Implement VCF import
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
        }

        // Read next line
        line = lines.next;
      }

      // Add contact to database
      await addContact(contact);
    }
  }
}


  // TODO: Implement JSON import
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


  // TODO: Implement TXT import
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
    );
    await addContact(contact);
  }
}


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
    savePath = '$defaultPath/contacts.$format';
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

    

