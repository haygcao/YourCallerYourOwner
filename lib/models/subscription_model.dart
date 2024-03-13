
import 'package:sqflite/sqflite.dart';

class SubscriptionModel {
  final int id;
  final String name;
  final String phoneNumber;
  final bool enabled;
  final String url;
  final bool isWhitelist;
  final bool isBlacklist;

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.enabled,
    required this.isWhitelist,
    required this.isBlacklist,
    required this.url,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);
}


