import 'package:mood_jar_app/data/mockup_moods.dart';
import 'package:mood_jar_app/domain/entities/mood_entry.dart';
import 'package:mood_jar_app/domain/enums/mood_type.dart';

class MoodPerDay {
  final int? id;
  final DateTime date;
  List<MoodEntry> moods = [];

  MoodPerDay({this.id, required this.date});

  MoodPerDay copyWith({DateTime? date}){
  return MoodPerDay(
    id: id,
    date: date ?? this.date, 
    );
  } 

  void addMood(MoodEntry mood){
    moods.add(mood);
  }

  void removeMood(MoodEntry mood){
    try{
      final index = moods.indexOf(mood);
      if(index != -1){
        moods.removeAt(index);
      }
    } 
    catch(e) {
      print("Unable to remove the mood: $e");
    }
  }

  void updateMood(){

  }

  List<MoodEntry> getAllMoodPerDay(){
    return moods;
  }



  Moodtype? getAvgMoodScale() {
    
    int totalMoodWeight = 0;
    double avgMoodWeight = 0;

    if(moods.isEmpty){
      return null;
      
    }
    for(MoodEntry mood in moods){
      totalMoodWeight += mood.type.weight;
    }
    avgMoodWeight = (totalMoodWeight / moods.length);
    
    Moodtype closest = Moodtype.values.first;
    double minDiff = (closest.weight - avgMoodWeight).abs();

    for( var mood in Moodtype.values){
      double diff = (mood.weight - avgMoodWeight).abs();
      if(diff < minDiff){
        minDiff = diff;
        closest = mood;
      }
    }
    return closest;
  }

  factory MoodPerDay.fromMap(Map<String, dynamic> mapData){
    return MoodPerDay(
      id: mapData['id'],
      date: DateTime.parse(mapData['date']), 
    );
  }
  
  Map<String, dynamic> toMap(){
    return {
      'date' : date.toIso8601String(),
    };
  }
 
}