import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color color;
  final Color textColor;
  final Color borderColor;

  CustomButton(
      {required this.onPressed,
      required this.buttonText,
      required this.color,
      required this.textColor,
      this.borderColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderColor),
        ),
      ),
      child: Text(buttonText),
    );
  }
}
