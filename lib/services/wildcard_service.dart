import 'package:sqflite/sqflite.dart'; // 如果使用 SQLite 数据库
import 'package:models/wildcard_pattern.dart';

class WildcardService {
  final Database database;

  WildcardService(this.database);

  Future<void> add(WildcardPattern pattern) async {
    await database.insert('wildcard_patterns', pattern.toJson());
  }

  Future<void> update(WildcardPattern pattern) async {
    await database.update('wildcard_patterns', pattern.toJson(), where: 'id = ?', whereArgs: [pattern.id]);
  }

  Future<void> remove(WildcardPattern pattern) async {
    await database.delete('wildcard_patterns', where: 'id = ?', whereArgs: [pattern.id]);
  }

  Future<bool> matches(String phoneNumber, List<WildcardPattern> patterns) async {
    for (var pattern in patterns) {
      if (_matchesPattern(phoneNumber, pattern.pattern)) {
        return pattern.isBlacklisted;
      }
    }
    return false;
  }

  bool _matchesPattern(String phoneNumber, String pattern) {
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(phoneNumber);
  }

  Future<List<WildcardPattern>> getBlacklistedPatterns() async {
    return _getPatterns(where: 'is_blacklisted = 1');
  }

  Future<List<WildcardPattern>> getWhitelistedPatterns() async {
    return _getPatterns(where: 'is_blacklisted = 0');
  }

  Future<List<WildcardPattern>> _getPatterns({String? where}) async {
    List<Map<String, dynamic>> results = await database.query('wildcard_patterns', where: where);
    return results.map((json) => WildcardPattern.fromJson(json)).toList();
  }
}
