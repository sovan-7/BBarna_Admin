import 'dart:typed_data';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/subject/model/subject_model.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SubjectRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future<DocumentReference<Map<String, dynamic>>> addSubject(
      SubjectModel subjectModel) async {
    return await _firestore.collection(subject).add(subjectModel.toMap());
  }

  Future<List<SubjectModel>> getSubjectList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection(subject).get();
    return snapshot.docs
        .map((docSnapshot) => SubjectModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future uploadSubjectImage(
      Uint8List image, String subjectCode, String subjectId) async {
    Reference referenceDirImages = storageReference.child("images");
    Reference referenceImageToUpload =
        referenceDirImages.child("img_$subjectCode");
    try {
      final metadata = SettableMetadata(contentType: "image/jpeg");
      await referenceImageToUpload.putData(image, metadata);
      final imageUrl = await referenceImageToUpload.getDownloadURL();
      await _firestore
          .collection(subject)
          .doc(subjectId)
          .update({"subject_image": imageUrl});
    } catch (e) {
      Helper.showSnackBarMessage(
          msg: "Error while subject uploading", isSuccess: false);
    }
  }

  Future updateSubject(SubjectModel subjectModel, String subjectId) async {
    await _firestore
        .collection(subject)
        .doc(subjectId)
        .update(subjectModel.toMap());
  }

  Future deleteSubject(String subjectId) async {
    await _firestore.collection(subject).doc(subjectId).delete();
  }
}
