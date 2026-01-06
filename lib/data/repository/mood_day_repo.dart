import 'package:mood_jar_app/data/database/database_provider.dart';
import 'package:mood_jar_app/domain/entities/mood_per_day.dart';

class MoodDayRepository {
  final String table = 'MoodPerDay';

  Future<int> insert(MoodPerDay day) async {
    final db = await DatabaseProvider.database;
    return await db.insert(table, {'date': day.date.toIso8601String()});
  }

  Future<List<MoodPerDay>> getAllDays() async {
    final db = await DatabaseProvider.database;
    final results = await db.query(table, orderBy: 'date ASC');
    return results.map((r) => MoodPerDay(id: r['id'] as int, date: DateTime.parse(r['date'] as String))).toList();
  }

  Future<MoodPerDay?> getDayByDate(DateTime date) async {
    final db = await DatabaseProvider.database;
    final dateStr = date.toIso8601String().split('T')[0]; // yyyy-MM-dd
    final results = await db.query(table, where: 'date = ?', whereArgs: [dateStr]);
    if (results.isEmpty) return null;
    final r = results.first;
    return MoodPerDay(id: r['id'] as int, date: DateTime.parse(r['date'] as String));
  }

  Future<int> delete(int id) async {
    final db = await DatabaseProvider.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
