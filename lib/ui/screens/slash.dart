import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mood_jar_app/domain/entities/user.dart';
import 'package:mood_jar_app/domain/service/database_helper.dart';
import 'package:mood_jar_app/ui/screens/calendar_view.dart';
import 'package:mood_jar_app/ui/screens/onboarding.dart';
import 'package:mood_jar_app/ui/animation/animation_util.dart';

class Slash extends StatefulWidget {
  const Slash({super.key});

  @override
  State<Slash> createState() => _SlashState();
}

class _SlashState extends State<Slash> {
  User? user;
  @override
  void initState() {
    super.initState();
    toNextPage();
    // Timer(const Duration(seconds: 2), (){
    //   Navigator.of(context).pushReplacement(AnimationUtil.createRightToLeftRoute(Onboarding()));
    // });


  }

  Future<void> toNextPage() async{
    final fetchedUser = await DatabaseHelper.getUser();
    user = fetchedUser;
    if(user == null){
      Navigator.of(context).pushReplacement(AnimationUtil.createRightToLeftRoute(Onboarding()));
      print("There is not user yet");
      
    }
    else{
      Navigator.of(context).pushReplacement(AnimationUtil.createRightToLeftRoute(CalendarView()));
      print("User name is: ${user!.name}");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/mood-jar.png'), width: 150, height: 150,),
            Text("Mood Jar", style: 
              TextStyle(
                color: Color.fromRGBO(167, 139, 250, 1),
                fontWeight: FontWeight.w500,
                fontSize: 23,
                )),
          ],
        ),
      ),
    );
  }
}