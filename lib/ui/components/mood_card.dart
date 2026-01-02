import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mood_jar_app/domain/entities/mood_entry.dart';
import 'package:intl/intl.dart';

class MoodCard extends StatelessWidget {
  final MoodEntry mood;
  final VoidCallback onAddNoteTap;
  
  const MoodCard({super.key, required this.mood, required this.onAddNoteTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFF9FAFC),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            SvgPicture.asset(
              mood.type.icon, 
              width: 40, 
              height: 40, 
              colorFilter: ColorFilter.mode(mood.type.color, BlendMode.srcIn), 
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 20,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mood.type.label,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (mood.note != null && mood.note!.isNotEmpty)
                    Text(
                      mood.note!,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF2E2E2E)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                        
                    ),
                  Text(
                    DateFormat('HH:mm').format(mood.timestamp),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF7A7A7A)),
                  ),
              
                ],
              ),
            ),
            const SizedBox(width: 12,),
            IconButton(
              onPressed: onAddNoteTap,
              icon: Icon(
                mood.note != null && mood.note!.isNotEmpty
                  ? Icons.edit_note
                  : Icons.add_comment_outlined,
                color: const Color(0xFFFAD089),
                size: 28,
              ),
              tooltip: mood.note != null && mood.note!.isNotEmpty 
                  ? "Edit note" 
                  : "Add note",
            )
          ],
        ),
      )
    );
  }
}