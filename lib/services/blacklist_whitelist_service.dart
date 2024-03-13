import 'package:your_project_name/models/blacklist_whitelist_data.dart';

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
class BlacklistService {
  final List<BlacklistEntry> _entries = [];

  void add(BlacklistEntry entry) {
    _entries.add(entry);
  }

  void remove(BlacklistEntry entry) {
    _entries.remove(entry);
  }

  bool contains(String phoneNumber) {
    return _entries.any((entry) => entry.phoneNumber == phoneNumber);
  }

  List<BlacklistEntry> getSubscribedEntries() {
    return _entries.where((entry) => entry.isSubscribed).toList();
  }

  List<BlacklistEntry> getEntries() {
    return List.unmodifiable(_entries);
  }

  BlacklistEntry? getEntryByPhoneNumber(String phoneNumber) {
    return _entries.firstWhere((entry) => entry.phoneNumber == phoneNumber);
  }
}

class WhitelistService {
  final List<WhitelistEntry> _entries = [];

  void add(WhitelistEntry entry) {
    _entries.add(entry);
  }

  void remove(WhitelistEntry entry) {
    _entries.remove(entry);
  }

  bool contains(String phoneNumber) {
    return _entries.any((entry) => entry.phoneNumber == phoneNumber);
  }

  List<WhitelistEntry> getSubscribedEntries() {
    return _entries.where((entry) => entry.isSubscribed).toList();
  }

  List<WhitelistEntry> getEntries() {
    return List.unmodifiable(_entries);
  }

  WhitelistEntry? getEntryByPhoneNumber(String phoneNumber) {
    return _entries.firstWhere((entry) => entry.phoneNumber == phoneNumber);
  }
}

