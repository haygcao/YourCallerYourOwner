import 'dart:async';

import 'package:file_picker/file_picker.dart';

Future<String> getDefaultExternalStorageDirectory() async {
  // Get the current directory.
  final directory = await Directory.current;

  // Open the file picker.
  final result = await picker.pickDirectory(
    initialDirectory: directory.path,
  );

  // Save the selected directory.
  if (result != null) {
    return result.path;
  }

  return null;
}
