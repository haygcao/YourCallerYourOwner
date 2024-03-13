class BlacklistEntry {
  final int id;
  final String？ avatar;
  final String label;
  final String phoneNumber;
  final String name;
  final bool isSubscribed;

  BlacklistEntry({
    required this.id,
    this.avatar,
    required this.label,
    required this.phoneNumber,
    required this.name,
    required this.isSubscribed,
  });

  factory BlacklistEntry.fromJson(Map<String, dynamic> json) => BlacklistEntry(
        id: json['id'],
        avatar: json['avatar'],
        label: json['label'],
        phoneNumber: json['phoneNumber'],
        name: json['name'],
        isSubscribed: json['isSubscribed'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'label': label,
        'phoneNumber': phoneNumber,
        'name': name,
        'isSubscribed': isSubscribed,
      };
}

class WhitelistEntry {
  final int id;
  final String? avatar;
  final String label;
  final String phoneNumber;
  final String name;
  final bool isSubscribed;

  WhitelistEntry({
    required this.id,
    this.avatar,
    required this.label,
    required this.phoneNumber,
    required this.name,
    required this.isSubscribed,
  });

  factory WhitelistEntry.fromJson(Map<String, dynamic> json) => WhitelistEntry(
        id: json['id'],
        avatar: json['avatar'],
        label: json['label'],
        phoneNumber: json['phoneNumber'],
        name: json['name'],
        isSubscribed: json['isSubscribed'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'label': label,
        'phoneNumber': phoneNumber,
        'name': name,
        'isSubscribed': isSubscribed,
      };
}

