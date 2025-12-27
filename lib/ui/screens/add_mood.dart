import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mood_jar_app/models/entities/mood_entry.dart';
import 'package:mood_jar_app/models/enums/mood_type.dart';
import '../components/note_bottom_sheet.dart';
import 'package:mood_jar_app/ui/components/mood_button.dart';
import 'package:mood_jar_app/ui/components/mood_card.dart';

class AddMood extends StatefulWidget {
  final List<MoodEntry> moods;
  final Function(MoodEntry) onAddMood;
  final Function(MoodEntry updatedMood) onUpdateMood;
  final Function(MoodEntry) onDismissMood;

  const AddMood({
    super.key,
    required this.moods,
    required this.onAddMood,
    required this.onUpdateMood,
    required this.onDismissMood,
  });

  @override
  State<AddMood> createState() => _AddMoodState();
}

class _AddMoodState extends State<AddMood> {
  late List<MoodEntry> todayMoods;

  @override
  void initState() {
    super.initState();
    todayMoods = List.from(widget.moods);
  }

  @override
  void didUpdateWidget(covariant AddMood oldWidget) {
    super.didUpdateWidget(oldWidget);
    todayMoods = List.from(widget.moods);
  }

  void onMoodTap(Moodtype type) {
    final newMood = MoodEntry(type: type);
    final success = widget.onAddMood(newMood);

    if(!success) {
      showDialog(
        context: context, 
        builder: (ctx) => AlertDialog(
          title: const Text("Mood Already Added"),
          content: const Text("You have already added this mood today"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: const Text("OK")
            )
          ],
        )
      );
    }
  }

  void _onAddNoteTap(MoodEntry mood) async {
    final note = await showNoteBottomSheet(
      context: context,
      initialNote: mood.note,
      title: "Add note",
    );

    if (note == null) return;

    final updatedMood = mood.copyWith(note: note);
    widget.onUpdateMood(updatedMood);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF9FAFC),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                "Add Mood",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),

              Flexible(
                flex: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Jar body
                          Container(
                            width: 140,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60),
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                              ),
                              border: Border.all(
                                color: const Color(0xFFFAD089),
                                width: 3,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  alignment: WrapAlignment.center,
                                  children: todayMoods.map((mood) {
                                    return SvgPicture.asset(
                                      mood.type.icon,
                                      width: 30,
                                      height: 30,
                                      colorFilter: ColorFilter.mode(mood.type.color, BlendMode.srcIn),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),

                          // Jar lid
                          Positioned(
                            top: 0,
                            child: Container(
                              width: 140,
                              height: 25,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0B04D ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFEB9F2F ),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                          // Lid top knob
                          Positioned(
                            top: -8,
                            child: Container(
                              width: 40,
                              height: 16,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAD089 ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFEB9F2F),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "How are you feeling now?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: Moodtype.values.map((type) {
                                return MoodButton(
                                  type: type,
                                  onTap: () => onMoodTap(type),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: todayMoods.length,
                  itemBuilder: (context, index) {
                    final mood = todayMoods[index];
                    return Dismissible(
                      key: ValueKey(mood.timestamp.millisecondsSinceEpoch),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: const Color(0xFFE85D75),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          todayMoods.removeAt(index);
                        });

                        widget.onDismissMood(mood);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${mood.type.label} mood removed'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: MoodCard(mood: mood, onAddNoteTap: () => _onAddNoteTap(mood)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
