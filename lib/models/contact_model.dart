import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String remark;

  Contact({
    required this.id,
    required this.name,
    this.phoneNumber = '',
    this.email = '',
    this.remark = '',
  });

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}

