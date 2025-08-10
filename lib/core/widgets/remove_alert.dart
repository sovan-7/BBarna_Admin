import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:flutter/material.dart';

class RemoveAlert {
  static Future<void> showRemoveAlert(
      {required String title, required String description,required Function onPressYes}) async {
    Future.delayed(const Duration(milliseconds: 100), () {
      showDialog<void>(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
                elevation: 5,
                shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0)),
                backgroundColor: AppColorsInApp.colorWhite,
                titlePadding: const EdgeInsets.only(top: 15),
                title: Align(
                  alignment: Alignment.center,
                  child: Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 15,
                        color: AppColorsInApp.colorBlack1,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                contentPadding:
                    const EdgeInsets.only(top: 15, bottom: 25, left: 30),
                content:  Text(description
                  ,
                  style: const TextStyle(
                      fontSize: 15, color: AppColorsInApp.colorBlack1),
                ),
                actions: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 25,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: AppColorsInApp.colorPrimary,
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: AppColorsInApp.colorWhite),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onPressYes();
                    },
                    child: Container(
                      height: 25,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: AppColorsInApp.colorBlue,
                      ),
                      child: const Text(
                        "Yes",
                        style: TextStyle(color: AppColorsInApp.colorWhite),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    });
  }
}
