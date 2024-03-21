import 'package:json_annotation/json_annotation.dart';

part 'label.g.dart';

@JsonSerializable()
class Label {
  final String id; // 标签 ID
  final String? name; // 标签名称
  final String? avatar; // 标签头像
  final String label; // 标签文本内容

  Label({
    required this.id,
    this.name,
    this.avatar,
    required this.label,
    required this.phoneNumber,
  });

  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);

  Map<String, dynamic> toJson() => _$LabelToJson(this);
}

