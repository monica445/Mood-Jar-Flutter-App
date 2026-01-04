import 'package:flutter/material.dart';
import 'package:mood_jar_app/domain/service/database_helper.dart';
import 'package:mood_jar_app/ui/screens/add_mood.dart';
import 'package:mood_jar_app/ui/screens/dashboard.dart';
import '../../domain/entities/mood_entry.dart';
import './calendar_view.dart';

class MoodJarApp extends StatefulWidget {
  const MoodJarApp({super.key});

  @override
  State<MoodJarApp> createState() => _MoodJarAppState();
}

enum BottomTab { dashboard, addMood, calendar }

class _MoodJarAppState extends State<MoodJarApp> {
  late List<MoodEntry> _todayMoods = [];
  late List<MoodEntry> _thisMonthMoods = [];
  BottomTab currentTab = BottomTab.dashboard;

  @override
  void initState() {
    super.initState();
    _loadMoods();
  }

  Future<void> _loadMoods() async {

    final todayMoods = await DatabaseHelper.getTodayMoods();
    final monthMoods = await DatabaseHelper.getThisMonthMoods();

    setState(() {
      _todayMoods = todayMoods;
      _thisMonthMoods = monthMoods;
    });
  }

  Future<void> onAddMood(MoodEntry newMood) async {
    final newId = await DatabaseHelper.addMood(newMood); 

    final moodWithId = newMood.copyWith(id: newId);

    setState(() {
      _todayMoods.add(moodWithId);
      _thisMonthMoods.add(moodWithId);
    });
  }

  void onGoToAddMood() {
    setState(() {
      currentTab = BottomTab.addMood;
    });
  }

  void onEditMood(MoodEntry updatedMood) async {
    if (updatedMood.id == null) return;

    await DatabaseHelper.updateMood(updatedMood);

    setState(() {
      _todayMoods = _todayMoods
          .map((m) => m.id == updatedMood.id ? updatedMood : m)
          .toList();
      _thisMonthMoods = _thisMonthMoods
          .map((m) => m.id == updatedMood.id ? updatedMood : m)
          .toList();
    });
  }

  void onRemoveMood(MoodEntry mood) async {
    if (mood.id == null) return;

    await DatabaseHelper.deleteMood(mood);

    setState(() {
      _todayMoods.removeWhere((m) => m.id == mood.id);
      _thisMonthMoods.removeWhere((m) => m.id == mood.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: IndexedStack(
            index: currentTab.index,
            children: [
              Dashboard(
                todayMoods: _todayMoods,
                onGoToAddMood: onGoToAddMood,
                thisMonthMoods: _thisMonthMoods
              ),
              AddMood(
                todayMoods: _todayMoods,
                onEditMood: onEditMood,
                onRemoveMood: onRemoveMood,
                onAddMood: onAddMood,
                onGoToAddMood: onGoToAddMood,
              ),
              CalendarView(),
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
      ),
    );
  }
}
