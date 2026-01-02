import 'package:mood_jar_app/domain/entities/mood_reflection.dart';
import 'package:uuid/uuid.dart';
import '../enums/mood_type.dart';


class MoodEntry {
  final int? id;
  final Moodtype type;
  final DateTime timestamp;
  final MoodReflection? reflection;
  final int? moodPerDayId;

  MoodEntry({
    this.id,
    required this.type, 
    this.reflection,
    this.moodPerDayId,
    DateTime? timestamp
    }) : timestamp = timestamp ?? DateTime.now();

  MoodEntry copyWith ({
    int? id,
    Moodtype? type,
    DateTime? time,
    MoodReflection? reflection
  }) {
    return MoodEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      timestamp: time ?? this.timestamp,
      reflection: reflection ?? this.reflection
    );
  }

  factory MoodEntry.fromMap(Map<String, dynamic> mapData){
    return MoodEntry(
      id: mapData['id'],
      type: Moodtype.values.firstWhere((mood) => mood.label == mapData['type']),
      timestamp: DateTime.parse(mapData['timestamp']),
      reflection: mapData['reflection'] != null
          ? MoodReflection.fromMap(mapData['reflection'])
          : null,
      );
  }

  Map<String,dynamic> toMap(){
    return{
      'type' : type.label,
      'timestamp': timestamp.toIso8601String(),
      'reflection': reflection?.toMap(),
      'moodPerDayId' : moodPerDayId,
    };
  }
  
}
