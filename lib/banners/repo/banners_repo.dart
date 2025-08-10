import 'dart:typed_data';
import 'package:bbarna/banners/model/banners_model.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BannersRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future<DocumentReference<Map<String, dynamic>>> addBanner(
      BannersModel bannersModel) async {
    return await _firestore.collection(banners).add(bannersModel.toMap());
  }

  Future<List<BannersModel>> getBannersList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection(banners).get();
    return snapshot.docs
        .map((docSnapshot) => BannersModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future uploadBannerImage(Uint8List image, String bannerId) async {
    Reference referenceDirImages = storageReference.child("images");
    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    Reference referenceImageToUpload =
        referenceDirImages.child("$timeStamp""_img");
    try {
      final metadata = SettableMetadata(contentType: "image/jpeg");
      await referenceImageToUpload.putData(image, metadata);
      final imageUrl = await referenceImageToUpload.getDownloadURL();
      await _firestore
          .collection(banners)
          .doc(bannerId)
          .update({"banner_image": imageUrl});
    } catch (e) {
      Helper.showSnackBarMessage(
          msg: "Error while banner uploading", isSuccess: false);
    }
  }

  Future deleteBanner(String bannerId) async {
    await _firestore.collection(banners).doc(bannerId).delete();
  }
}
