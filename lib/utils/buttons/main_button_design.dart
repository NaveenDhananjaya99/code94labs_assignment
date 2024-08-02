import 'package:code94labs_assignment/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MainElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  MainElevatedButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
