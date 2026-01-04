import 'package:flutter/material.dart';
import 'package:mood_jar_app/domain/entities/mood_entry.dart';
import 'package:mood_jar_app/domain/entities/mood_per_day.dart';
import 'package:mood_jar_app/domain/enums/mood_type.dart';
import 'package:mood_jar_app/domain/service/database_helper.dart';
import 'package:mood_jar_app/ui/screens/mood_per_day.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<MoodPerDay> moodPerDays = [];

  @override
  void initState() {
    super.initState();
    seedInitialData().then((_) => loadMoodPerDays());
  }


  Future<void> loadMoodPerDays() async {
    print('loadMoodPerDays() called');
    try {
      final fetched = await DatabaseHelper.getMoodPerDayWithMoods();
      print('DB fetch complete: ${fetched.length} items');
      for (var day in fetched) {
        print('Date: ${day.date}, moods: ${day.moods.length}');
      }
      setState(() {
        moodPerDays = fetched;
      });
    } catch (e, s) {
      print('Error fetching moods: $e');
      print(s);
    }
  }

  Future<void> seedInitialData() async {
    // Check if data already exists
    final existingDays = await DatabaseHelper.getAllMoodPerDay();
    if (existingDays.isNotEmpty) return; // prevent duplicates

    // 1. Add MoodPerDay
    final moodPerDay = await DatabaseHelper.addMoodPerDayWithId(
      MoodPerDay(date: DateTime(2025, 12, 30)),
    );

    // 2. Add MoodEntries for that day
    await DatabaseHelper.addNewMood(MoodEntry(
      type: Moodtype.great,
      timestamp: DateTime(2025, 12, 30, 9, 0),
      note: "Morning walk",
      moodPerDayId: moodPerDay.id,
    ));

    await DatabaseHelper.addNewMood(MoodEntry(
      type: Moodtype.neutral,
      timestamp: DateTime(2025, 12, 30, 21, 0),
      note: "Felt tired",
      moodPerDayId: moodPerDay.id,
    ));

    print("Seed data inserted into real DB!");
    
  }


  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Montly Overview"),
    ),
    body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: TableCalendar(
        daysOfWeekHeight: 40,
        rowHeight: 70,
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2025, 1, 1),
        lastDay: DateTime.utc(2027, 12, 31),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          MoodPerDay? day = moodPerDays.firstWhere((d) => isSameDay(d.date, selectedDay));

          Navigator.push(context, MaterialPageRoute(builder: (context) => MoodPerDayPage(moodPerDay: day)));
        },

        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Color.fromRGBO(167, 139, 250, 1),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
          ),
          todayDecoration: BoxDecoration(
            color: Color.fromRGBO(250, 208, 137, 1),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, _){
            MoodPerDay? moodDay;
            try {
              moodDay = moodPerDays.firstWhere((d) =>
                  d.date.year == day.year &&
                  d.date.month == day.month &&
                  d.date.day == day.day);
            } catch (_) {
              moodDay = null;
            }
          final avgMood = moodDay?.getAvgMoodScale();
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${day.day}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                if (avgMood != null)
                  SvgPicture.asset(
                    avgMood.icon,
                    colorFilter: ColorFilter.mode(
                      avgMood.color, 
                      BlendMode.srcIn),
                    width: 20,
                    height: 20,
                  ),
              ],
            ),
            );
          } ,
        ),
      ),
    ),
  );
}
}

