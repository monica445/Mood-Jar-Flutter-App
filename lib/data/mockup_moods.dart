import 'package:mood_jar_app/domain/entities/mood_entry.dart';

import 'package:mood_jar_app/domain/entities/mood_entry.dart';
import 'package:mood_jar_app/domain/entities/mood_per_day.dart';
import 'package:mood_jar_app/domain/enums/mood_type.dart';
import 'package:mood_jar_app/domain/entities/mood_reflection.dart';

final List<MoodPerDay> mockMoodPerDays = [
  MoodPerDay(
    id: 1,
    date: DateTime.now(),
    moods: [
      MoodEntry(
        id: 1,
        type: Moodtype.good,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        reflection: MoodReflection(
          note: "Had a productive morning and felt proud of myself.",
          factors: ["Productivity", "Self-care"],
        ),
      ),
      MoodEntry(
        id: 2,
        type: Moodtype.neutral,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        reflection: MoodReflection(
          note: "Spent some quiet time organizing my thoughts.",
          factors: ["Peace", "Routine"],
        ),
      ),
    ],
  ),

  MoodPerDay(
    id: 2,
    date: DateTime.now().subtract(const Duration(days: 1)),
    moods: [
      MoodEntry(
        id: 3,
        type: Moodtype.bad,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        reflection: MoodReflection(
          note: "Felt a bit overwhelmed with tasks piling up.",
          factors: ["Stress", "Workload"],
        ),
      ),
      MoodEntry(
        id: 4,
        type: Moodtype.neutral,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
        reflection: MoodReflection(
          note: "Nothing special happened today, just an average day.",
          factors: ["Routine"],
        ),
      ),
    ],
  ),

  MoodPerDay(
    id: 3,
    date: DateTime.now().subtract(const Duration(days: 3)),
    moods: [
      MoodEntry(
        id: 5,
        type: Moodtype.awful,
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 4)),
        reflection: MoodReflection(
          note: "Worried about upcoming deadlines.",
          factors: ["Deadlines", "Uncertainty"],
        ),
      ),
      MoodEntry(
        id: 6,
        type: Moodtype.neutral,
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
        reflection: MoodReflection(
          note: "Did some breathing exercises which helped.",
          factors: ["Mindfulness", "Health"],
        ),
      ),
    ],
  ),

  MoodPerDay(
    id: 4,
    date: DateTime.now().subtract(const Duration(days: 6)),
    moods: [
      MoodEntry(
        id: 7,
        type: Moodtype.great,
        timestamp: DateTime.now().subtract(const Duration(days: 6, hours: 5)),
        reflection: MoodReflection(
          note: "Met a friend and had a great conversation.",
          factors: ["Social", "Connection"],
        ),
      ),
    ],
  ),

  MoodPerDay(
    id: 5,
    date: DateTime.now().subtract(const Duration(days: 10)),
    moods: [
      MoodEntry(
        id: 8,
        type: Moodtype.bad,
        timestamp: DateTime.now().subtract(const Duration(days: 10, hours: 6)),
        reflection: MoodReflection(
          note: "Did not get enough sleep last night.",
          factors: ["Sleep", "Health"],
        ),
      ),
      MoodEntry(
        id: 9,
        type: Moodtype.bad,
        timestamp: DateTime.now().subtract(const Duration(days: 10, hours: 2)),
        reflection: MoodReflection(
          note: "Missed an important opportunity and felt disappointed.",
          factors: ["Regret", "Expectations"],
        ),
      ),
      MoodEntry(
        id: 10,
        type: Moodtype.good,
        timestamp: DateTime.now().subtract(const Duration(days: 10)),
        reflection: MoodReflection(
          note: "Reminded myself that tomorrow is a new chance.",
          factors: ["Optimism", "Growth"],
        ),
      ),
    ],
  ),
];

