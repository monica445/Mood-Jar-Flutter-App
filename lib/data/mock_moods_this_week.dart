

import 'package:mood_jar_app/models/entities/mood_entry.dart';
import 'package:mood_jar_app/models/entities/mood_reflection.dart';
import 'package:mood_jar_app/models/enums/mood_type.dart';

List<MoodEntry> mockMoodsThisWeek() {
  final now = DateTime.now();

  return [
    // Today
    MoodEntry(
      type: Moodtype.good,
      reflection: MoodReflection(
        factors: ["School", "Exercise"],
        note: "Felt productive and calm",
      ),
      timestamp: now,
    ),

    // Yesterday
    MoodEntry(
      type: Moodtype.neutral,
      reflection: MoodReflection(
        factors: ["Work"],
        note: "Normal day, nothing special",
      ),
      timestamp: now.subtract(const Duration(days: 1)),
    ),

    // 2 days ago
    MoodEntry(
      type: Moodtype.great,
      reflection: MoodReflection(
        factors: ["Friends", "Laugh"],
        note: "Had fun with friends",
      ),
      timestamp: now.subtract(const Duration(days: 2)),
    ),

    // 3 days ago
    MoodEntry(
      type: Moodtype.bad,
      reflection: MoodReflection(
        factors: ["Sleep", "Work"],
        note: "Too tired and stressed",
      ),
      timestamp: now.subtract(const Duration(days: 3)),
    ),

    // 4 days ago
    MoodEntry(
      type: Moodtype.good,
      reflection: MoodReflection(
        factors: ["Sleep", "Fresh Air"],
        note: "Went for a walk",
      ),
      timestamp: now.subtract(const Duration(days: 4)),
    ),

    // 5 days ago
    MoodEntry(
      type: Moodtype.awful,
      reflection: MoodReflection(
        factors: ["Overthinking"],
        note: "Felt overwhelmed",
      ),
      timestamp: now.subtract(const Duration(days: 5)),
    ),

    // 6 days ago
    MoodEntry(
      type: Moodtype.good,
      reflection: MoodReflection(
        factors: ["Family", "Rest"],
        note: "Relaxing weekend",
      ),
      timestamp: now.subtract(const Duration(days: 6)),
    ),
  ];
}
