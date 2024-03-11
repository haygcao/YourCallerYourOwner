// models/subscription_model.dart

part of 'subscription_service.dart';

@JsonSerializable()
class Subscription {
  final String id;
  final String name;
  final String url;

  Subscription({
    required this.id,
    required this.name,
    required this.url,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);
}

