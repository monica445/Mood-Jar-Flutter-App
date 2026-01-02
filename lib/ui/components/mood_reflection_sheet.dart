import 'package:flutter/material.dart';
import 'package:mood_jar_app/models/entities/mood_entry.dart';
import 'package:mood_jar_app/models/entities/mood_reflection.dart';
import 'package:mood_jar_app/ui/components/button.dart';
import 'package:mood_jar_app/ui/components/factor_category_list.dart';

class MoodReflectionSheet extends StatefulWidget {
  final MoodEntry? mood;
  const MoodReflectionSheet({super.key, this.mood});

  @override
  State<MoodReflectionSheet> createState() => _MoodReflectionSheetState();
}

class _MoodReflectionSheetState extends State<MoodReflectionSheet> {
  List<String> selectedFactors = [];
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final reflection = widget.mood?.reflection;

    selectedFactors = reflection?.factors?.toList() ?? [];

    noteController = TextEditingController(
      text: reflection?.note ?? '',
    );
  }


  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void onFactorToggle (String factor) {
    setState(() {
      if(selectedFactors.contains(factor)) {
        selectedFactors.remove(factor);
      } else {
        selectedFactors.add(factor);
      }
    });
  }

  void onSave () {
    final reflection = MoodReflection(
      factors: selectedFactors.toList(),
      note: noteController.text.trim()
    );

    Navigator.pop(context, reflection);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "What made you feel this way?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          FactorCategoryList(
                            title: "People",
                            factors: ["Family", "Friends", "Partner", "Classmates", "Coworkers", "Social Interaction", "Myself"],
                            onFactorToggle: onFactorToggle,
                            selectedFactors: selectedFactors,
                          ),
                          const SizedBox(height: 12),
                          FactorCategoryList(
                            title: "Work / School",
                            factors: ["Study", "Homework", "Exams", "Deadlines", "Meetings"],
                            onFactorToggle: onFactorToggle,
                            selectedFactors: selectedFactors,
                          ),
                          const SizedBox(height: 12),
                          FactorCategoryList(
                            title: "Body & Health",
                            factors: ["Sleep", "Tired", "Rest", "Exercise", "Energy", "Sick"],
                            onFactorToggle: onFactorToggle,
                            selectedFactors: selectedFactors,
                          ),
                          const SizedBox(height: 12),
                          FactorCategoryList(
                            title: "Activities",
                            factors: ["Music", "Gaming", "Reading", "Watching Movies", "Cooking", "Shopping"],
                            onFactorToggle: onFactorToggle,
                            selectedFactors: selectedFactors,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Want to add some note?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: noteController,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText: "Type your note here...",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF9FAFB),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF3B82F6),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ),
                Button(text: "Save", onPressed: onSave)
              ],
            )
        )
    );
  }
}