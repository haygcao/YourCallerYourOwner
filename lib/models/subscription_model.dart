
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


