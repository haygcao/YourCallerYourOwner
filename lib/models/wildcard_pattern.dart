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
