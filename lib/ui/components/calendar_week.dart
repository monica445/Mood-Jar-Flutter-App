import 'package:flutter/material.dart';

class WeekDaysList extends StatelessWidget {
  final List<DateTime> weekDays;
  final DateTime today;

  const WeekDaysList({
    super.key,
    required this.weekDays,
    required this.today,
  });

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }

  bool _isToday(DateTime date) {
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: weekDays.map((date) {
          bool isToday = _isToday(date);

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isToday ? Color(0xFF34D399) : Colors.transparent,
                border: Border(
                  right: date != weekDays.last 
                      ? BorderSide(color: Colors.grey[200]!, width: 1) 
                      : BorderSide.none,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                      color: isToday ? Colors.white : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getDayName(date.weekday),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isToday ? Colors.white : Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}