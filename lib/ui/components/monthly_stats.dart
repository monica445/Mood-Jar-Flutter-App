import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../domain/entities/mood_entry.dart';
import '../../domain/enums/mood_type.dart';
class MonthlyStats extends StatelessWidget {
  final List<MoodEntry> thisMonthMoods;

  const MonthlyStats({super.key, required this.thisMonthMoods});

  Map<DateTime, List<MoodEntry>> moodsByDay() {
    final Map<DateTime, List<MoodEntry>> moodsDay = {};

    for (var mood in thisMonthMoods) {
      final day = DateTime(
        mood.timestamp.year,
        mood.timestamp.month,
        mood.timestamp.day,
      );

      moodsDay.putIfAbsent(day, () => []).add(mood);
    }

    return moodsDay;
  }

  Map<Moodtype, int> avgMoodCounts() {
    final Map<Moodtype, int> moodCounts = {
      Moodtype.great: 0,
      Moodtype.good: 0,
      Moodtype.neutral: 0,
      Moodtype.bad: 0,
      Moodtype.awful: 0,
    };

    for (var moods in moodsByDay().values) {
      final avgWeight =
          moods.fold(0.0, (sum, mood) => sum + mood.type.weight) /
              moods.length;

      final avgMoodType = getAvgMood(avgWeight);
      moodCounts[avgMoodType] = moodCounts[avgMoodType]! + 1;
    }

    return moodCounts;
  }

  Moodtype getAvgMood(double avgWeight) {
    if (avgWeight > 1.5) return Moodtype.great;
    if (avgWeight > 0.5) return Moodtype.good;
    if (avgWeight > -0.5) return Moodtype.neutral;
    if (avgWeight > -1.5) return Moodtype.bad;
    return Moodtype.awful;
  }

  @override
  Widget build(BuildContext context) {
    final moodCounts = avgMoodCounts();
    final maxCount =
        moodCounts.values.reduce((a, b) => a > b ? a : b);

    final moodTypes = [
      Moodtype.great,
      Moodtype.good,
      Moodtype.neutral,
      Moodtype.bad,
      Moodtype.awful,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Monthly Mood Overview",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        thisMonthMoods.isEmpty
          ? 
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          "No moods recorded yet this month",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 10,),
                        Icon(Icons.mood, color: Colors.grey[600])
                      ]
                    )
                  ),
                )
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: moodTypes.map((type) {
                  final count = moodCounts[type] ?? 0;
                  final barHeight =
                      (count.toDouble() / maxCount) * 160;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            type.icon,
                            color: type.color,
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 40,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: type.color,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            type.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ),
      ],
    );
  }
}
