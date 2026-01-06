import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/mood_entry.dart';
import 'package:mood_jar_app/domain/entities/mood_reflection.dart';
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
  List<String> customFactors = [];

  FocusNode noteFocusNode = FocusNode(); 


  @override
  void initState() {
    super.initState();
    final reflection = widget.mood?.reflection;
    selectedFactors = reflection?.factors?.toList() ?? [];
    noteController.text = reflection?.note ?? '';
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

  void onAddOtherFactor () async{
    
    final newFactor = await showModalBottomSheet<String>(
      context: context, 
      isScrollControlled: true,
      builder: (context) {
        final factorController = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "What else made you feel this way?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: factorController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Type here...",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                    text: "Cancel", 
                    backgroundColor: Colors.grey,
                    onPressed: () => Navigator.pop(context)
                  ),
                  Button(
                    text: "Add", 
                    onPressed: () {
                      final text = factorController.text.trim();
                      if (text.isNotEmpty) {
                        Navigator.pop(context, text); 
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        );
      }
    );

    if(newFactor != null && newFactor.isNotEmpty) {
      setState(() {
        customFactors.add(newFactor);

        if (!selectedFactors.contains(newFactor)) {
          selectedFactors.add(newFactor);
        }
      });
    }    
  }

  void onSave() {
    final hasFactors = selectedFactors.isNotEmpty;
    final hasNote = noteController.text.trim().isNotEmpty;

    final reflection = MoodReflection(
      factors: hasFactors ? selectedFactors.toList() : null,
      note: hasNote ? noteController.text.trim() : null,
    );

    Navigator.pop(context, reflection);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    onPressed: () => Navigator.pop(context, null),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        Button(text: "+ other", onPressed: onAddOtherFactor),
                        if(customFactors.isNotEmpty) 
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: customFactors.map((f) {
                                return Button(
                                  onPressed: () => onFactorToggle(f),
                                  textColor: selectedFactors.contains(f) ? Colors.white : Colors.grey,
                                  backgroundColor: selectedFactors.contains(f) ? const Color(0xFFfad089) : Colors.grey[200],
                                  text: f,
                                ); 
                              }).toList(),
                            ),
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
                              KeyboardListener(
                                focusNode: noteFocusNode,
                                onKeyEvent: (KeyEvent event){
                                  if(event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter){
                                    noteFocusNode.unfocus();
                                  }
                                },
                                child: TextField(
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
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFA78BFA),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20), 
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Button(text: "Save", onPressed: onSave),
            ],
          ),
        ),
      ),
    );
  }
}