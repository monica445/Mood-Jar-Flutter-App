import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static const _version = 2;
  static const _dbName = "MoodJar_V2.db";
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null && _db!.isOpen) return _db!;

    final path = join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      path,
      version: _version,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
    return _db!;
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE MoodPerDay (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE MoodEntry (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        timestamp TEXT,
        reflection TEXT,
        moodPerDayId INTEGER,
        FOREIGN KEY(moodPerDayId) REFERENCES MoodPerDay(id)
      );
    ''');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE MoodEntry_new (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT,
          timestamp TEXT,
          reflection TEXT,
          moodPerDayId INTEGER,
          FOREIGN KEY(moodPerDayId) REFERENCES MoodPerDay(id)
        );
      ''');

      await db.execute('''
        INSERT INTO MoodEntry_new (id, type, timestamp, reflection, moodPerDayId)
        SELECT id, type, timestamp, json_object('note', note, 'factors', json('[]')), moodPerDayId 
        FROM MoodEntry;
      ''');

      await db.execute('DROP TABLE MoodEntry');
      await db.execute('ALTER TABLE MoodEntry_new RENAME TO MoodEntry');
    }
  }
}
