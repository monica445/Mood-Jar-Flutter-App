import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _AddMoodState();
}

class _AddMoodState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return const Text("Calendar Screen");
  }
}