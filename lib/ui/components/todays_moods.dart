import 'package:flutter/material.dart';
import 'package:mood_jar_app/models/entities/mood_entry.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mood_jar_app/ui/components/mood_card.dart';
import '../components/button.dart';
import '../components/note_bottom_sheet.dart';

class TodaysMoods extends StatefulWidget {
  final List<MoodEntry> moods;
  final VoidCallback onGoToAddMood;
  final Function(MoodEntry updatedMood) onUpdateMood;
  final Function(MoodEntry) onDismissMood;

  const TodaysMoods({
    super.key,
    required this.moods,
    required this.onGoToAddMood,
    required this.onUpdateMood,
    required this.onDismissMood,
  });

  @override
  State<TodaysMoods> createState() => _TodaysMoodsState();
}

class _TodaysMoodsState extends State<TodaysMoods> {
  late List<MoodEntry> todayMoods;

  @override
  void initState() {
    super.initState();
    // Initialize the internal list from parent
    todayMoods = List.from(widget.moods);
  }

  @override
  void didUpdateWidget(covariant TodaysMoods oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update internal list if parent sends new data
    todayMoods = List.from(widget.moods);
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: todayMoods.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/good.svg",
                  colorFilter:
                      ColorFilter.mode(Color(0xFF7A7A7A), BlendMode.srcIn),
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                const Text(
                  'How are you feeling?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nothing today yet - take a second',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Button(
                  text: "Add Mood",
                  onPressed: widget.onGoToAddMood,
                  icon: Icons.add,
                  backgroundColor: Color(0xFFA78BFA),
                )
              ],
            )
          : ListView.builder(
              itemCount: todayMoods.length,
              itemBuilder: (context, index) {
                final mood = todayMoods[index];
                return Dismissible(
                  key: ValueKey(mood.timestamp.millisecondsSinceEpoch),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Color(0xFFE85D75),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    widget.onDismissMood(mood); 

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${mood.type.label} removed'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: MoodCard(mood: mood, onAddNoteTap: () => _onAddNoteTap(mood)),
                );
              },
            ),
    );
  }
}
