import 'package:flutter/material.dart';
import 'package:bbarna/resources/app_colors.dart';

class NOFileChoose extends StatelessWidget {
  const NOFileChoose({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: Text("No File Chosen",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: AppColorsInApp.colorBlack1)),
    );
  }
}
