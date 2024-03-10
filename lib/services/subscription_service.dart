import 'package:flutter/foundation.dart';

import 'package:csv/csv.dart';

import 'package:json_serializable/json_serializable.dart';

import 'package:http/http.dart';

import 'package:hive/hive.dart';

import 'package:provider/provider.dart';



part 'subscription_model.g.dart';



class SubscriptionService {

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

  // 将订阅添加到白名单

  _whitelist.add(subscription);

 }



 void removeSubscriptionFromWhitelist(Subscription subscription) {

  // 将订阅从白名单中删除

  _whitelist.remove(subscription);

 }



 void addSubscriptionToBlacklist(Subscription subscription) {

  // 将订阅添加到黑名单

  _blacklist.add(subscription);

 }



 void removeSubscriptionFromBlacklist(Subscription subscription) {

  // 将订阅从黑名单中删除

  _blacklist.remove(subscription);

 }



 // 根据订阅规则处理来电

 bool shouldAcceptCall(String phoneNumber) {

  // 检查号码是否在白名单中

  if (_whitelist.contains(phoneNumber)) {

   return true;

  }



  // 检查号码是否在黑名单中

  if (_blacklist.contains(phoneNumber)) {

   return false;

  }



  // 允许所有来电

  return true;

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
