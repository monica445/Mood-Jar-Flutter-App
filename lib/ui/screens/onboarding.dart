import 'package:flutter/material.dart';
import 'package:mood_jar_app/ui/components/button.dart';
import 'package:mood_jar_app/ui/screens/onboarding_detail.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {

  void onPressedGetStarted(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingDetail()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/onboarding copy.jpg'),
            fit: BoxFit.cover
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Center(
            child: Column(
              children: [
                Text("Hi there, I'm", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600)),
                Text("Mood Jar", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600)),
                Text("A gentle place to notice how you feel"),
                SizedBox(height: 15),
                Button(
                  text: "Get Started", 
                  icon: Icons.arrow_forward,
                  onPressed: ()  => onPressedGetStarted(context)
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}