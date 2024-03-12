import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:services/snackbar_service.dart';
import 'package:utils/get_default_external_dir.dart';



class BackupRestoreService {
  final String databasePath;

  BackupRestoreService(this.databasePath);

  /// 备份用户数据
  Future<void> backup() async {

    // 选择备份路径
    final backupDirectory = await showDirectoryPicker(
      context: context,
      initialDirectory: databaseFile.parent.path,
    );

    // 如果用户取消了选择，则使用默认目录
    if (backupDirectory == null) {
      backupDirectory = await _getDefaultExternalStorageDirectory();
      showSuccessSnackBar('存储到默认位置');
    }

    // 获取数据库文件
    final databaseFile = File(databasePath);

    // 获取临时目录
    final tempDirectory = await getTemporaryDirectory();

    // 将所有数据库导出为 JSON 文件
    final jsonFiles = await Future.wait(databasePaths.map((databasePath) async {
      final database = await openDatabase(databasePath);
      final json = await exportDatabaseToJson(database);
      final jsonFile = File(join(tempDirectory.path, '${database.databaseName}.json'));
      await jsonFile.writeAsString(json);
      return jsonFile;
    }));

    // 将 JSON 文件打包成 ZIP 文件
    final zipFile = File(join(tempDirectory.path, 'backup.zip'));
    final encoder = ZipFileEncoder();
    encoder.addFiles(jsonFiles);
    await encoder.writeToFile(zipFile);
    
    // 获取设备名称
    final deviceName = getDeviceName(); 
    // 生成备份文件名
    final backupFileName = '${deviceName}_${DateTime.now().millisecondsSinceEpoch}.zip';

    // 复制 ZIP 文件到备份目录
    try {
    await zipFile.copy(join(backupDirectory.path, backupFileName));
    showSuccessSnackBar('备份成功');
  } catch (error) {
    // Handle file copy or write error
    print('Error copying file: $error');
    showErrorSnackBar('Error backing up data: $error');
  }

}


  /// 恢复用户数据
  Future<void> restore() async {
    // 获取备份目录
    final backupDirectory = await showDirectoryPicker(
      context: context,
      initialDirectory: databaseFile.parent.path,
    );

    // 如果用户取消了选择，则使用默认目录
    if (backupDirectory == null) {
      backupDirectory = await _getDefaultExternalStorageDirectory();
      showSuccessSnackBar('存储到默认位置');
    }

      // 列出所有备份文件
  final backupFiles = await backupDirectory.list().where((file) => file.path.endsWith('.zip')).toList();
    
    // 如果没有任何备份文件，则提示用户
  if (backupFiles.isEmpty) {
    showSnackBar('没有找到备份文件，请先备份数据');
    return;
  }  
    // 选择要恢复的备份文件
  final zipFile = await showOpenFilePicker(
    context: context,
    filter: FileTypeFilter(
      allowedExtensions: ['zip'],
    ),
  );

  // 如果用户取消了选择，则返回
  if (zipFile == null) {
    return;
  }

  // 获取临时目录
  final tempDirectory = await getTemporaryDirectory();

  // 解压 ZIP 文件
  final decoder = ZipFileDecoder();
  await decoder.decodeFile(zipFile, tempDirectory);

  // 遍历 ZIP 文件中的文件
  final jsonFiles = await tempDirectory.list().where((file) => file.path.endsWith('.json')).toList();

    
  // 覆盖数据库文件
    // 导入 JSON 文件
  for (final jsonFile in jsonFiles) {
    final databaseName = jsonFile.path.split('/').last.split('.').first;
    final database = await openDatabase(databaseName);
    final json = await jsonFile.readAsString();  
  try {
    await backupFile.copy(databasePath);
    showSuccessSnackBar('恢复成功');
  } catch (error) {
    // Handle file copy or write error
    print('Error copying file: $error');
    SnackbarService.showErrorSnackBar('恢复失败: 无法覆盖数据库文件');
  }
}




