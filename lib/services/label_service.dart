import 'package:flutter/foundation.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:csv/csv.dart';
import 'package:json_serializable/json_serializable.dart';
import 'package:services/translate_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:services/snackbar_service.dart';
import 'package:utils/predefined_labels.dart';


part 'label_service.g.dart';

@JsonSerializable()
class Label {
  final String id; // 标签 ID
  final String name; // 标签名称
  final String avatar; // 标签头像
  final String label; // 标签文本内容

  Label({
    required this.id,
    required this.name,
    required this.avatar,
    required this.label,
  });

  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);

  Map<String, dynamic> toJson() => _$LabelToJson(this);
}

// 数据库实例
class LabelService {
  final Database database;

  LabelService({required this.database});

  // 获取所有标签
  Future<List<Label>> getAllLabels() async {
    final List<Map<String, dynamic>> maps = await database.query('labels');
    return List.generate(maps.length, (i) => Label.fromJson(maps[i]));
  }
  
  // 获取标签 by ID
  Future<Label> getLabelById(String id) async {
    final List<Map<String, dynamic>> maps =
        await database.query('labels', where: 'id = ?', whereArgs: [id]);
    return Label.fromJson(maps.first);
  }

  // 添加标签
  Future<void> addLabel(Label label) async {
    await database.insert('labels', label.toJson());
  }

  // 更新标签
  Future<void> updateLabel(Label label) async {
    await database.update('labels', label.toJson(), where: 'id = ?', whereArgs: [label.id]);
  }

  // 删除标签
  Future<void> deleteLabel(Label label) async {
    await database.delete('labels', where: 'id = ?', whereArgs: [label.id]);
  }

  // 获取号码的标签
  Future<List<Label>> getLabelsForPhoneNumber(String phoneNumber) async {
    // 获取通话记录Get call logs
    final List<CallLogEntry> callLogEntries = await CallLog.getCallLogs();

    // 获取联系人Get contact
    final Contact contact = await FlutterContacts.getContact(phoneNumber);

    // Get labels from database1. 首先从数据库获取所有标签
    final labels = await getAllLabels();

    // 2. 如果数据库中没有标签，则创建预设标签
    if (labels.isEmpty) {
      await database.batch((batch) => _predefinedLabels.forEach((label) => batch.insert('labels', label.toJson())));
    }

    // 3. 根据号码属性选择预设头像
    for (final Label label in labels) {
      if (phoneNumber.contains(label.label)) {
        label.avatar = 'assets/avatars/${label.label}.png';
        break;
      }
    }

    // 4. 翻译标签名称
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

  // New function for exporting labeled numbers
    Future<void> exportLabeledNumbers({required String directory}) async {
    try {
      // 获取标记的电话号码（获取标记的电话号码）
      final labeledNumbers = await _getLabeledNumbers();

      // 准备 CSV 数据（准备 CSV 数据）
      final List<List<String>> csvData = [
        ['Label', 'Phone Number'], // 标题行（标题行）
        ...labeledNumbers.map((data) => [data['label'], data['phoneNumber']]),
      ];

      // 选择目录（选择目录）
      final directoryPath = directory.isEmpty
          ? await _getDefaultDirectoryPath() // 使用默认目录（使用默认目录）
          : directory;

      // 创建带有时间戳的文件名（创建带有时间戳的文件名）
      final filename = 'labeled_numbers_${DateTime.now().millisecondsSinceEpoch}.csv';
      final filePath = '$directoryPath/$filename';

      // 将 CSV 数据写入文件（将 CSV 数据写入文件）
      await File(filePath).writeAsString(CsvList.from(csvData).toString());

      // 显示成功消息（显示成功消息）
      SnackbarService.showSuccessSnackBar('Labeled numbers exported successfully to $filePath');
    } catch (error) {
      // 显示错误消息（显示错误消息）
      SnackbarService.showErrorSnackBar('Error exporting labeled numbers: $error');
    }
  }

  // 获取标记的号码信息（获取标记的号码信息）
  Future<List<Map<String, dynamic>>> _getLabeledNumbers() async {
    final sql = '''
      SELECT l.label AS label, cl.phone_number
      FROM labels l
      INNER JOIN label_call_log lcl ON l.id = lcl.label_id
      INNER JOIN call_log cl ON cl.id = lcl.call_log_id
    ''';

    // 执行 SQL 查询并获取结果（执行 SQL 查询并获取结果）
    final results = await database.rawQuery(sql);
    return results.toList();
  }

  // 获取默认目录路径（获取默认目录路径）
  Future<String> _getDefaultDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
