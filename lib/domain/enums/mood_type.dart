import 'package:flutter/material.dart';

enum Moodtype {
  awful(weight: -2, label: "Awful", icon: "assets/icons/awful.svg", color: Color(0xFFA78BFA)),
  bad(weight: -1, label: "Bad", icon: "assets/icons/bad.svg", color: Color(0xFF3B82F6)),
  neutral(weight: 0, label: "Neutral", icon: "assets/icons/neutral.svg", color: Color(0xFF9CA3AF)),
  good(weight: 1, label: "Good", icon: "assets/icons/good.svg", color: Color(0xFF34D399)),
  great(weight: 2, label: "Great", icon: "assets/icons/great.svg", color: Color(0xFFFCD34D));

  final int weight;
  final String label;
  final String icon;
  final Color color;

  const Moodtype({
    required this.weight,
    required this.label,
    required this.icon,
    required this.color
  });

}