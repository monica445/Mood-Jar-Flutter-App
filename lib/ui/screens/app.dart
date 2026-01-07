import 'package:flutter/material.dart';
import 'package:mood_jar_app/domain/entities/mood_per_day.dart';
import 'package:mood_jar_app/ui/screens/add_mood.dart';
import 'package:mood_jar_app/ui/screens/dashboard.dart';
import '../../domain/entities/mood_entry.dart';
import './calendar_view.dart';
import '../../domain/services/mood_service.dart';

class MoodJar extends StatefulWidget {
  const MoodJar({super.key});

  @override
  State<MoodJar> createState() => _MoodJarState();
}

enum BottomTab { dashboard, addMood, calendar }

class _MoodJarState extends State<MoodJar> {
  List<MoodPerDay> _moodPerDays = [];
  BottomTab currentTab = BottomTab.dashboard;

  final MoodService _moodService = MoodService();

  @override
  void initState() {
    super.initState();
    _loadAllMoods();
  }

  Future<void> _loadAllMoods() async {
    final moodPerDays = await _moodService.getMoodPerDayWithMoods();

    setState(() {
      _moodPerDays = moodPerDays;
    });
  }

  List<MoodEntry> get todayMoods {
    final today = DateTime.now();

    return _moodPerDays
        .where((d) =>
            d.date.year == today.year &&
            d.date.month == today.month &&
            d.date.day == today.day)
        .expand<MoodEntry>((d) => d.moods)
        .toList();
  }

  List<MoodEntry> get thisMonthMoods {
    final now = DateTime.now();

    return _moodPerDays
        .where((d) =>
            d.date.year == now.year &&
            d.date.month == now.month)
        .expand<MoodEntry>((d) => d.moods)
        .toList();
  }  

  Future<void> onAddMood(MoodEntry newMood) async {
    try {
      await _moodService.addMood(newMood);
      await _loadAllMoods();
    } catch (e) {
      print("Failed to add mood: $e");
    }
  }

  void onEditMood(MoodEntry updatedMood) async {
    try {
      await _moodService.updateMood(updatedMood);
      await _loadAllMoods();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void onRemoveMood(MoodEntry mood) async {
    try {
      await _moodService.deleteMood(mood);
      await _loadAllMoods();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void onGoToAddMood() {
    setState(() {
      currentTab = BottomTab.addMood;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFF9FAFC),
          body: IndexedStack(
            index: currentTab.index,
            children: [
              Dashboard(
                todayMoods: todayMoods,
                onGoToAddMood: onGoToAddMood,
                thisMonthMoods: thisMonthMoods,
              ),
              AddMood(
                todayMoods: todayMoods,
                onEditMood: onEditMood,
                onRemoveMood: onRemoveMood,
                onAddMood: onAddMood,
                onGoToAddMood: onGoToAddMood,
              ),
              CalendarView(moodPerDays: _moodPerDays,),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 8,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: BottomTab.values.map((tab) {
                  final isActive = currentTab == tab;

                  IconData icon;

                  switch (tab) {
                    case BottomTab.dashboard:
                      icon = Icons.home;
                      break;
                    case BottomTab.addMood:
                      icon = Icons.add;
                      break;
                    case BottomTab.calendar:
                      icon = Icons.calendar_month;
                      break;
                  }

                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        setState(() => currentTab = tab);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFA78BFA)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          icon,
                          color: isActive
                              ? Colors.white
                              : const Color.fromARGB(255, 132, 130, 130),
                          size: 30,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      );
  }
}
