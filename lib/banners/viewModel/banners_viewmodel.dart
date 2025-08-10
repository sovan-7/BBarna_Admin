import 'dart:typed_data';

import 'package:bbarna/banners/model/banners_model.dart';
import 'package:bbarna/banners/repo/banners_repo.dart';
import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannersViewModel extends ChangeNotifier {
    final BannersRepo _bannersRepo = BannersRepo();

  List<BannersModel> bannersList = [];
  Future<DocumentReference<Map<String, dynamic>>> addBanner(
      BannersModel bannersModel) async {
    return await _bannersRepo.addBanner(bannersModel);
  }
Future uploadBannerImage(
      Uint8List image, String bannerId) async {
    await _bannersRepo.uploadBannerImage(image, bannerId);
  }
  Future deleteBanner(String docId) async {
    await _bannersRepo.deleteBanner(docId).whenComplete(() {
      Helper.showSnackBarMessage(
          msg: "Banner deleted successfully", isSuccess: false);
    });
  }

  Future getBannerList() async {
    LoaderDialogs.showLoadingDialog();
    bannersList = await _bannersRepo
        .getBannersList()
        .whenComplete(() => Navigator.pop(navigatorKey.currentContext!));
    notifyListeners();
  }
}
