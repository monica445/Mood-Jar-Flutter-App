import 'package:mood_jar_app/data/repository/mood_day_repo.dart';
import 'package:mood_jar_app/data/repository/mood_entry_repo.dart';

import '../entities/mood_entry.dart';
import '../entities/mood_per_day.dart';

class MoodService {
  final MoodDayRepository _dayRepo = MoodDayRepository();
  final MoodEntryRepository _entryRepo = MoodEntryRepository();

  Future<MoodEntry> addMood(MoodEntry mood) async {
    final date = mood.timestamp;
    var day = await _dayRepo.getDayByDate(date);

    if (day == null) {
      //create new day row if day is not exist yet
      final dayId = await _dayRepo.insert(MoodPerDay(date: date));
      day = MoodPerDay(id: dayId, date: date);
    }

    final moodToInsert = mood.copyWith(moodPerDayId: day.id);
    final id = await _entryRepo.insert(moodToInsert);
    return moodToInsert.copyWith(id: id);
  }

  Future<void> updateMood(MoodEntry mood) async {
    if (mood.id == null) throw Exception("Cannot update: MoodEntry has no ID");
    await _entryRepo.update(mood);
  }

  Future<void> deleteMood(MoodEntry mood) async {
    if (mood.id == null) throw Exception("Cannot delete: MoodEntry has no ID");
    await _entryRepo.delete(mood.id!);
  }

  Future<List<MoodEntry>> getTodayMoods() async {
    final today = DateTime.now();
    final day = await _dayRepo.getDayByDate(today);
    if (day == null) return [];
    return await _entryRepo.getByDayId(day.id!);
  }

  Future<List<MoodPerDay>> getMoodPerDayWithMoods() async {
    final days = await _dayRepo.getAllDays();
    for (var day in days) {
      final moods = await _entryRepo.getByDayId(day.id!);
      day.moods = moods;
    }
    return days;
  }

  Future<List<MoodEntry>> getThisMonthMoods() async {
    final now = DateTime.now();

    final startMonth = DateTime(now.year, now.month, 1);
    final endMonth = DateTime(now.year, now.month + 1, 1);

    final allDays = await _dayRepo.getAllDays();
    final monthDays = allDays.where((day) =>
        day.date.isAtSameMomentAs(startMonth) ||
        (day.date.isAfter(startMonth) && day.date.isBefore(endMonth))
    ).toList();

    if (monthDays.isEmpty) return [];

    final List<MoodEntry> monthMoods = [];
    for (var day in monthDays) {
      final moods = await _entryRepo.getByDayId(day.id!);
      monthMoods.addAll(moods);
    }

    //sort by timestamp
    monthMoods.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return monthMoods;
  }
}


