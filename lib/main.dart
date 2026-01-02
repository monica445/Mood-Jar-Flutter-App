import 'package:flutter/material.dart';
import 'package:mood_jar_app/ui/screens/app.dart';
import 'package:mood_jar_app/ui/screens/slash.dart';
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
      // home: MoodJarApp()
      home: App(),
    );
  }
}
