import 'package:flutter/services.dart';
import 'package:mood_jar_app/domain/entities/mood_entry.dart';
import 'package:mood_jar_app/domain/entities/mood_per_day.dart';
import 'package:mood_jar_app/domain/entities/statistic.dart';

class User {
  final int? id;
  final String? name;
  final DateTime joinedDate;
  Map<DateTime, MoodEntry>? moods;
  Uint8List? profile;
  Statistic? statistic;

  User({this.id ,this.name, this.profile, DateTime? joinedDate}) : joinedDate = joinedDate ?? DateTime.now();

  User copyWith({Uint8List? profile, String? name}){
    return User(
      id: id,
      name: name ?? this.name,
      joinedDate: joinedDate, 
      profile: profile ?? this.profile,
    );
  }

  factory User.fromMap(Map<String, dynamic> mapData){
    return User(
      id:  mapData['id'],
      name: mapData['name'],
      joinedDate: DateTime.parse(mapData['joinedDate']),
      profile: mapData['profile'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'name': name ?? "" ,
      'joinedDate': joinedDate.toIso8601String(),
      'profile': profile,
    };
  }

}