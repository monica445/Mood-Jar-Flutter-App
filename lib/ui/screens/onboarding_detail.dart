import 'package:flutter/material.dart';
import 'package:mood_jar_app/domain/entities/user.dart';
import 'package:mood_jar_app/domain/service/database_helper.dart';
import 'package:mood_jar_app/ui/components/button.dart';
import 'package:mood_jar_app/ui/screens/calendar_view.dart';

class OnboardingDetail extends StatefulWidget {
  const OnboardingDetail({super.key});

  @override
  State<OnboardingDetail> createState() => _OnboardingDetailState();
}

class _OnboardingDetailState extends State<OnboardingDetail> {
  final TextEditingController _nameController = TextEditingController();
  String name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(right: 15, top: 65, bottom: 20),
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () async {
                  User guestUser = User(name: "Guest");
                  await DatabaseHelper.addUser(guestUser);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingCompletetion()));
                  print("The guest user is created");
                },
                child: Text("Skip", style: TextStyle(fontSize: 18))),
            ),
            Image(image: AssetImage("assets/icons/hello copy.png"), width: 170, height: 170,),
            SizedBox(height: 20,),
            Text("Let get personal!", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
            Text("How should we call you?", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: _nameController,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Your name...",
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none
                  )
                ),
                onSubmitted: (value) async {
                  setState(() {
                    name = value;
                  });
                  print("${name}");

                  final User newUser = User(name: name);

                  await DatabaseHelper.addUser(newUser);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingCompletetion()));
                  print("The user is created");
                },
              ),
            )
            
          ],
        ),
      ),
    );
  }
}

class OnboardingCompletetion extends StatelessWidget {
  const OnboardingCompletetion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              children: [
                Image(image: AssetImage("assets/icons/smile.png"), width: 170, height: 170,),
                SizedBox(height: 30),
                Text("All Set", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30)),
                Text("Ready when you are", style: TextStyle(fontSize: 15)),
                SizedBox(height: 50),
                Padding(
                  padding:EdgeInsetsGeometry.only(bottom: 80),
                  child: Button(text: "Start", width: 350, onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarView()));
                  })
                )
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}