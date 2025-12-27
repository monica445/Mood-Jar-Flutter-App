import 'package:flutter/material.dart';
import './ui/screens/mood_jar_app.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Jar',
      home: MoodJarApp()
    );
  }
}
