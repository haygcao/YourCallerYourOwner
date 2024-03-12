import 'package:flutter/services.dart';

class SecureStorage {
  static const _urlKey = 'webdav_url';
  static const _usernameKey = 'webdav_username';
  static const _passwordKey = 'webdav_password';

  Future<String?> read(String key) async {
    try {
      final value = await FlutterSecureStorage().getString(key);
      return value;
    } on PlatformException catch (e) {
      // Handle platform exceptions (e.g., key not found)
      print('Error reading from secure storage: $e');
      return null;
    }
  }

  Future<void> write(String key, String value) async {
    await FlutterSecureStorage().setString(key, value);
  }
}
