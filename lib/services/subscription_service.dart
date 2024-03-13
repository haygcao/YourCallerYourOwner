import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:path/path.dart';

import 'package:json_serializable/json_serializable.dart';

import 'package:http/http.dart';

import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:services/blacklist_whitelist_service.dart';
import 'package:services/snackbar_service.dart';
import 'package:utils/get_default_external_dir.dart';
import 'package:models/subscription_model.dart';
import 'package:utils/call_filter.dart';

part 'subscription_model.g.dart';




  SubscriptionService({required this.database});
  // 数据库实例
  class SubscriptionService {
  // 数据库实例
  final Database database;
  // 白名单订阅
  late final List<Subscription> _whitelist = [];
  // 黑名单订阅
  late final List<Subscription> _blacklist = [];
  // 所有订阅
  late final List<Subscription> _subscriptions = [];
  // 自动更新计时器
  late Timer _autoUpdateTimer;
     SubscriptionService({required Database database}) : _database = database {
    // 初始化订阅数据
    _initSubscriptions();
  }

     // 获取所有订阅
  Future<List<SubscriptionModel>> getAllSubscriptions() async {
    final List<Map<String, dynamic>> maps = await database.query('subscriptions');
    return List.generate(maps.length,
        (i) => SubscriptionModel.fromJson(maps[i]));
  }

  // 插入订阅
  Future<void> insertSubscription(SubscriptionModel subscription) async {
    await database.insert('subscriptions', subscription.toJson());
  }

  // 根据 ID 查询订阅
  Future<SubscriptionModel> getSubscriptionById(int id) async {
    final List<Map<String, dynamic>> maps =
        await database.query('subscriptions', where: 'id = ?', whereArgs: [id]);
    return SubscriptionModel.fromJson(maps.first);
  }

  // 更新订阅
  Future<void> updateSubscription(SubscriptionModel subscription) async {
    await database.update('subscriptions', subscription.toJson(),
        where: 'id = ?', whereArgs: [subscription.id]);
  }

  // 删除订阅
  Future<void> deleteSubscription(SubscriptionModel subscription) async {
    await database.delete('subscriptions', where: 'id = ?', whereArgs: [subscription.id]);
  }

  // 查询白名单订阅
  Future<List<SubscriptionModel>> getWhitelistSubscriptions() async {
    final List<Map<String, dynamic>> maps = await database
        .query('subscriptions', where: 'is_whitelist = ?', whereArgs: [true]);
    return List.generate(maps.length,
        (i) => SubscriptionModel.fromJson(maps[i]));
  }

  // 查询黑名单订阅
  Future<List<SubscriptionModel>> getBlacklistSubscriptions() async {
    final List<Map<String, dynamic>> maps = await database
        .query('subscriptions', where: 'is_blacklist = ?', whereArgs: [true]);
    return List.generate(maps.length,
        (i) => SubscriptionModel.fromJson(maps[i]));
  }

  // 根据号码查询订阅
  Future<SubscriptionModel> getSubscriptionByphoneNumber(String phoneNumber) async {
    final List<Map<String, dynamic>> maps = await database
        .query('subscriptions', where: 'phoneNumber = ?', whereArgs: [phoneNumber]);
    return SubscriptionModel.fromJson(maps.first);
  }

  // 根据是否启用查询订阅
  Future<List<SubscriptionModel>> getSubscriptionsByEnabled(bool enabled) async {
    final List<Map<String, dynamic>> maps = await database
        .query('subscriptions', where: 'enabled = ?', whereArgs: [enabled]);
    return List.generate(maps.length,
        (i) => SubscriptionModel.fromJson(maps[i]));
  }
}
 // 管理订阅白名单和黑名单

void addSubscriptionToWhitelist(Subscription subscription) {
  // 将订阅添加到白名单，并避免重复添加
  if (!_whitelist.contains(subscription)) {
    _whitelist.add(subscription);
  }
}

