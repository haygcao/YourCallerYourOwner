import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:webdav_client/webdav_client.dart';

class WebDavService {
  WebDavService({
    required this.url,
    required this.username,
    required this.password,
  }) {
    _client = WebDavClient(
      url: url,
      username: username,
      password: password,
    );
  }

  final String url;
  final String username;
  final String password;

  late WebDavClient _client;

  Future<void> backup() async {
    final dir = Directory.current;
    final files = dir.listSync(recursive: true);

    final backupDirName = backupName ?? 'ycyo';

    await _client.mkdir(backupDirName);

    for (final file in files) {
      final path = file.path;
      final relativePath = relative(path, from: dir.path);

      if (file is File) {
        await _client.uploadFile('$backupDirName/$relativePath', file);
      } else if (file is Directory) {
        await _client.mkdir('$backupDirName/$relativePath');
      }
    }
  }

  Future<void> restore({String? backupName}) async {
    final dir = Directory.current;

    final backupDirName = backupName ?? 'ycyo';

    final files = await _client.list(backupDirName);
    for (final file in files) {
      final path = file.path;
      final localPath = join(dir.path, path);

      if (file is WebDavFile) {
        await _client.downloadFile(path, localPath);
      } else if (file is WebDavDirectory) {
        await Directory(localPath).create(recursive: true);
      }
    }
  }
}

