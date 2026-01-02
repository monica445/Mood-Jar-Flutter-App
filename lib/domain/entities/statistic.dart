import 'package:mood_jar_app/domain/entities/mood_per_day.dart';

class Statistic {
  Map<DateTime, MoodPerDay>? allMoods;

  Statistic(Map<DateTime, MoodPerDay>? allMoods) : allMoods = allMoods ?? {};

}