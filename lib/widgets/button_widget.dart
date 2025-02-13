import 'package:flutter/material.dart';
import 'package:mobile/constants/constants.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: themeDarkColor,
        iconColor: Colors.white,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(title),
    );
  }
}
