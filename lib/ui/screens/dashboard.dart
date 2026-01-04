import 'package:flutter/material.dart';
import 'package:mood_jar_app/ui/components/empty_mood.dart';
import 'package:mood_jar_app/ui/components/monthly_stats.dart';
import 'package:mood_jar_app/ui/components/mood_jar.dart';
import '../../domain/entities/mood_entry.dart';

class Dashboard extends StatelessWidget {
  final VoidCallback onGoToAddMood;
  final List<MoodEntry> todayMoods;
  final List<MoodEntry> thisMonthMoods;

  const Dashboard({
    super.key, 
    required this.todayMoods, 
    required this.onGoToAddMood, 
    required this.thisMonthMoods
  });

  String _getTimeBasedGreeting () {
    final hour = DateTime.now().hour;

    if(hour < 12) {
      return "Good Morning";
    } else if(hour < 17) {
      return "Good Afternoon";
    } else if(hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();

    final daysOfWeek = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
      'Friday', 'Saturday', 'Sunday'
    ];

    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    final dayOfWeek = daysOfWeek[now.weekday - 1];
    final day = now.day;
    final month = months[now.month - 1];
    final year = now.year;

    return '$dayOfWeek, $day $month $year';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${_getTimeBasedGreeting()}, Jennie",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            _getFormattedDate(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  todayMoods.isEmpty
                    ? EmptyTodayMoods(onGoToAddMood: onGoToAddMood)
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Feelings Today',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: MoodJar(todayMoods: todayMoods, onGoToAddMood: onGoToAddMood,),
                        )
                      ],
                    ),
                  
                  const SizedBox(height: 40),
                  MonthlyStats(thisMonthMoods: thisMonthMoods),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}