import 'dart:async';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:json_serializable/json_serializable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:services/snackbar_service.dart';
import 'package:services/subscription_service.dart';
import 'utils/get_default_external_dir.dart';

void main() async {
  // 初始化数据库
  final database = await openDatabase(
    'subscriptions.db',
    version: 1,
  );

  // 创建 SubscriptionService 实例
  final subscriptionService = SubscriptionService(database);

  // 选择导出类型
  final exportType = await _chooseExportType();

  // 选择导出格式
  final exportFormat = await _chooseExportFormat();

  // 选择导出文件夹
  final directory = await _chooseDirectory();

  // 导出数据
  if (exportType == 'all') {
    _exportAllSubscriptions(subscriptionService, directory, exportFormat);
  } else if (exportType == 'whitelist') {
    _exportSubscriptions(subscriptionService, directory, exportFormat, 'whitelisted');
  } else if (exportType == 'blacklist') {
    _exportSubscriptions(subscriptionService, directory, exportFormat, 'blacklisted');
  } else {
    return;
  }

  // 显示成功提示
  print('导出成功！');
}

Future<String> _chooseExportType() async {
  final options = ['全部', '白名单', '黑名单'];
  final index = await showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('选择导出类型'),
      content: Text('请选择要导出的数据类型'),
      actions: <Widget>[
        for (var i = 0; i < options.length; i++)
          TextButton(
            child: Text(options[i]),
            onPressed: () => Navigator.pop(context, i),
          ),
      ],
    ),
  );
  return options[index];
}

Future<String> _chooseExportFormat() async {
  final options = ['CSV', 'JSON', 'TXT'];
  final index = await showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('选择导出格式'),
      content: Text('请选择要导出的数据格式'),
      actions: <Widget>[
        for (var i = 0; i < options.length; i++)
          TextButton(
            child: Text(options[i]),
            onPressed: () => Navigator.pop(context, i),
          ),
      ],
    ),
  );
  return options[index].toLowerCase();
}

Future<Directory> _chooseDirectory() async {
  final directoryPath = await pickDirectory();

  // 用户未选择文件夹
  if (directoryPath == null) {
    throw Exception('用户未选择文件夹');
  } else {
    // 显示错误提示
    SnackbarService.showErrorSnackBar('用户未选择文件夹，将使用默认目录');

    // 使用默认目录
    directoryPath = await _getDefaultExternalStorageDirectory();
  }

  return Directory(directoryPath);
}


Future<void> _exportAllSubscriptions(SubscriptionService subscriptionService, Directory directory, String exportFormat) async {
  // 使用 SubscriptionService 获取全部数据
  final subscriptions = await subscriptionService.getAllSubscriptions();
  final csvData = CsvUtils.generate(subscriptions);
  final jsonData = jsonEncode(subscriptions);
  final txtData = subscriptions.map((subscription) => subscription.toString()).join('\n');
  final file = File('
