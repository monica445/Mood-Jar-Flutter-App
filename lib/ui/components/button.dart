import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color? textColor;
  final Color? backgroundColor;
  final String text;
  final VoidCallback onPressed;

  const Button({
    super.key,
    this.textColor = Colors.white,
    this.backgroundColor = const Color(0xFFA78BFA),
    required this.text,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12
        ),
        backgroundColor: backgroundColor,
        foregroundColor: textColor
      ), 
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      )
    );
  }
}