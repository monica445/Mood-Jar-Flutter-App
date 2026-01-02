import 'package:flutter/material.dart';
import 'package:mood_jar_app/ui/screens/add_mood.dart';
import 'package:mood_jar_app/ui/screens/dashboard.dart';
import '../../domain/entities/mood_entry.dart';
import './calendar_view.dart';

class MoodJarApp extends StatefulWidget {
  const MoodJarApp({super.key});

  @override
  State<MoodJarApp> createState() => _MoodJarAppState();
}

enum BottomTab {dashboard, addMood, calendar}

class _MoodJarAppState extends State<MoodJarApp> {
  late List<MoodEntry> _allMoods;
  BottomTab currentTab = BottomTab.dashboard;

  @override
  void initState() {
    super.initState();
    _allMoods = [];
  }

  void onAddMood (MoodEntry mood) {
    setState(() {
      _allMoods.add(mood);
    });
  }

  void onGoToAddMood () {
    setState(() {
      currentTab = BottomTab.addMood;
    });
  }

  void onEditMood(MoodEntry updatedMood) {
    setState(() {
      final index = _allMoods.indexWhere((mood) => mood.id == updatedMood.id);
        if (index != -1) {
        _allMoods[index] = updatedMood;
      }
    });
  }

  void onRemoveMood(MoodEntry mood) {
    setState(() {
      _allMoods.removeWhere((m) => m.id == mood.id);
    });
  }

  List<MoodEntry> getTodayMoods(){
    final now = DateTime.now();

    return _allMoods.where((mood) => 
      mood.timestamp.year == now.year &&
      mood.timestamp.month == now.month &&
      mood.timestamp.day == now.day
    ).toList();
  }

  List<MoodEntry> getThisMonthMoods(){
    final now = DateTime.now();

    return _allMoods.where((mood) => 
      mood.timestamp.year == now.year &&
      mood.timestamp.month == now.month 
    ).toList();
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
                todayMoods: getTodayMoods(), 
                onGoToAddMood: onGoToAddMood,
                thisMonthMoods: getThisMonthMoods(),
              ),
              AddMood(
                todayMoods: getTodayMoods(), 
                onUpdateTap: onEditMood,
                onRemoveMood: onRemoveMood,
                onAddMood: onAddMood,
              ),
              CalendarView()
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
                          color: isActive ? Colors.white : const Color.fromARGB(255, 132, 130, 130),
                          size: 30,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

        )
      ) 
    );
  }
}