import 'package:mood_jar_app/models/entities/mood_reflection.dart';
import 'package:mood_jar_app/models/enums/mood_type.dart';
import 'package:uuid/uuid.dart';


class MoodEntry {
  final String id;
  final Moodtype type;
  final DateTime timestamp;
  final MoodReflection? reflection;

  MoodEntry({
    String? id,
    required this.type, 
    this.reflection,
    DateTime? timestamp
    }) :  id = id ?? const Uuid().v4(),
          timestamp = timestamp ?? DateTime.now();

  MoodEntry copyWith ({
    String? id,
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
}