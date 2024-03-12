import 'package:sqflite/sqflite.dart';
class LocationData {
  final int id;
  final String region;
  final String province;
  final String carrier;
  final bool isLocalNumber;

  LocationData({
    this.id,
    required this.region,
    required this.province,
    required this.carrier,
    required this.isLocalNumber,
  });

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      id: map['id'],
      region: map['region'],
      province: map['province'],
      carrier: map['carrier'],
      isLocalNumber: map['isLocalNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'region': region,
      'province': province,
      'carrier': carrier,
      'isLocalNumber': isLocalNumber,
    };
  }
}
class DatabaseHelper {
  static final _databaseName = "location.db";
  static final _databaseVersion = 1;

  Database _database;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE location (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            region TEXT NOT NULL,
            province TEXT NOT NULL,
            carrier TEXT NOT NULL,
            isLocalNumber INTEGER NOT NULL
          )
          ''');
        });
  }

  Future<int> insertLocation(LocationData location) async {
    Database db = await database;
    return await db.insert('location', location.toMap());
  }

  Future<List<LocationData>> getAllLocations() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('location');
    return maps.map((map) => LocationData.fromMap(map)).toList();
  }
}

