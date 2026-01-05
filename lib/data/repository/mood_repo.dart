import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:mood_jar_app/domain/entities/mood_entry.dart';
import 'package:mood_jar_app/domain/entities/mood_per_day.dart';
import 'package:mood_jar_app/domain/enums/mood_type.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/mood_reflection.dart';

class MoodRepo {
  static const version = 2;
  static const String databaseName = "MoodJar_V2.db";
  static Database? db;

  static Future<Database> getDb() async {
    if (db != null) {
      if (db!.isOpen) return db!;
      db = null;
    }

    final path = join(await getDatabasesPath(), databaseName);
    db = await openDatabase(
      path,
      version: version,
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
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

          // Copy data from old table to new table
          await db.execute('''
            INSERT INTO MoodEntry_new (id, type, timestamp, reflection, moodPerDayId)
            SELECT 
              id, 
              type, 
              timestamp,
              json_object('note', note, 'factors', json('[]')) as reflection,
              moodPerDayId 
            FROM MoodEntry
          ''');

          // Drop old table
          await db.execute('DROP TABLE MoodEntry');

          // Rename new table
          await db.execute('ALTER TABLE MoodEntry_new RENAME TO MoodEntry');
        }
      },
    );

    return db!;
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''CREATE TABLE MoodPerDay (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT
      );
    ''');

    await db.execute('''CREATE TABLE MoodEntry (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT,
      timestamp TEXT,
      reflection TEXT, 
      moodPerDayId INTEGER,
      FOREIGN KEY(moodPerDayId) REFERENCES MoodPerDay(id)
    );
    ''');
  }

  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final database = await getDb();
    return await database.insert(table, data);
  }

  static Future<List<Map<String, dynamic>>> query(String table, {String? where, List<Object?>? whereArgs}) async {
    final database = await getDb();
    return await database.query(table, where: where, whereArgs: whereArgs);
  }

  static Future<int> update(String table, Map<String, dynamic> data, int id) async {
    final database = await getDb();
    return await database.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> delete(String table, int id) async {
    final database = await getDb();
    return await database.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<Object?>? arguments]) async {
    final database = await getDb();
    return await database.rawQuery(sql, arguments);
  }

  static Future<List<Map<String, dynamic>>> getRawMoodsWithDays() async {
    return await rawQuery('''
      SELECT MoodPerDay.id AS dayId, MoodPerDay.date AS moodDate,
            MoodEntry.id AS moodEntryId, MoodEntry.type, MoodEntry.timestamp,
            MoodEntry.reflection, MoodEntry.moodPerDayId
      FROM MoodPerDay
      LEFT JOIN MoodEntry ON MoodEntry.moodPerDayId = MoodPerDay.id
      ORDER BY MoodPerDay.date ASC
    ''');
  }

  // // MoodEntry - add
  // static Future<int> addMood(MoodEntry mood) async {
  //   try {
  //     final db = await getDb();
  //     return await db.transaction((txn) async {
  //       final dateOnly = DateTime(
  //         mood.timestamp.year,
  //         mood.timestamp.month,
  //         mood.timestamp.day,
  //       );
  //       final dateString = DateFormat('yyyy-MM-dd').format(dateOnly);

  //       final dayResult = await txn.query(
  //         "MoodPerDay",
  //         where: "date = ?",
  //         whereArgs: [dateString],
  //         limit: 1,
  //       );

  //       int moodPerDayId;
  //       if (dayResult.isEmpty) {
  //         moodPerDayId = await txn.insert("MoodPerDay", {'date': dateString});
  //       } else {
  //         moodPerDayId = dayResult.first['id'] as int;
  //       }

  //       final moodToInsert = mood.copyWith(moodPerDayId: moodPerDayId);

  //       final insertedId = await txn.insert("MoodEntry", moodToInsert.toMap());
  //       if (insertedId == 0) throw Exception("Failed to insert MoodEntry");

  //       return insertedId;
  //     });
  //   } catch (e) {
  //     print("MoodRepo.addMood error: $e");
  //     throw e; // propagate error to service
  //   }
  // }

  // // MoodEntry - update
  // static Future<int> updateMood(MoodEntry moodEntry) async {
  //   final database = await getDb();
  //   return await database.update(
  //     "MoodEntry",
  //     moodEntry.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [moodEntry.id],
  //   );
  // }

  // // MoodEntry - delete
  // static Future<int> deleteMood(MoodEntry moodEntry) async {
  //   final database = await getDb();
  //   return await database.delete(
  //     "MoodEntry",
  //     where: "id = ?",
  //     whereArgs: [moodEntry.id],
  //   );
  // }

  // // MoodEntry - read : getAllMoodEntry
  // static Future<List<MoodEntry>> getAllMoodEntry() async {
  //   final database = await getDb();
  //   final List<Map<String, dynamic>> maps = await database.query("MoodEntry");
  //   return List.generate(
  //     maps.length,
  //     (index) => MoodEntry.fromMap(maps[index]),
  //   );
  // }

  // // MoodPerDay - add
  // static Future<int> addMoodPerDay(MoodPerDay moodPerDay) async {
  //   final database = await getDb();
  //   return await database.insert("MoodPerDay", moodPerDay.toMap());
  // }

  // // MoodPerDay - delete
  // static Future<int> deleteMoodPerDay(MoodPerDay moodPerDay) async {
  //   final database = await getDb();
  //   return await database.delete(
  //     "MoodPerDay",
  //     where: "id = ?",
  //     whereArgs: [moodPerDay.id],
  //   );
  // }

  // // MoodPerDay - getAllMoodPerDay
  // static Future<List<MoodPerDay>> getAllMoodPerDay() async {
  //   final database = await getDb();
  //   final List<Map<String, dynamic>> maps = await database.query("MoodPerDay");
  //   return List.generate(
  //     maps.length,
  //     (index) => MoodPerDay.fromMap(maps[index]),
  //   );
  // }

  // // MoodPerDay - get specific MoodPerDay
  // static Future<MoodPerDay?> getMoodPerDay(DateTime date) async {
  //   final dateString = DateFormat('yyyy-MM-dd').format(date);
  //   final database = await getDb();
  //   final results = await database.query(
  //     "MoodPerDay",
  //     where: "date LIKE ?",
  //     whereArgs: ["$dateString%"],
  //   );
  //   if (results.isNotEmpty) {
  //     return MoodPerDay.fromMap(results.first);
  //   } else {
  //     return null;
  //   }
  // }

  // static Future<MoodPerDay> addMoodPerDayWithId(MoodPerDay moodPerDay) async {
  //   final database = await getDb();

  //   final dateString = DateFormat('yyyy-MM-dd').format(moodPerDay.date);

  //   final id = await database.insert("MoodPerDay", {'date': dateString});

  //   return MoodPerDay(id: id, date: DateTime.parse(dateString));
  // }

  // static Future<List<MoodPerDay>> getMoodPerDayWithMoods() async {
  //   final database = await getDb();
  //   final results = await database.rawQuery('''
  //     SELECT
  //       MoodPerDay.id AS dayId,
  //       MoodPerDay.date AS moodDate,
  //       MoodEntry.id AS moodEntryId,
  //       MoodEntry.type,
  //       MoodEntry.timestamp,
  //       MoodEntry.reflection,
  //       MoodEntry.moodPerDayId AS entryDayId
  //     FROM MoodPerDay
  //     LEFT JOIN MoodEntry
  //       ON MoodEntry.moodPerDayId = MoodPerDay.id
  //     ORDER BY MoodPerDay.date ASC
  //   ''');

  //   final Map<int, MoodPerDay> grouped = {};

  //   for (final row in results) {
  //     final int dayId = row["dayId"] as int;
  //     grouped.putIfAbsent(dayId, () {
  //       return MoodPerDay(
  //         id: dayId,
  //         date: DateTime.parse(row["moodDate"] as String),
  //       );
  //     });

  //     if (row['moodEntryId'] != null) {
  //       // Parse reflection from JSON string
  //       MoodReflection? reflection;
  //       if (row['reflection'] != null) {
  //         try {
  //           final reflectionMap = jsonDecode(row['reflection'] as String);
  //           reflection = MoodReflection.fromMap(
  //             Map<String, dynamic>.from(reflectionMap),
  //           );
  //         } catch (e) {
  //           print("Error parsing reflection: $e");
  //         }
  //       }

  //       grouped[dayId]!.addMood(
  //         MoodEntry(
  //           id: row['moodEntryId'] as int,
  //           type: Moodtype.values.firstWhere(
  //             (e) =>
  //                 e.name.toLowerCase() == (row['type'] as String).toLowerCase(),
  //           ),
  //           timestamp: DateTime.parse(row['timestamp'] as String),
  //           reflection: reflection,
  //           moodPerDayId: row['entryDayId'] as int?,
  //         ),
  //       );
  //     }
  //   }
  //   return grouped.values.toList();
  // }

  // static Future<void> closeDb() async {
  //   if (db != null && db!.isOpen) {
  //     await db!.close();
  //     db = null;
  //     print("The database is closed");
  //   }
  // }

  // static Future<void> deleteAllData() async {
  //   final database = await getDb();
  //   await database.delete("MoodEntry");
  //   await database.delete("MoodPerDay");
  //   await database.delete("User");
  // }

  // static Future<void> printDbPath() async {
  //   final dbPath = await getDatabasesPath();
  //   print(dbPath);
  // }

  // static Future<List<MoodEntry>> getTodayMoods() async {
  //   final db = await getDb();
  //   final today = DateTime.now();

  //   // Normalize date to YYYY-MM-DD
  //   final dateString = DateFormat('yyyy-MM-dd').format(today);

  //   // Get MoodPerDay row for today
  //   final dayResult = await db.query(
  //     'MoodPerDay',
  //     where: 'date = ?',
  //     whereArgs: [dateString],
  //     limit: 1,
  //   );

  //   if (dayResult.isEmpty) return [];

  //   final moodPerDayId = dayResult.first['id'] as int;

  //   // Get all moods for that day
  //   final moodMaps = await db.query(
  //     'MoodEntry',
  //     where: 'moodPerDayId = ?',
  //     whereArgs: [moodPerDayId],
  //   );

  //   return moodMaps.map((e) => MoodEntry.fromMap(e)).toList();
  // }

  // static Future<List<MoodEntry>> getThisMonthMoods() async {
  //   final db = await getDb();
  //   final now = DateTime.now();

  //   // Start and end of month
  //   final startMonth = DateTime(now.year, now.month, 1);
  //   final endMonth = DateTime(now.year, now.month + 1, 1);

  //   final startString = DateFormat('yyyy-MM-dd').format(startMonth);
  //   final endString = DateFormat('yyyy-MM-dd').format(endMonth);

  //   // Get all MoodPerDay rows in this month
  //   final dayResults = await db.query(
  //     'MoodPerDay',
  //     where: 'date >= ? AND date < ?',
  //     whereArgs: [startString, endString],
  //   );

  //   if (dayResults.isEmpty) return [];

  //   // Collect all mood IDs from MoodPerDay rows
  //   final moodPerDayIds = dayResults.map((e) => e['id'] as int).toList();

  //   // Query all moods linked to these days
  //   final moodMaps = await db.query(
  //     'MoodEntry',
  //     where:
  //         'moodPerDayId IN (${List.filled(moodPerDayIds.length, '?').join(',')})',
  //     whereArgs: moodPerDayIds,
  //   );

  //   return moodMaps.map((e) => MoodEntry.fromMap(e)).toList();
  // }

}
