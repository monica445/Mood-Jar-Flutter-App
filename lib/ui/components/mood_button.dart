import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mood_jar_app/domain/enums/mood_type.dart';

class MoodButton extends StatelessWidget {
  final Moodtype type;
  final VoidCallback? onTap;
  
  const MoodButton({super.key, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            type.icon,
            width: 40,
            height: 40,
            colorFilter: ColorFilter.mode(type.color, BlendMode.srcIn),
            fit: BoxFit.contain,
          ),
          Text(
            type.label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}