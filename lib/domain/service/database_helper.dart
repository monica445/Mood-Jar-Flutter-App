import 'package:intl/intl.dart';
import 'package:mood_jar_app/domain/entities/mood_entry.dart';
import 'package:mood_jar_app/domain/entities/mood_per_day.dart';
import 'package:mood_jar_app/domain/entities/user.dart';
import 'package:mood_jar_app/domain/enums/mood_type.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const version = 1;
  static const String databaseName = "MoodJar.db";
  static Database? db;

static Future<Database> getDb() async {
  if (db != null && db!.isOpen) {
    return db!;
  }
  
  final path = join(await getDatabasesPath(), databaseName);
  db = await openDatabase(
    path,
    version: version,
    onConfigure: (db) async {
      await db.execute("PRAGMA foreign_keys = ON");
    },
    onCreate: (db, version) async {
      await db.execute('''CREATE TABLE User (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        joinedDate TEXT
        );
      ''');

      await db.execute('''CREATE TABLE MoodPerDay (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        userId INTEGER,
        FOREIGN KEY(userId) REFERENCES User(id)
        );
      ''');

      await db.execute('''CREATE TABLE MoodEntry (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT,
          timestamp TEXT,
          note TEXT,
          moodPerDayId INTEGER,
          FOREIGN KEY(moodPerDayId) REFERENCES MoodPerDay(id)
        );
      ''');
    },
  );
  
  return db!;
}

  // MoodEntry - add 
  static Future<int> addNewMood(MoodEntry moodEntry) async {
    final database = await getDb();
    return await database.insert("MoodEntry", moodEntry.toMap());
  }

  // MoodEntry - update
  static Future<int> updateMood(MoodEntry moodEntry) async {
    final database = await getDb();
    return await database.update("MoodEntry", moodEntry.toMap(), where: 'id = ?', whereArgs: [moodEntry.id]);
  }

  // MoodEntry - delete
  static Future<int> deleteMood(MoodEntry moodEntry) async {
    final database = await getDb();
    return await database.delete("MoodEntry", where: "id = ?", whereArgs: [moodEntry.id]);
  }

  // MoodEntry - read : getAllMoodEntry
  static Future<List<MoodEntry>> getAllMoodEntry() async {
    final database = await getDb();
    final List<Map<String,dynamic>> maps = await database.query("MoodEntry");
    return List.generate(maps.length, (index) => MoodEntry.fromMap(maps[index]));
  }

  // MoodPerDay - add
  static Future<int> addMoodPerDay(MoodPerDay moodPerDay) async {
    final database = await getDb();
    return await database.insert("MoodPerDay", moodPerDay.toMap());
  }

  // MoodPerDay - delete
  static Future<int> deleteMoodPerDay(MoodPerDay moodPerDay) async {
    final database = await getDb();
    return await database.delete("MoodPerDay", where: "id = ?" , whereArgs: [moodPerDay.id]);
  }

  // MoodPerDay - getAllMoodPerDay
  static Future<List<MoodPerDay>> getAllMoodPerDay() async {
    final database = await getDb();
    final List<Map<String, dynamic>> maps = await database.query("MoodPerDay");
    return List.generate(maps.length, (index) => MoodPerDay.fromMap(maps[index]));
  }

  // MoodPerDay - get specific MoodPerDay
  static Future<MoodPerDay?> getMoodPerDay(DateTime date) async {
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    final database = await getDb();
    final results = await database.query("MoodPerDay", where: "date LIKE ?", whereArgs: ["$dateString%"]);
    if(results.isNotEmpty){
      return MoodPerDay.fromMap(results.first);
    }
    else{
      return null;
    }
  }

  // User - add
  static Future<int> addUser(User user) async {
    final database = await getDb();
    return database.insert("User", user.toMap());
  }

  // User - getUser
  static Future<User?> getUser() async {
    final database = await getDb();
    List<Map<String,dynamic>> maps = await database.query("User");
    if(maps.isEmpty){
      return null;
    }
    return User.fromMap(maps.first);  
  }
  static Future<MoodPerDay> addMoodPerDayWithId(MoodPerDay moodPerDay) async {
  final database = await getDb();
  final id = await database.insert("MoodPerDay", {
    'date': moodPerDay.date.toIso8601String(),
  });
  return MoodPerDay(id: id, date: moodPerDay.date); // id is assigned once
}

  static Future<List<MoodPerDay>> getMoodPerDayWithMoods() async {
    final database = await getDb();
    final results = await database.rawQuery('''
      SELECT
        MoodPerDay.id AS moodPerDayId,
        MoodPerDay.date AS moodDate,
        MoodEntry.id AS moodEntryId,
        MoodEntry.type,
        MoodEntry.timestamp,
        MoodEntry.note
      FROM MoodPerDay
      LEFT JOIN MoodEntry
        ON MoodEntry.moodPerDayId = MoodPerDay.id
      ORDER BY MoodPerDay.date ASC
    ''');

    final Map<int, MoodPerDay> grouped = {};

    for(final row in results){
      final int dayId = row["moodPerDayId"] as int;
      grouped.putIfAbsent(dayId, (){
        return MoodPerDay(
          id: dayId,
          date: DateTime.parse(row["moodDate"] as String));
      });
      if(row['moodEntryId'] != null){
        grouped[dayId]!.addMood(
          MoodEntry(
            id: row['moodEntryId'] as int,
            type: Moodtype.values.firstWhere(
              (e) => e.name.toLowerCase() == (row['type'] as String).toLowerCase(),
            ),
            timestamp: DateTime.parse(row['timestamp'] as String),
            note: row['note'] as String?,
            moodPerDayId: dayId,
          ),
        );
      }
    }
    return grouped.values.toList();
  }

  static Future<void> closeDb() async {
    if (db != null && db!.isOpen) {
      await db!.close();
      db = null; 
      print("The database is closed");
    }
  }

  static Future<void> deleteAllData() async {
    final database = await getDb();
    await database.delete("MoodEntry");
    await database.delete("MoodPerDay");
    await database.delete("User");
    
    
  }

  static Future<void> printDbPath() async {
    final dbPath = await getDatabasesPath();
    print(dbPath);
  }
  
}
