class BlacklistEntry {
  final String avatar;
  final String label;
  final String phoneNumber;
  final String name;
  final bool isSubscribed;

  BlacklistEntry({
    required this.avatar,
    required this.label,
    required this.phoneNumber,
    required this.name,
    required this.isSubscribed,
  });
}

class WhitelistEntry {
  final String avatar;
  final String label;
  final String phoneNumber;
  final String name;
  final bool isSubscribed;

  WhitelistEntry({
    required this.avatar,
    required this.label,
    required this.phoneNumber,
    required this.name,
    required this.isSubscribed,
  });
}
