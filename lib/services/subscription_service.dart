import 'package:flutter/foundation.dart';

import 'package:csv/csv.dart';

import 'package:json_serializable/json_serializable.dart';

import 'package:http/http.dart';

import 'package:hive/hive.dart';

import 'package:provider/provider.dart';
import 'package:models/subscription_model.dart';
import 'package:services/snackbar_service.dart';

part 'subscription_model.g.dart';



class SubscriptionService {

   late final List<Subscription> _whitelist = [];
   late final List<Subscription> _blacklist = [];
   late final List<Subscription> _subscriptions = [];
   late Timer _autoUpdateTimer;
 
 // 从本地文件导入订阅数据

 Future<List<Subscription>> importSubscriptionsFromFile(String filePath) async {

  // 根据文件类型解析数据

  if (_isCsvFile(filePath)) {

   return _importSubscriptionsFromCsvFile(filePath);

  } else if (_isJsonFile(filePath)) {

   return _importSubscriptionsFromJsonFile(filePath);

  } else {

   throw Exception('Invalid file format');

  }

 }



 // 从 GitHub 连接等远程 URL 导入订阅数据

 Future<List<Subscription>> importSubscriptionsFromUrl(String url) async {

  // 从 URL 获取数据

  String data = await _getDataFromUrl(url);



  // 解析数据

  List<Subscription> subscriptions = _parseData(data);



  // 返回订阅数据

  return subscriptions;

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

 // 根据订阅规则处理来电

bool shouldAcceptCall(String phoneNumber) {
  // 检查号码是否在白名单中
  if (_whitelist.isNotEmpty && _whitelist.contains(phoneNumber)) {
    return true;
  }

  // 检查号码是否在黑名单中
  if (_blacklist.isNotEmpty && _blacklist.contains(phoneNumber)) {
    return false;
  }

  // 允许所有来电
  return true;
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
      SnackbarService.showErrorSnackBar('Subscription not found');
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



  // 添加订阅名称
  void addSubscriptionName(Subscription subscription, String name) {
    // 将名称添加到订阅中
    subscription.name = name;
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
