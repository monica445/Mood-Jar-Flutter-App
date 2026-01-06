import 'package:flutter/material.dart';
import 'package:mood_jar_app/ui/components/mood_expandable_card.dart';
import '../../domain/entities/mood_entry.dart';
import 'package:mood_jar_app/domain/entities/mood_reflection.dart';
import 'package:mood_jar_app/ui/components/mood_buttons_list.dart';
import 'package:mood_jar_app/ui/components/mood_jar.dart';
import '../../domain/enums/mood_type.dart';
import 'package:mood_jar_app/ui/components/mood_reflection_sheet.dart';

class AddMood extends StatelessWidget {
  final VoidCallback onGoToAddMood;
  final List<MoodEntry> todayMoods;
  final Future<void> Function(MoodEntry mood) onAddMood;
  final void Function(MoodEntry mood) onRemoveMood;
  final void Function(MoodEntry updatedMood) onEditMood;

  const AddMood({
    super.key,
    required this.todayMoods,
    required this.onAddMood,
    required this.onGoToAddMood,
    required this.onRemoveMood,
    required this.onEditMood,
  });

  Future<void> _addMood(BuildContext context, Moodtype type) async {
    final reflection = await showModalBottomSheet<MoodReflection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF9FAFC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const MoodReflectionSheet(),
    );

    if (reflection == null) return;

    await onAddMood(
      MoodEntry(
        type: type,
        timestamp: DateTime.now(),
        reflection: reflection,
      ),
    );

    _showSnackBar(context, "Mood added successfully!", const Color(0xFF51CF66));
  }

  Future<void> _editMood(BuildContext context, MoodEntry mood) async {
    final result = await showModalBottomSheet<MoodReflection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF9FAFC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => MoodReflectionSheet(mood: mood),
    );

    if (result == null) return;

    onEditMood(mood.copyWith(reflection: result));

    _showSnackBar(context, "Mood edited successfully!", const Color(0xFF51CF66));
  }

  void _removeMood(BuildContext context, MoodEntry mood) {
    onRemoveMood(mood);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${mood.type.label} mood removed"),
        backgroundColor: const Color(0xFFE85D75),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "Undo",
          textColor: Colors.white,
          onPressed: () {
            onAddMood(mood.copyWith(id: null));
          },
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Mood",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: MoodJar(
              todayMoods: todayMoods,
              onGoToAddMood: onGoToAddMood,
            ),
          ),

          const SizedBox(height: 20),

          Moodbuttonlist(
            onMoodButtonTap: (type) => _addMood(context, type),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: todayMoods.isEmpty
                ? const Center(
                    child: Text(
                      "No moods added yet for today",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: todayMoods.length,
                    itemBuilder: (context, index) {
                      final mood = todayMoods[index];

                      return Dismissible(
                        key: ValueKey( mood.id ?? mood.timestamp.toIso8601String()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE85D75),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        onDismissed: (_) => _removeMood(context, mood),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: MoodExpandableCard(
                            mood: mood,
                            onEditTap: () => _editMood(context, mood),
                          ),
                        )
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
