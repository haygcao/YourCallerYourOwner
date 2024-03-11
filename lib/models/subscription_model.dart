// models/subscription_entity.dart

part of 'subscription_service.dart';

import 'package:floor/floor.dart';

// 定义数据库实体
@entity
class SubscriptionEntity {
  @primaryKey
  final int id;

  final String name;

  final String number;

  final bool enabled;

  final bool isWhitelist;

  final bool isBlacklist;

  SubscriptionEntity(
      this.id,
      this.name,
      this.number,
      this.enabled,
      this.isWhitelist,
      this.isBlacklist);
}

// 定义数据库
@database
class AppDatabase {
  // 定义数据库版本
  static const int version = 100;

  // 定义数据库中的表
  @dao
  SubscriptionEntityDao get subscriptionEntityDao;
}

// 定义数据访问对象
@dao
abstract class SubscriptionEntityDao {
  // 插入订阅
  @insert
  Future<void> insertSubscriptionEntity(SubscriptionEntity subscriptionEntity);

  // 查询所有订阅
  @query
  Future<List<SubscriptionEntity>> getAllSubscriptionEntities();

  // 根据 ID 查询订阅
  @query
  Future<SubscriptionEntity> getSubscriptionEntityById(int id);

  // 更新订阅
  @update
  Future<void> updateSubscriptionEntity(SubscriptionEntity subscriptionEntity);

  // 删除订阅
  @delete
  Future<void> deleteSubscriptionEntity(SubscriptionEntity subscriptionEntity);

  // 查询白名单订阅
  @query
  Future<List<SubscriptionEntity>> getWhitelistSubscriptionEntities();

  // 查询黑名单订阅
  @query
  Future<List<SubscriptionEntity>> getBlacklistSubscriptionEntities();

  // 根据号码查询订阅
  @query
  Future<SubscriptionEntity> getSubscriptionEntityByNumber(String number);

  // 根据是否启用查询订阅
  @query
  Future<List<SubscriptionEntity>> getSubscriptionEntitiesByEnabled(bool enabled);
}
