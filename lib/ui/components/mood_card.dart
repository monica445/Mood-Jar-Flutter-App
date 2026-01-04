import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mood_jar_app/domain/entities/mood_entry.dart';
import 'package:intl/intl.dart';

class MoodCard extends StatelessWidget {
  final MoodEntry mood;
  final VoidCallback onEditTap; 
  
  const MoodCard({super.key, required this.mood, required this.onEditTap});

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
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (mood.reflection?.factors ?? []).map((factor) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          factor,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
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
              onPressed: onEditTap,
              icon: Icon(
                Icons.edit,
                color: const Color(0xFFFAD089),
                size: 28,
              ),
              tooltip:  "Edit"
            )
          ],
        ),
      )
    );
  }
}