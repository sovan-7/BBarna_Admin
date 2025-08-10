import 'package:bbarna/resources/app_colors.dart';
import 'package:flutter/material.dart';

class PriorityButton extends StatelessWidget {
  final String priority;
  const PriorityButton({required this.priority, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 80,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColorsInApp.colorLightBlue),
      child: Text(
        priority,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: AppColorsInApp.colorWhite),
      ),
    );
  }
}
