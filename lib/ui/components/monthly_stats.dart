import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../domain/entities/mood_entry.dart';
import '../../domain/enums/mood_type.dart';

class MonthlyStats extends StatelessWidget {
  final List<MoodEntry> thisMonthMoods;

  MonthlyStats({super.key, required this.thisMonthMoods});

  Map<Moodtype, int> moodCounts = {};
  Map<String, int> factorCounts = {};
  Moodtype? dominantMood;

  void computeStats() {

    for (var type in Moodtype.values) {
      moodCounts[type] = 0;
    }

    Moodtype? tempDominant;
    int tempMaxCount = 0;

    for (var mood in thisMonthMoods) {
      final count = (moodCounts[mood.type] ?? 0) + 1;
      moodCounts[mood.type] = count;

      if (count > tempMaxCount) {
        tempMaxCount = count;
        tempDominant = mood.type;
      }
    }

    dominantMood = tempDominant;

    if (dominantMood != null) {
      for (var mood in thisMonthMoods) {
        if (mood.type != dominantMood) continue;

        final factors = mood.reflection?.factors;
        if (factors != null) {
          for (var factor in factors) {
            factorCounts[factor] = (factorCounts[factor] ?? 0) + 1;
          }
        }
      }
    }
  }

  String getInsight() {
    if (dominantMood == null) {
      return "Log your moods to start discovering patterns over time 🌱";
    }

    final totalMoods = thisMonthMoods.length;
    final dominantCount = moodCounts[dominantMood] ?? 0;
    final percent = ((dominantCount / totalMoods) * 100).round();

    // Advice based on mood type
    String advice;
    switch (dominantMood!) {
      case Moodtype.awful:
        advice = "It’s been rough. Notice what triggers this mood and try small steps to improve.";
        break;
      case Moodtype.bad:
        advice = "Things weren’t great. Reflect on what made you feel this way and what helped you cope.";
        break;
      case Moodtype.neutral:
        advice = "A calm month! Try adding things that bring you joy or excitement.";
        break;
      case Moodtype.good:
        advice = "Nice work! Keep doing what makes you feel good.";
        break;
      case Moodtype.great:
        advice = "Amazing month! Celebrate the moments that made you feel great.";
        break;
    }

    if (factorCounts.isEmpty) {
      return "This month, you felt mostly ${dominantMood!.label} ($percent% of the time). $advice";
    }

    final topFactor = factorCounts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
    final factorCount = factorCounts[topFactor]!;
    final factorPercent = ((factorCount / dominantCount) * 100).round();

    return "This month, you felt mostly ${dominantMood!.label} ($percent% of the time). It often appeared alongside '$topFactor' ($factorPercent% of the time). $advice";
  }


  @override
  Widget build(BuildContext context) {
    computeStats();

    final maxCount = moodCounts.values.isEmpty
        ? 0
        : moodCounts.values.reduce((a, b) => a > b ? a : b);

    final moodTypes = Moodtype.values;

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
            ? Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No moods recorded yet this month",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.mood, color: Colors.grey[600]),
                    ],
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: moodTypes.map((type) {
                    final count = moodCounts[type] ?? 0;
                    final barHeight = maxCount == 0 ? 0.0 : (count.toDouble() / maxCount) * 160;

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
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 24,
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Monthly Insight",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                getInsight(),
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
