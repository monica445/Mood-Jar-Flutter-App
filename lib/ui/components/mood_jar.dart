import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/mood_entry.dart';
class MoodJar extends StatelessWidget {
  final List<MoodEntry> todayMoods;
  const MoodJar({super.key, required this.todayMoods});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Container(
              width: 140,
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xFFF0F8FF),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                border: Border.all(
                  color: const Color(0xFFB0BEC5), 
                  width: 3,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: todayMoods.map((mood) {
                    return SvgPicture.asset(
                      mood.type.icon,
                      width: 30,
                      height: 30,
                      colorFilter: ColorFilter.mode(
                        mood.type.color,
                        BlendMode.srcIn,
                      ),
                    );
                  }).toList(),
                  ),
                )
              ),
            ),
          ),
          
          Positioned(
            top: 0,
            child: Container(
              width: 150,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF357ABD), 
                  width: 2,
                ),
              ),
            ),
          ),
      
          Positioned(
            top: -8,
            child: Container(
              width: 40,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF64B5F6), 
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF357ABD), 
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}