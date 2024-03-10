import 'package:flutter/foundation.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:csv/csv.dart';
import 'package:json_serializable/json_serializable.dart';
import 'package:services/translate_service.dart';

part 'label_service.g.dart';

@JsonSerializable()
class Label {
  final String id;
  final String name;
  final String avatar;

  Label({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);

  Map<String, dynamic> toJson() => _$LabelToJson(this);
}

class LabelService {
  final Database database;

  LabelService({required this.database});

  Future<List<Label>> getAllLabels() async {
    final List<Map<String, dynamic>> maps = await database.query('labels');
    return List.generate(maps.length, (i) => Label.fromJson(maps[i]));
  }

  Future<Label> getLabelById(String id) async {
    final List<Map<String, dynamic>> maps =
        await database.query('labels', where: 'id = ?', whereArgs: [id]);
    return Label.fromJson(maps.first);
  }

  Future<void> addLabel(Label label) async {
    await database.insert('labels', label.toJson());
  }

  Future<void> updateLabel(Label label) async {
    await database.update('labels', label.toJson(), where: 'id = ?', whereArgs: [label.id]);
  }

  Future<void> deleteLabel(Label label) async {
    await database.delete('labels', where: 'id = ?', whereArgs: [label.id]);
  }

  Future<List<Label>> getLabelsForPhoneNumber(String phoneNumber) async {
    // 获取通话记录Get call logs
    final List<CallLogEntry> callLogEntries = await CallLog.getCallLogs();

    // 获取联系人Get contact
    final Contact contact = await FlutterContacts.getContact(phoneNumber);

    // 根据号码属性选择预设头像Choose avatar based on number attribute
    String avatar;
    switch (phoneNumber) {
      case 'Delivery':
        avatar = 'assets/avatars/Delivery.png';
        break;
      case 'takeaway':
        avatar = 'assets/avatars/takeaway.png';
        break;
      case 'finance':
        avatar = 'assets/avatars/finance.png';
        break;
      case 'insurance':
        avatar = 'assets/avatars/insurance.png';
        break;
      case 'advertisement':
        avatar = 'assets/avatars/advertisement.png';
        break;
      case 'fraud':
        avatar = 'assets/avatars/fraud.png';
        break;
      case 'unknown':
        avatar = 'assets/avatars/unknown.png';
        break;
      case 'bank':
        avatar = 'assets/avatars/bank.png';
        break;
      case 'ecommerce':
        avatar = 'assets/avatars/ecommerce.png';
        break;
      case 'harassment':
        avatar = 'assets/avatars/harassment.png';
        break;
      default:
        avatar = 'assets/avatars/unknown.png';
    }

    // 创建标签
    final List<Label> labels = [
      Label(id: '1', name: 'Delivery', avatar: avatar),
      Label(id: '2', name: 'takeaway', avatar: avatar),
      Label(id: '3', name: 'finance', avatar: avatar),
      Label(id: '4', name: 'insurance', avatar: avatar),
      Label(id: '5', name: 'advertisement', avatar: avatar),
      Label(id: '6', name: 'fraud', avatar: avatar),
      Label(id: '7', name: 'unknown', avatar: avatar),
      Label(id: '8', name: 'bank', avatar: avatar),
      Label(id: '9', name: 'ecommerce', avatar: avatar),
      Label(id: '10', name: 'harassment', avatar: avatar),
     ];
    // Get translated label names
      final Locale locale = Localizations.localeOf(context);
        for (var i = 0; i < labels.length; i++) {
        labels[i].name = _translations[locale.languageCode][labels[i].name];
    }


    // 将标签与通话记录关联Associate labels with call logs
    for (final CallLogEntry callLogEntry in callLogEntries) {
      if (callLogEntry.phoneNumber == phoneNumber) {
        for (final Label label in labels) {
          await database.insert('label_call_log', {
            'label_id': label.id,
            'call_log_id': callLogEntry.id,
          });
        }
      }
    }
    return labels;
  }
}

    
    
