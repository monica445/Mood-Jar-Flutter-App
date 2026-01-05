import 'package:mood_jar_app/domain/entities/mood_entry.dart';
import 'package:mood_jar_app/domain/enums/mood_type.dart';

class MoodPerDay {
  final int? id;
  final DateTime date;
  List<MoodEntry> moods;

  MoodPerDay({this.id, required this.date, List<MoodEntry>? moods})
    : moods = moods ?? [];

  MoodPerDay copyWith({int? id, DateTime? date, List<MoodEntry>? moods}) {
    return MoodPerDay(
      id: id ?? this.id,
      date: date ?? this.date,
      moods: moods ?? List.from(this.moods),
    );
  }

  void addMood(MoodEntry mood) {
    moods.add(mood);
  }

  void removeMood(MoodEntry mood) {
    moods.removeWhere((m) => m.id == mood.id);
  }

  void updateMood(MoodEntry updatedMood) {
    if (updatedMood.id == null) return;

    for (int i = 0; i < moods.length; i++) {
      if (moods[i].id == updatedMood.id) {
        moods[i] = updatedMood;
        break;
      }
    }
  }

  List<MoodEntry> getAllMoodPerDay() {
    return moods;
  }

  Moodtype? getAvgMoodScale() {
    int totalMoodWeight = 0;
    double avgMoodWeight = 0;

    if (moods.isEmpty) {
      return null;
    }
    for (MoodEntry mood in moods) {
      totalMoodWeight += mood.type.weight;
    }
    avgMoodWeight = (totalMoodWeight / moods.length);

    Moodtype closest = Moodtype.values.first;
    double minDiff = (closest.weight - avgMoodWeight).abs();

    for (var mood in Moodtype.values) {
      double diff = (mood.weight - avgMoodWeight).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closest = mood;
      }
    }
    return closest;
  }

  factory MoodPerDay.fromMap(Map<String, dynamic> mapData) {
    return MoodPerDay(id: mapData['id'], date: DateTime.parse(mapData['date']));
  }

  Map<String, dynamic> toMap() {
    return {'date': date.toIso8601String()};
  }
}