void removeSubscriptionFromWhitelist(Subscription subscription) {
  // 将订阅从白名单中删除
  _whitelist.remove(subscription);
}

void addSubscriptionToBlacklist(Subscription subscription) {
  // 将订阅添加到黑名单，并避免重复添加
  if (!_blacklist.contains(subscription)) {
    _blacklist.add(subscription);
  }
}

  void removeSubscriptionFromBlacklist(Subscription subscription) {
    // 将订阅从黑名单中删除
    _blacklist.remove(subscription);
  }
 // 从本地文件导入订阅数据

Future<List<Subscription>> importSubscriptionsFromFile() async {
  // 使用文件选择器选择文件
  final FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.any,
  );

  // 检查用户是否选择了文件
  if (result != null && result.files.single != null) {
    final String filePath = result.files.single.path;

  // 根据文件类型解析数据

  if (_isCsvFile(filePath)) {

   return _importSubscriptionsFromCsvFile(filePath);

  } else if (_isJsonFile(filePath)) {

   return _importSubscriptionsFromJsonFile(filePath);

  } else {

   throw Exception('Invalid file format');
         // 显示错误消息
   showErrorSnackBar('Invalid file format');
    }
  } else {
    // 用户未选择文件
    return [];
  }
}



 // 从 GitHub 连接等远程 URL 导入订阅数据

  Future<List<Subscription>> importSubscriptionsFromUrl(String url) async {

    try {
      // 从 URL 获取数据
      String data = await _getDataFromUrl(url);

      // 解析数据
      List<Subscription> subscriptions = _parseData(data);
       
      // 更新本地数据
      _subscriptions.clear();
      _subscriptions.addAll(subscriptions);
       
      // 返回订阅数据
      return subscriptions;
    } catch (e) {
      // 显示错误消息
      if (e is Exception && e.message == 'URL not found') {
        showErrorSnackBar('URL not found');
      } else {
        rethrow;
      }
    }

  }

  // 添加订阅名称
  void addSubscriptionName(Subscription subscription, String name) {
    // 将名称添加到订阅中
    subscription.name = name;
  }

    Future<void> importSubscriptions(List<Subscription> subscriptions) async {
   
    // 将订阅的号码添加到黑白名单
    for (Subscription subscription in subscriptions) {
      if (subscription.isBlacklist) {
        BlacklistService.instance.add(BlacklistEntry(
          avatar: subscription.avatar,
          label: subscription.label,
          phoneNumber: subscription.phoneNumber,
          name: subscription.name,
          isSubscribed: true,
        ));
      } else if (subscription.isWhitelist) {
        WhitelistService.instance.add(WhitelistEntry(
          avatar: subscription.avatar,
          label: subscription.label,
          phoneNumber: subscription.phoneNumber,
          name: subscription.name,
          isSubscribed: true,
        ));
      }
    }
  }



 // 根据订阅规则处理来电

void handleIncomingCall(String phoneNumber) {
  if (CallFilter.shouldAcceptCall(phoneNumber)) {
    // 接听来电
  } else {
    // 拒绝来电
  }
}

   // 手动更新订阅数据
  void updateSubscriptions() async {
    // 实现手动更新逻辑
    List<Subscription> subscriptions = await _getSubscriptions();

    // 更新本地数据
    _subscriptions.clear();
    _subscriptions.addAll(subscriptions);
  }

  // 删除订阅
  void deleteSubscription(Subscription subscription) {
    // 从本地数据中删除订阅
    if (_subscriptions.remove(subscription)) {
      // 显示成功消息
      SnackbarService.showSuccessSnackBar('Subscription deleted successfully');
    } else {
      // 显示错误消息
      showErrorSnackBar('Subscription not found');
    }
  }



  // 启动自动更新
  void startAutoUpdate() {
    // 定期执行更新任务
    _autoUpdateTimer = Timer.periodic(Duration(hours: 1), (timer) async {
      // 仅当通过网络连接导入数据时触发自动更新
      if (_isImportingFromUrl) {
        await updateSubscriptions();
      }
    });
  }



  // 停止自动更新
  void stopAutoUpdate() {
    // 取消定时任务
    _autoUpdateTimer.cancel();
  }

