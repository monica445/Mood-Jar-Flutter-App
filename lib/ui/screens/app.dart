import 'package:flutter/material.dart';
import 'package:mood_jar_app/ui/screens/onboarding_detail.dart';
import 'package:mood_jar_app/ui/screens/slash.dart';
import 'package:mood_jar_app/ui/screens/user_profile.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // return Slash();
    return UserProfile();
  }
}