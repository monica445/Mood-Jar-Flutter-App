import 'package:mood_jar_app/ui/screens/slash.dart';
import 'package:flutter/material.dart';
void main() async {
  runApp(MyApp());
  
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Jar',
      // home: Slash(),
      home: Slash(),
    );
  }
} 