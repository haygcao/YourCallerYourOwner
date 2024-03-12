part of 'subscription_service.dart';

import 'package:sqflite/sqflite.dart';

class SubscriptionModel {
  final int id;
  final String name;
  final String number;
  final bool enabled;
  final bool isWhitelist;
  final bool isBlacklist;

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.number,
    required this.enabled,
    required this.isWhitelist,
    required this.isBlacklist,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);
}

// 数据库实例
class SubscriptionService {
  final Database database;

  SubscriptionService({required this.database});

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
  Future<SubscriptionModel> getSubscriptionByNumber(String number) async {
    final List<Map<String, dynamic>> maps = await database
        .query('subscriptions', where: 'number = ?', whereArgs: [number]);
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
