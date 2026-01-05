import 'package:flutter/material.dart';
import 'package:mood_jar_app/domain/entities/mood_per_day.dart';
import 'package:mood_jar_app/ui/screens/mood_per_day.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CalendarView extends StatefulWidget {
  final List<MoodPerDay> moodPerDays;
  const CalendarView({super.key, required this.moodPerDays});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Widget _cellBuilder(DateTime day, {isSelected = false, isToday = false}){
    MoodPerDay? moodDay;
    try {
      moodDay = widget.moodPerDays.firstWhere((d) =>
          d.date.year == day.year &&
          d.date.month == day.month &&
          d.date.day == day.day);
      } catch (_) {
        moodDay = null;
      }
    final avgMood = moodDay?.getAvgMoodScale();
    BoxDecoration? decoration;
    if(isSelected){
      decoration = BoxDecoration(
        color: Color.fromRGBO(167, 139, 250, 1),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
      );
    }
    else if(isToday){
      decoration = BoxDecoration(
        color: Color.fromRGBO(250, 208, 137, 1),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      );
    }
    return Container(
      decoration: decoration,
      child: Center(
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
      ),
    );

  }
 
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
          "Monthly Overview",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),

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
          MoodPerDay? day = widget.moodPerDays.firstWhere((d) => isSameDay(d.date, selectedDay));

          Navigator.push(context, MaterialPageRoute(builder: (context) => MoodPerDayPage(moodPerDay: day)));
        },
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, _){
            return _cellBuilder(day);
          },
          selectedBuilder: (context, day, _){
            return _cellBuilder(day, isSelected: true);
          },
          todayBuilder: (context, day, _){
            return _cellBuilder(day, isToday: true);
          },
        ),
      ),
    ),
  );
}
}

