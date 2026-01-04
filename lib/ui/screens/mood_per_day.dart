import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mood_jar_app/domain/entities/mood_entry.dart';
import 'package:mood_jar_app/domain/entities/mood_per_day.dart';
import 'package:mood_jar_app/domain/enums/mood_type.dart';
import 'package:mood_jar_app/ui/components/button.dart';


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
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
          child: Column(
            children: [
              SvgPicture.asset(
                avgMood.icon,
                colorFilter: ColorFilter.mode(avgMood.color, BlendMode.srcIn),
                width: 200,
                height: 200,
              ),
              SizedBox(height: 8),
              Text("Overall: ${avgMood.label} day", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),)
            ],
          ),
        );
      }
      else{
        return SizedBox.shrink();
      }
    }

    List<Widget> moodWidgets = [];
    if(moodPerDay != null){
      for(MoodEntry mood in moodPerDay!.moods){
        moodWidgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: SvgPicture.asset(
                mood.type.icon,
                colorFilter: ColorFilter.mode(mood.type.color, BlendMode.srcIn),
                width: 50,
                height: 50,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mood.type.label,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  // Text(
                  //   mood.note ?? '',
                  //   maxLines: 2,
                  // ),
                  Text(
                    DateFormat('h:mm a').format(mood.timestamp),
                    style: TextStyle(color: Colors.grey),
                  )
                ]
              ),
              ),
            ),
          ),
        );
      }
    }


    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: Text(title, style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: Colors.green,
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            overAllMood(),
            SizedBox(height: 20),
            Text("Mood Timeline", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: 20),
            ...moodWidgets,
          ],
        ),
      )
    );
  }
}

