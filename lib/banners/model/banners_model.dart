import 'package:bbarna/resources/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BannersModel {
  String docId = stringDefault;
  String bannerImage = stringDefault;
  BannersModel({required this.bannerImage});
  Map<String, dynamic> toMap() {
    return {
      "banner_image": bannerImage,
    };
  }

  BannersModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : docId = doc.id,
        bannerImage = doc.data()!["banner_image"] ?? stringDefault;
}
