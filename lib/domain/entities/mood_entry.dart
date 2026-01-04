import 'dart:convert';

import 'package:mood_jar_app/domain/entities/mood_reflection.dart';
import 'package:mood_jar_app/domain/enums/mood_type.dart'; // Add this import

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
    MoodReflection? reflection,
    int? moodPerDayId
  }) {
    return MoodEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      timestamp: time ?? this.timestamp,
      reflection: reflection ?? this.reflection,
      moodPerDayId: moodPerDayId ?? this.moodPerDayId,
    );
  }

  factory MoodEntry.fromMap(Map<String, dynamic> mapData){
    // Handle reflection from JSON string
    MoodReflection? reflection;
    if (mapData['reflection'] != null) {
      try {
        // If reflection is stored as a JSON string
        if (mapData['reflection'] is String) {
          final reflectionMap = jsonDecode(mapData['reflection'] as String);
          reflection = MoodReflection.fromMap(Map<String, dynamic>.from(reflectionMap));
        } 
        // If reflection is already a Map (for backward compatibility)
        else if (mapData['reflection'] is Map) {
          reflection = MoodReflection.fromMap(Map<String, dynamic>.from(mapData['reflection']));
        }
      } catch (e) {
        print("Error parsing reflection: $e");
      }
    }

    return MoodEntry(
      id: mapData['id'] as int?,
      type: Moodtype.values.firstWhere(
        (mood) => mood.name.toLowerCase() == (mapData['type'] as String).toLowerCase(),
      ),
      timestamp: DateTime.parse(mapData['timestamp'] as String),
      reflection: reflection,
      moodPerDayId: mapData['moodPerDayId'] as int?,
    );
  }

  Map<String,dynamic> toMap(){
    // Convert reflection to JSON string
    String? reflectionJson;
    if (reflection != null) {
      reflectionJson = jsonEncode(reflection!.toMap());
    }

    return{
      'id': id,
      'type': type.name, 
      'timestamp': timestamp.toIso8601String(),
      'reflection': reflectionJson, // Store as JSON string
      'moodPerDayId': moodPerDayId,
    };
  }
}