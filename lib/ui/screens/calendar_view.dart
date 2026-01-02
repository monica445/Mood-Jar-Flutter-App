import 'package:flutter/material.dart';
import 'package:mood_jar_app/domain/entities/mood_entry.dart';
import 'package:mood_jar_app/domain/entities/mood_per_day.dart';
import 'package:mood_jar_app/domain/service/database_helper.dart';
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
    loadMoodPerDays();
  }


  Future<void> loadMoodPerDays() async {
    final fetched = await DatabaseHelper.getAllMoodPerDay();
    setState(() {
      moodPerDays = fetched;
    });
  }

  Map<DateTime, List<MoodEntry>> getEventsForCalendar(){
    final Map<DateTime, List<MoodEntry>> events = {};

    for(var day in moodPerDays){
      events[DateTime.utc(day.date.year, day.date.month, day.date.day)] = day.moods;
    }
    return events;
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
        },
        eventLoader: (day) {
          final events = getEventsForCalendar();
          return events[DateTime.utc(day.year, day.month, day.day)] ?? [];
        },
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, _){
            final events = getEventsForCalendar();
            final hasEvents = events[DateTime.utc(day.year, day.month, day.day)] ?. isNotEmpty ?? false;
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
                      // avgMood.icon,
                      "assets/icons/awful copy.svg",
                      color: avgMood.color,
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