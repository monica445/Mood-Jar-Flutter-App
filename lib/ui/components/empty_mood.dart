import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mood_jar_app/ui/components/button.dart';

class EmptyTodayMoods extends StatelessWidget {
  final VoidCallback onGoToAddMood;
  const EmptyTodayMoods({super.key, required this.onGoToAddMood});

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
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/good.svg",
            colorFilter: ColorFilter.mode(Color(0xFF7A7A7A), BlendMode.srcIn),
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
            onPressed: onGoToAddMood,
            backgroundColor: Color(0xFFA78BFA),
          )
        ],
      )
    );
  }
}