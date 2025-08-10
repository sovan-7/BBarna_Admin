// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:bbarna/utils/size_config.dart';
import 'package:bbarna/resources/app_colors.dart';

class AppHeader extends StatelessWidget {
  Function onTapIcon;
  AppHeader({required this.onTapIcon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: SizeConfig.screenWidth,
      color: AppColorsInApp.colorLightBlue,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  onTapIcon();
                },
                child: const Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  "ADMIN PORTAL",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.exit_to_app_rounded,
            color: Colors.red,
            size: 30,
          )
        ],
      ),
    );
  }
}
