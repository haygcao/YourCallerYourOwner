import 'package:json_annotation/json_annotation.dart';

part 'contact_model.g.dart';

@JsonSerializable()
class Contact {
  final String id;
  final String name;
  final List<String> phoneNumbers; // 修改为列表
  final String email;
  final String label;

  Contact({
    required this.id,
    required this.name,
    this.phoneNumbers = const [], // 初始化为空列表
    this.email = '',
    this.label = '',
  });

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
