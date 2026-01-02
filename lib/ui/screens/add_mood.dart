import 'package:flutter/material.dart';
import '../../domain/entities/mood_entry.dart';
import 'package:mood_jar_app/domain/entities/mood_reflection.dart';
import 'package:mood_jar_app/ui/components/mood_buttons_list.dart';
import 'package:mood_jar_app/ui/components/mood_card.dart';
import 'package:mood_jar_app/ui/components/mood_jar.dart';
import '../../domain/enums/mood_type.dart';
import 'package:mood_jar_app/ui/components/mood_reflection_sheet.dart';

class AddMood extends StatelessWidget {
  final List<MoodEntry> todayMoods;
  final Function(MoodEntry mood) onAddMood;
  final Function(MoodEntry mood) onRemoveMood;
  final Function (MoodEntry updatedMood) onUpdateTap;
  const AddMood({
    super.key,
    required this.todayMoods,
    required this.onAddMood,
    required this.onRemoveMood,
    required this.onUpdateTap
  });

  Future<void> onEditMood(BuildContext context, MoodEntry mood) async {
    final result = await showModalBottomSheet<MoodReflection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFFF9FAFC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => MoodReflectionSheet(mood: mood),
    );

    final updatedMood = mood.copyWith(
      reflection: result
    );

    onUpdateTap(updatedMood);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Mood edited successfully!"),
        backgroundColor: Color(0xFF51CF66),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> onMoodTap(BuildContext context, Moodtype type) async{
    final result = await showModalBottomSheet<MoodReflection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFFF9FAFC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => MoodReflectionSheet(),
    );

    final MoodEntry newMood = MoodEntry(
      type: type,
      reflection: result
    );

    onAddMood (newMood);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Mood added successfully!"),
        backgroundColor: Color(0xFF51CF66),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column (
        children: [
          Text(
            "Add Mood",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
          ),
          const SizedBox(height: 20,),
          MoodJar(todayMoods: todayMoods),
          const SizedBox(height: 20,),
          Moodbuttonlist(onMoodButtonTap: (type) => onMoodTap(context, type)),
          const SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
              itemCount: todayMoods.length,
              itemBuilder: (context, index){
                final mood = todayMoods[index];
                return Dismissible(
                  key: Key(mood.id), 
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: Color(0xFFE85D75),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  onDismissed: (direction) {
                    final removedMood = mood; //for when undo
                    onRemoveMood(mood);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${mood.type.label} mood removed",
                        ),
                        backgroundColor: Color(0xFFE85D75),
                        duration: const Duration(seconds: 3),
                        action: SnackBarAction(
                          label: "Undo",
                          textColor: Colors.white,
                          onPressed: () {
                            // add mood back
                            onAddMood(removedMood);
                          },
                        ),
                      ),
                    );
                  },
                  child: MoodCard(mood: mood, onUpdateTap: onEditMood)
                );
              }
            )
          )
        ],
      )
    );
  }
}