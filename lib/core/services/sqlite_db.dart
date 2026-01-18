import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteDb {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'turismo_app.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE places_min (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        last_scanned INTEGER NOT NULL
      )
    ''');
  }
}
