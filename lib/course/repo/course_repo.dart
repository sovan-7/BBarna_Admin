import 'dart:typed_data';

import 'package:bbarna/course/model/course_model.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CourseRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future<DocumentReference<Map<String, dynamic>>> addCourse(
      CourseModel courseModel) async {
    return await _fireStore.collection(course).add(courseModel.toMap());
  }

  Future<List<CourseModel>> getCourseList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _fireStore.collection(course).get();
    return snapshot.docs
        .map((docSnapshot) => CourseModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future uploadCourseImage(
      Uint8List image, String courseCode, String courseId) async {
    Reference referenceDirImages = storageReference.child("images");
    Reference referenceImageToUpload =
        referenceDirImages.child("img_$courseCode");
    try {
      final metadata = SettableMetadata(contentType: "image/jpeg");
      await referenceImageToUpload.putData(image, metadata);
      final imageUrl = await referenceImageToUpload.getDownloadURL();
      await _fireStore
          .collection(course)
          .doc(courseId)
          .update({"course_image": imageUrl});
    } catch (e) {
      Helper.showSnackBarMessage(
          msg: "Error while uploading course", isSuccess: false);
    }
  }

  Future updateCourse(CourseModel courseModel, String docId) async {
    await _fireStore.collection(course).doc(docId).update(courseModel.toMap());
  }

  Future deleteCourse(String docId) async {
    await _fireStore.collection(course).doc(docId).delete();
  }
}
