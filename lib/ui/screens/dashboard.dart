import 'package:flutter/material.dart';
import 'package:mood_jar_app/domain/entities/mood_entry.dart';
import '../components/todays_moods.dart';
import '../components/calendar_week.dart';

class DashboardScreen extends StatelessWidget {
  final List<MoodEntry> todayMoods;
  final VoidCallback onGoToAddMood;
  final Function(MoodEntry) onUpdateMood; 
  final Function(MoodEntry) onDismissMood;

  const DashboardScreen({
    super.key,
    required this.todayMoods,
    required this.onGoToAddMood,
    required this.onUpdateMood,
    required this.onDismissMood
  });

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final List<DateTime> weekDays = _getCurrentWeek();

    return Scaffold(
      backgroundColor: Color(0xFFF9FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good Morning, Jennie',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 32),

              WeekDaysList(weekDays: weekDays, today: today),

              const SizedBox(height: 32),

              Text(
                'Today, ${today.day} ${_getMonthName(today.month)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 24),

              Expanded(  
                child: TodaysMoods(
                  moods: todayMoods,
                  onGoToAddMood: onGoToAddMood,
                  onDismissMood: onDismissMood,
                  onUpdateMood: onUpdateMood,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static List<DateTime> _getCurrentWeek() {
    final now = DateTime.now();
    final firstDay = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) => firstDay.add(Duration(days: i)));
  }

  static String _getMonthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }
}