void exportSubscriptions(List<Subscription> subscriptions) async {
  // 选择目录
  String? directoryPath = await pickDirectory();

  // 如果用户没有选择目录，则使用默认目录
  if (directoryPath == null) {
    directoryPath = await _getDefaultExternalStorageDirectory();
  }

  // 选择导出格式
  String? type = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('选择导出格式'),
      content: Text('请选择要导出的文件格式'),
      actions: <Widget>[
        TextButton(
          child: Text('CSV'),
          onPressed: () => Navigator.pop(context, 'csv'),
        ),
        TextButton(
          child: Text('JSON'),
          onPressed: () => Navigator.pop(context, 'json'),
        ),
      ],
    ),
  );

  // 如果用户没有选择导出格式，则取消导出
  if (type == null) {
    return;
  }

  // 生成文件名
  String fileName = 'subscriptions.$type';

  // 生成文件路径
  String filePath = '$directoryPath/$fileName';

  // 导出数据
  if (type == 'csv') {
    exportSubscriptionsToCsv(subscriptions, filePath);
  } else if (type == 'json') {
    exportSubscriptionsToJson(subscriptions, filePath);
  }

  // 显示成功提示
  showSuccessSnackBar(
    message: '导出成功！',
  );
}
 // 导出订阅数据为 CSV 文件

 void exportSubscriptionsToCsv(List<Subscription> subscriptions, String filePath) {

  // 使用 CSV 生成库生成 CSV 数据

  String data = CsvUtils.generate(subscriptions);



  // 将 CSV 数据写入文件

  _writeCsvFile(filePath, data);

 }



 // 导出订阅数据为 JSON 文件

 void exportSubscriptionsToJson(List<Subscription> subscriptions, String filePath) {

  // 使用 JSON 生成库生成 JSON 数据

  String data = JsonUtils.encode(subscriptions);



  // 将 JSON 数据写入文件

  _writeJsonFile(filePath, data);

 }


 // 从 CSV 文件导入订阅数据的私有方法

 Future<List<Subscription>> _importSubscriptionsFromCsvFile(String filePath) async {

  // 读取 CSV 文件

  String data = await _readCsvFile(filePath);



  // 解析数据

  List<Subscription> subscriptions = _parseData(data);



  // 返回订阅对象列表

  return subscriptions;

 }



 // 从 JSON 文件导入订阅数据的私有方法

 Future<List<Subscription>> _importSubscriptionsFromJsonFile(String filePath) async {

  // 读取 JSON 文件

  String data = await _readJsonFile(filePath);



  // 解析数据

  List<Subscription> subscriptions = _parseData(data);



  // 返回订阅对象列表

  return subscriptions;

 }



 // 从 URL 获取数据的私有方法

 Future<String> _getDataFromUrl(String url) async {

  // 使用 HTTP 库从 URL 获取数据

  Response response = await get(url);



  // 检查响应状态

  if (response.statusCode != 200) {

   throw Exception('HTTP request failed with status code ${response.statusCode}');

  }



  // 返回响应体

  return response.body;

 }



 // 判断是否是 CSV 文件的私有方法

 bool _isCsvFile(String filePath) {

  // 获取文件扩展名

  String extension = filePath.split('.').last;



  // 检查扩展名是否为 `.csv`

  return extension == 'csv';

 }



 // 判断是否是 JSON 文件的私有

bool _isJsonFile(String filePath) {

 // 获取文件扩展名

 String extension = filePath.split('.').last;



 // 检查扩展名是否为 `.json`

 return extension == 'json';

}
