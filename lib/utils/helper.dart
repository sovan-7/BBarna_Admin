import 'package:flutter/material.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Helper {
  static Future<void> showSnackBarMessage(
      {required String msg, required bool isSuccess}) async {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.up,
      content: Text(
        msg,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic),
      ),
      backgroundColor: isSuccess
          ? AppColorsInApp.colorSecondary
          : AppColorsInApp.colorLightRed,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(navigatorKey.currentContext!).size.height - 50,
          left: 50,
          right: 50),
      behavior: SnackBarBehavior.floating,
    ));
  }

   Widget showLoader({Color? color = const Color(0xFF8ADDE1)}) {
    return Center(
        child: LoadingAnimationWidget.hexagonDots(
      color: color ?? AppColorsInApp.colorLightBlue,
      size: 80,
    ));
  }
}
