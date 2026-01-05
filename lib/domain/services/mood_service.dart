import 'package:intl/intl.dart';
import 'package:mood_jar_app/data/repository/mood_repo.dart';

import '../entities/mood_entry.dart';
import '../entities/mood_per_day.dart';

class MoodService {
  final String _entryTable = "MoodEntry";
  final String _dayTable = "MoodPerDay";

  Future<MoodEntry> addMood(MoodEntry mood) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(mood.timestamp);

    final dayResult = await MoodRepo.query(
      _dayTable,
      where: "date = ?",
      whereArgs: [dateStr],
    );

    int dayId;
    //create new day if not exist yet
    if (dayResult.isEmpty) {
      dayId = await MoodRepo.insert(_dayTable, {'date': dateStr});
    } else {
      dayId = dayResult.first['id'] as int;
    }

    final moodToInsert = mood.copyWith(moodPerDayId: dayId);
    //then insert new mood with day id
    final id = await MoodRepo.insert(_entryTable, moodToInsert.toMap());

    return moodToInsert.copyWith(id: id);
  }

  Future<List<MoodEntry>> getTodayMoods() async {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final dayResult = await MoodRepo.query(
      _dayTable,
      where: "date = ?",
      whereArgs: [todayStr],
    );
    if (dayResult.isEmpty) return [];

    final maps = await MoodRepo.query(
      _entryTable,
      where: "moodPerDayId = ?",
      whereArgs: [dayResult.first['id']],
    );

    return maps.map((m) => MoodEntry.fromMap(m)).toList();
  }

  Future<List<MoodEntry>> getThisMonthMoods() async {
    final now = DateTime.now();

    //calculate the date range for the current month
    final startMonth = DateTime(now.year, now.month, 1);
    final endMonth = DateTime(now.year, now.month + 1, 1);

    final startString = DateFormat('yyyy-MM-dd').format(startMonth);
    final endString = DateFormat('yyyy-MM-dd').format(endMonth);

    // get all MoodPerDay within this range
    final dayResults = await MoodRepo.query(
      _dayTable,
      where: 'date >= ? AND date < ?',
      whereArgs: [startString, endString],
    );

    if (dayResults.isEmpty) return [];

    final dayIds = dayResults.map((e) => e['id'] as int).toList();

    //get all moods with day id in dayIds
    final placeholders = List.filled(dayIds.length, '?').join(',');
    final moodMaps = await MoodRepo.query(
      _entryTable,
      where: 'moodPerDayId IN ($placeholders)',
      whereArgs: dayIds,
    );

    return moodMaps.map((e) => MoodEntry.fromMap(e)).toList();
  }

  Future<void> updateMood(MoodEntry mood) async {
    if (mood.id == null) throw Exception("Update failed: Missing ID");
    await MoodRepo.update(_entryTable, mood.toMap(), mood.id!);
  }

  Future<void> removeMood(int id) async {
    await MoodRepo.delete(_entryTable, id);
  }

  Future<List<MoodPerDay>> getMoodPerDayWithMoods() async {
    final rawData = await MoodRepo.getRawMoodsWithDays();

    final Map<int, MoodPerDay> grouped = {};

    for (final row in rawData) {
      final int dayId = row["dayId"] as int;

      final day = grouped.putIfAbsent(
        dayId,
        () => MoodPerDay(
          id: dayId,
          date: DateTime.parse(row["moodDate"] as String),
        ),
      );

      if (row['moodEntryId'] != null) {
        day.addMood(MoodEntry.fromMap({...row, 'id': row['moodEntryId']}));
      }
    }
    return grouped.values.toList();
  }
}

  // Future<MoodEntry> addMood(MoodEntry mood) async {
  //   final dateOnly = DateTime(
  //     mood.timestamp.year,
  //     mood.timestamp.month,
  //     mood.timestamp.day,
  //   );
  //   MoodPerDay? day = await MoodRepo.getMoodPerDay(dateOnly);
  //   day ??= await MoodRepo.addMoodPerDayWithId(MoodPerDay(date: dateOnly));

  //   final moodWithDay = mood.copyWith(moodPerDayId: day.id);
  //   final newId = await MoodRepo.addMood(moodWithDay);

  //   return moodWithDay.copyWith(id: newId);
  // }

  // Future<void> updateMood(MoodEntry mood) async {
  //   if (mood.id == null) throw Exception("Mood ID is null. Cannot update.");
  //   try {
  //     await MoodRepo.updateMood(mood);
  //   } catch (e) {
  //     throw Exception("Failed to update mood: $e");
  //   }
  // }

  // Future<void> removeMood(MoodEntry mood) async {
  //   if (mood.id == null) throw Exception("Mood ID is null. Cannot delete.");
  //   try {
  //     await MoodRepo.deleteMood(mood);
  //   } catch (e) {
  //     throw Exception("Failed to delete mood: $e");
  //   }
  // }

  // Future<List<MoodEntry>> getTodayMoods() async {
  //   try {
  //     return await MoodRepo.getTodayMoods();
  //   } catch (e) {
  //     throw Exception("Failed to fetch today's moods: $e");
  //   }
  // }

  // Future<List<MoodEntry>> getThisMonthMoods() async {
  //   try {
  //     return await MoodRepo.getThisMonthMoods();
  //   } catch (e) {
  //     throw Exception("Failed to fetch this month's moods: $e");
  //   }
  // }

  // Future<List<MoodPerDay>> getMoodPerDayWithMoods() async {
  //   try {
  //     return await MoodRepo.getMoodPerDayWithMoods();
  //   } catch (e) {
  //     throw Exception("Failed to fetch MoodPerDay with moods: $e");
  //   }
  // }

