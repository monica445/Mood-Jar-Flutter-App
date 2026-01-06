import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mood_jar_app/domain/entities/mood_per_day.dart';
import 'package:mood_jar_app/domain/enums/mood_type.dart';
import 'package:mood_jar_app/ui/components/mood_expandable_card.dart';

class MoodPerDayPage extends StatelessWidget {
  final MoodPerDay? moodPerDay;
  const MoodPerDayPage({super.key, required this.moodPerDay});

  @override
  Widget build(BuildContext context) {
    Moodtype? avgMood = moodPerDay?.getAvgMoodScale();
    String title;
    if(moodPerDay != null){
      title = DateFormat('EEE, MMMM d').format(moodPerDay!.date);
    }
    else{
      title = "No data yet";
    }

    Widget overAllMood(){
      if(avgMood != null){
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                avgMood.icon,
                colorFilter: ColorFilter.mode(avgMood.color, BlendMode.srcIn),
                width: 180,
                height: 180,
              ),
              SizedBox(height: 20),
              Text("Overall: ${avgMood.label} day", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 28),)
            ],
          ),
        );
      }
      else{
        return SizedBox.shrink();
      }
    }

    return Scaffold(
        backgroundColor: Color(0xFFF9FAFC),
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            overAllMood(),
            SizedBox(height: 24),
            Text("Mood Timeline", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: 20),
            ...moodPerDay!.moods.map((mood) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MoodExpandableCard(mood: mood),
              );
            })
          ],
        ),
      )
    );
  }
}

