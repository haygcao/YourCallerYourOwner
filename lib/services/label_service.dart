import 'package:flutter/foundation.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:csv/csv.dart';
import 'package:json_serializable/json_serializable.dart';

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
    // 获取通话记录
    final List<CallLogEntry> callLogEntries = await CallLog.getCallLogs();

    // 获取联系人
    final Contact contact = await FlutterContacts.getContact(phoneNumber);

    // 根据号码属性选择预设头像
    String avatar;
    switch (phoneNumber) {
      case '快递':
        avatar = 'assets/avatars/courier.png';
        break;
      case '外卖':
        avatar = 'assets/avatars/takeaway.png';
        break;
      case '金融理财':
        avatar = 'assets/avatars/finance.png';
        break;
      case '保险':
        avatar = 'assets/avatars/insurance.png';
        break;
      case '广告':
        avatar = 'assets/avatars/advertisement.png';
        break;
      case '疑似诈骗':
        avatar = 'assets/avatars/fraud.png';
        break;
      case '未知':
        avatar = 'assets/avatars/unknown.png';
        break;
      case '银行':
        avatar = 'assets/avatars/bank.png';
        break;
      case '电商':
        avatar = 'assets/avatars/ecommerce.png';
        break;
      case '骚扰电话':
        avatar = 'assets/avatars/harassment.png';
        break;
      default:
        avatar = 'assets/avatars/unknown.png';
    }

    // 创建标签
    final List<Label> labels = [
      Label(id: '1', name: '快递', avatar: avatar),
      Label(id: '2', name: '外卖', avatar: avatar),
      Label(id: '3', name: '金融理财', avatar: avatar),
      Label(id: '4', name: '保险', avatar: avatar),
      Label(id: '5', name: '广告', avatar: avatar),
      Label(id: '6', name: '疑似诈骗', avatar: avatar),
      Label(id: '7', name: '未知', avatar: avatar),
      Label(id: '8', name: '银行', avatar: avatar),

