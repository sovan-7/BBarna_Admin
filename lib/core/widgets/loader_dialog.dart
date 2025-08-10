import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:flutter/material.dart';

class LoaderDialogs {
  static Future<void> showLoadingDialog() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      showDialog<void>(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return PopScope(
                canPop: false,
                child: SimpleDialog(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    children: <Widget>[
                      Center(
                        child: Helper()
                            .showLoader(color: AppColorsInApp.colorLightRed),
                      )
                    ]));
          });
    });
  }
}
