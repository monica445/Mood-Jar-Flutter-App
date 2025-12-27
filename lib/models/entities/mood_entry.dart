import 'package:mood_jar_app/models/enums/mood_type.dart';

class MoodEntry {
  final Moodtype type;
  final DateTime timestamp;
  final String? note;

  MoodEntry ({ required this.type, this.note, DateTime? time,}) : timestamp = time ?? DateTime.now();

  MoodEntry copyWith ({ String? note }) {
    return MoodEntry(
      type: type,
      time: timestamp,
      note: note
    );
  } 
}
