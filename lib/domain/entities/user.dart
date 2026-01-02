import 'package:mood_jar_app/domain/entities/mood_entry.dart';
import 'package:mood_jar_app/domain/entities/mood_per_day.dart';
import 'package:mood_jar_app/domain/entities/statistic.dart';

class User {
  final int? id;
  final String? name;
  final DateTime joinedDate;
  Map<DateTime, MoodEntry>? moods;
  Statistic? statistic;

  User({this.id ,this.name, DateTime? joinedDate}) : joinedDate = joinedDate ?? DateTime.now();

  factory User.fromMap(Map<String, dynamic> mapData){
    return User(
      id:  mapData['id'],
      name: mapData['name'],
      joinedDate: DateTime.parse(mapData['joinedDate']),
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'name': name ?? "" ,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }

}