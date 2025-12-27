import 'package:flutter/material.dart';
import '../../data/mockup_moods.dart';
import '../../models/entities/mood_entry.dart';
import './dashboard.dart';
import './add_mood.dart';
import './calendar.dart';

class MoodJarApp extends StatefulWidget {
  const MoodJarApp({super.key});

  @override
  State<MoodJarApp> createState() => _MoodJarAppState();
}

class _MoodJarAppState extends State<MoodJarApp> {
  late List<MoodEntry> _allMoods;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _allMoods = List.from(mockupMoods);
  }

  bool onAddMood ( MoodEntry mood) {
    final todayMoods = getTodayMoods();
    final exist = todayMoods.any((m) => m.type == mood.type);
    if (exist) return false;

    setState(() {
      _allMoods.add(mood);
    });
    
    return true;
  }

  void onDismissMood ( MoodEntry mood) {
    setState(() {
      _allMoods.remove(mood);
    });
  }

  void onUpdateMood(MoodEntry updatedMood) {
    setState(() {
      final index = _allMoods.indexWhere(
        (mood) => mood.timestamp == updatedMood.timestamp,
      );

      if (index != -1) {
        _allMoods[index] = updatedMood;
      }
    });
  }

  List<MoodEntry> getTodayMoods() {
    final now = DateTime.now();
    return _allMoods.where((m) =>
      m.timestamp.year == now.year &&
      m.timestamp.month == now.month &&
      m.timestamp.day == now.day
    ).toList();
  }

  void goToAddMood() {
    setState(() => _currentTabIndex = 1);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        todayMoods: getTodayMoods(),
        onGoToAddMood: goToAddMood,
        onUpdateMood: onUpdateMood,
        onDismissMood: onDismissMood,
      ),
      AddMood(
        moods: getTodayMoods(), 
        onAddMood: onAddMood, 
        onDismissMood: onDismissMood,
        onUpdateMood: onUpdateMood),
      Calendar(),
    ];
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: _currentTabIndex,
          children: screens,
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // slight shadow
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _currentTabIndex,
                onTap: (index) {
                  setState(() {
                    _currentTabIndex = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                elevation: 0,
                showSelectedLabels: false, // Hide labels
                showUnselectedLabels: false, // Hide labels
                items: [
                  // Home Tab
                  BottomNavigationBarItem(
                    icon: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentTabIndex == 0 
                            ? Color(0xFFA78BFA) 
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.home,
                          color: _currentTabIndex == 0 
                              ? Colors.white 
                              : Colors.black,
                          size: 40,
                        ),
                      )
                    ),
                    label: '', // Empty label but required
                  ),
                  
                  // Add Mood Tab (with a larger circle for prominence)
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentTabIndex == 1 
                            ? Color(0xFFA78BFA) 
                            : Colors.black,
                        boxShadow: _currentTabIndex == 1
                            ? [
                                BoxShadow(
                                  color: Color(0xFFA78BFA) .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40, // Slightly larger for emphasis
                      ),
                    ),
                    label: '',
                  ),
                  
                  // Calendar Tab
                  BottomNavigationBarItem(
                    icon: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentTabIndex == 2 
                            ? Color(0xFFA78BFA) 
                            : Colors.transparent,
                      ),
                      child: Icon(
                        Icons.calendar_month,
                        color: _currentTabIndex == 2 
                            ? Colors.white 
                            : Colors.black,
                        size: 40,
                      ),
                    ),
                    label: '',
                  ),
                ],
              ), 
            )
          )
        ),
      )
    );
  }
}