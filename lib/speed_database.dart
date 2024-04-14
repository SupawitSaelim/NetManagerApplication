import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SpeedDatabase {
  static final SpeedDatabase instance = SpeedDatabase._init();

  static Database? _database;

  SpeedDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('speed.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE speeds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        downloadRate REAL,
        uploadRate REAL,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertSpeed(Map<String, dynamic> row) async {
    final Database db = await instance.database;
    return await db.insert('speeds', row);
  }

  Future<List<Map<String, dynamic>>> queryAllSpeeds() async {
    final Database db = await instance.database;
    return await db.query('speeds');
  }
  
  Future<void> deleteAllSpeeds() async {
    final Database db = await instance.database;
    await db.delete('speeds');
  }
}
