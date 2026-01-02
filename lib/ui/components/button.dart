import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color? textColor;
  final Color? backgroundColor;
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final int? width;
  final int? height;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor = const Color.fromRGBO(167, 139, 250, 1),
    this.textColor = Colors.white,
    this.width,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    final button =  ElevatedButton(
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

    return SizedBox(
      width: width?.toDouble(),
      height: height?.toDouble(),
      child: button,
    );
    
  }
}