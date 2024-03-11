import 'package:flutter/material.dart';

// ... (other imports)

class Subscription {
  final int id;
  final String name; // 订阅名称
  final String vcfUrl;
  final DateTime lastUpdated;
  final bool isAutoUpdate;
  final int? interval; // 更新间隔
  final String? remark; // 备注

  Subscription({
    required this.id,
    required this.name,
    required this.vcfUrl,
    required this.lastUpdated,
    required this.isAutoUpdate,
    this.interval,
    this.remark,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    id: json['id'],
    name: json['name'],
    vcfUrl: json['vcf_url'],
    lastUpdated: DateTime.parse(json['last_updated']),
    isAutoUpdate: json['is_auto_update'] == 1,
    interval: json['interval'],
    remark: json['remark'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'vcf_url': vcfUrl,
    'last_updated': lastUpdated.toIso8601String(),
    'is_auto_update': isAutoUpdate ? 1 : 0,
    'interval': interval,
    'remark': remark,
  };

  // ... (additional methods)
}
