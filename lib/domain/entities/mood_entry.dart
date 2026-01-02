import 'package:mood_jar_app/domain/entities/mood_per_day.dart';
import 'package:mood_jar_app/domain/enums/mood_type.dart';

class MoodEntry {
  final int? id;
  final Moodtype type;
  final DateTime timestamp;
  final String? note;
  final int? moodPerDayId;

  MoodEntry ({this.id, required this.type, this.note, DateTime? timestamp, this.moodPerDayId}) : timestamp = timestamp ?? DateTime.now();

  MoodEntry copyWith ({int? id ,String? note,int? moodPerDayId}) {
    return MoodEntry(
      id: id ?? this.id,
      type: type,
      timestamp: timestamp,
      note: note ?? this.note,
      moodPerDayId: moodPerDayId ?? this.moodPerDayId,
    );
  } 

  factory MoodEntry.fromMap(Map<String, dynamic> mapData){
    return MoodEntry(
      id: mapData['id'],
      type: Moodtype.values.firstWhere((mood) => mood.label == mapData['type']),
      timestamp: DateTime.parse(mapData['timestamp']),
      note: mapData['note'],
      );
  }

  Map<String,dynamic> toMap(){
    return{
      'type' : type.label,
      'timestamp': timestamp.toIso8601String(),
      'note': note ?? "",
      'moodPerDayId' : moodPerDayId,
    };
  }
  
}
