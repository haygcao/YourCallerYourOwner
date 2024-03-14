import 'package:models/wildcard_data.dart';
class WildcardPattern {
  final int id;
  final String pattern;
  final String description;
  final bool isBlacklisted;
  final DateTime createdAt;
  final DateTime updatedAt;

  WildcardPattern({
    this.id,
    required this.pattern,
    required this.description,
    required this.isBlacklisted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WildcardPattern.fromJson(Map<String, dynamic> json) {
    return WildcardPattern(
      id: json['id'],
      pattern: json['pattern'],
      description: json['description'],
      isBlacklisted: json['is_blacklisted'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'pattern': pattern,
    'description': description,
    'is_blacklisted': isBlacklisted ? 1 : 0,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
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
