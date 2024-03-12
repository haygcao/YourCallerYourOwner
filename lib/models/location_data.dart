import 'package:sqflite/sqflite.dart';

class LocationDatabase {
  static final String _databaseName = "location.db";
  static final int _databaseVersion = 1;

  Database _database;

  Future<void> open() async {
    _database = await openDatabase(_databaseName, _databaseVersion,
        onCreate: (db, version) async {
      await db.execute("""
        CREATE TABLE location (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          region TEXT NOT NULL,
          province TEXT NOT NULL,
          carrier TEXT NOT NULL,
          is_local_number INTEGER NOT NULL,
          phone_number TEXT NOT NULL
        )
      """);
    });
  }

  Future<void> close() async {
    await _database.close();
  }

  Future<LocationData> insertLocation(LocationData location) async {
    await _database.insert("location", location.toMap());
    return location;
  }

  Future<List<LocationData>> getAllLocations() async {
    final List<Map<String, dynamic>> maps = await _database.query("location");
    return maps.map((map) => LocationData.fromMap(map)).toList();
  }

  Future<void> deleteLocation(int id) async {
    await _database.delete("location", where: "id = ?", whereArgs: [id]);
  }
}

class LocationData {
  final int id;
  final String region;
  final String province;
  final String carrier;
  final bool isLocalNumber;
  final String phoneNumber;

  LocationData({
    this.id,
    required this.region,
    required this.province,
    required this.carrier,
    required this.isLocalNumber,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      "region": region,
      "province": province,
      "carrier": carrier,
      "is_local_number": isLocalNumber ? 1 : 0,
      "phone_number": phoneNumber,
    };
  }

  static LocationData fromMap(Map<String, dynamic> map) {
    return LocationData(
      id: map["id"],
      region: map["region"],
      province: map["province"],
      carrier: map["carrier"],
      isLocalNumber: map["is_local_number"] == 1,
      phoneNumber: map["phone_number"],
    );
  }
}
