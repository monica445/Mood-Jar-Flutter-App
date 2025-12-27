import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor = const Color(0xFFFAD089),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: icon == null
          ? Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Icon(icon, size: 20),
              ],
            ),
    );
  }
}
