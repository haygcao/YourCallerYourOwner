
import 'package:sqflite/sqflite.dart';

class SubscriptionModel {
  final int id;
  final String name;
  final String phoneNumber;
  final bool enabled;
  final bool isWhitelist;
  final bool isBlacklist;
  final String？url;

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.enabled,
    required this.isWhitelist,
    required this.isBlacklist,
    this.url,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);
}


