import 'package:flutter/material.dart';
import 'package:mood_jar_app/data/repository/user_shared_preference.dart';
import 'package:mood_jar_app/ui/components/empty_mood.dart';
import 'package:mood_jar_app/ui/components/monthly_stats.dart';
import 'package:mood_jar_app/ui/components/mood_jar.dart';
import '../../domain/entities/mood_entry.dart';

class Dashboard extends StatefulWidget {
  final VoidCallback onGoToAddMood;
  final List<MoodEntry> todayMoods;
  final List<MoodEntry> thisMonthMoods;

  const Dashboard({
    super.key, 
    required this.todayMoods, 
    required this.onGoToAddMood, 
    required this.thisMonthMoods
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserName(); 
  }
 

  String _getTimeBasedGreeting () {
    final hour = DateTime.now().hour;

    if(hour < 12) {
      return "Good Morning";
    } else if(hour < 17) {
      return "Good Afternoon";
    } else if(hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();

    final daysOfWeek = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
      'Friday', 'Saturday', 'Sunday'
    ];

    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    final dayOfWeek = daysOfWeek[now.weekday - 1];
    final day = now.day;
    final month = months[now.month - 1];
    final year = now.year;

    return '$dayOfWeek, $day $month $year';
  }

  Future<void> _loadUserName() async {
    final name = await UserSharedPreference.getUserName();
    if(name != null){
      setState(() {
        username = name;
      });
    }
  }

  String? validateName(String? value){
    if (value == null || value.isEmpty) {
      return "Name cannot be empty";
    }
    return null;
  }
  void _showEditNameModal() async{
    TextEditingController nameController = TextEditingController();
    final formKey = GlobalKey<FormState>(); 

    return showModalBottomSheet(context: context, builder: (context){
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text("Enter new name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                  controller: nameController,
                  validator: validateName,
                  autofocus: true,
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: "Enter new name"
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(onPressed: () async {
                  if(formKey.currentState!.validate()){
                    await UserSharedPreference.saveUserName(nameController.text);

                    final updatedName = await UserSharedPreference.getUserName();
                    setState(() {
                      username = updatedName;
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text("Update")),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_getTimeBasedGreeting()}, $username',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              
              IconButton(
                onPressed: _showEditNameModal, 
                icon: 
                  Icon(Icons.edit),
                  color: Colors.grey,
                  iconSize: 15,
              )
            ],
          ),
          Text(
            _getFormattedDate(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  widget.todayMoods.isEmpty
                    ? Center( child: EmptyTodayMoods(onGoToAddMood: widget.onGoToAddMood))
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Feelings Today',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: MoodJar(todayMoods: widget.todayMoods, onGoToAddMood: widget.onGoToAddMood,),
                        )
                      ],
                    ),
                  
                  const SizedBox(height: 40),
                  MonthlyStats(thisMonthMoods: widget.thisMonthMoods),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}