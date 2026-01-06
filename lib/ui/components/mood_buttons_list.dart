import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/enums/mood_type.dart';
class Moodbuttonlist extends StatelessWidget {
  final Function(Moodtype type) onMoodButtonTap;
  const Moodbuttonlist({super.key, required this.onMoodButtonTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      child: Column(
        children: [
          Text(
              "How are you feeling now?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
          const SizedBox(height: 14,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: Moodtype.values.map((moodType) {
              return InkWell(
                onTap: () => onMoodButtonTap(moodType),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(
                    color: moodType.color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: moodType.color.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        moodType.icon,
                        color: moodType.color,
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        moodType.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      )
    );
  }
}
