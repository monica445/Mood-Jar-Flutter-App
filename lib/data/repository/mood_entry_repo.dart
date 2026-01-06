import 'package:mood_jar_app/data/database/database_provider.dart';
import 'package:mood_jar_app/domain/entities/mood_entry.dart';

class MoodEntryRepository {
  final String table = 'MoodEntry';

  Future<int> insert(MoodEntry mood) async {
    final db = await DatabaseProvider.database;
    return await db.insert(table, mood.toMap());
  }

  Future<List<MoodEntry>> getByDayId(int dayId) async {
    final db = await DatabaseProvider.database;
    final results = await db.query(table, where: 'moodPerDayId = ?', whereArgs: [dayId]);
    return results.map((r) => MoodEntry.fromMap(r)).toList();
  }

  Future<List<MoodEntry>> getAll() async {
    final db = await DatabaseProvider.database;
    final results = await db.query(table, orderBy: 'timestamp ASC');
    return results.map((r) => MoodEntry.fromMap(r)).toList();
  }

  Future<int> update(MoodEntry mood) async {
    final db = await DatabaseProvider.database;
    return await db.update(table, mood.toMap(), where: 'id = ?', whereArgs: [mood.id]);
  }

  Future<int> delete(int id) async {
    final db = await DatabaseProvider.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
