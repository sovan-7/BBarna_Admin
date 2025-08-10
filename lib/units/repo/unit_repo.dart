import 'dart:typed_data';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/subject/model/subject_model.dart';
import 'package:bbarna/units/model/unit_model.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UnitRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future<DocumentReference<Map<String, dynamic>>> addUnit(
      UnitModel unitModel) async {
    return await _fireStore.collection(unit).add(unitModel.toMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFirstUnitList(
      int limit) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(unit)
        .orderBy("timeStamp", descending: true)
        .limit(limit)
        .get();
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getNextUnitList(
      int limit, lastDoc) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(unit)
        .orderBy("timeStamp", descending: true)
        .startAfterDocument(lastDoc)
        .limit(limit)
        .get();
    return snapshot;
  }

  Future uploadUnitImage(
      Uint8List image, String unitCode, String unitId) async {
    Reference referenceDirImages = storageReference.child("images");
    Reference referenceImageToUpload =
        referenceDirImages.child("img_unit_$unitCode");

    try {
      final metadata = SettableMetadata(contentType: "image/jpeg");
      await referenceImageToUpload.putData(image, metadata);
      final imageUrl = await referenceImageToUpload.getDownloadURL();
      await _fireStore
          .collection(unit)
          .doc(unitId)
          .update({"unit_image": imageUrl});
    } catch (e) {
      Helper.showSnackBarMessage(
          msg: "Error while uploading unit", isSuccess: false);
    }
  }

  Future updateUnit(UnitModel unitModel, String unitId) async {
    await _fireStore.collection(unit).doc(unitId).update(unitModel.toMap());
  }

  Future deleteUnit(String unitId) async {
    await _fireStore.collection(unit).doc(unitId).delete();
  }

  Future<List<SubjectModel>> getSubjectListByCourseCode(String courseId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(subject)
        .where("course_code", isEqualTo: courseId)
        .get();
    return snapshot.docs
        .map((docSnapshot) => SubjectModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<int> getUnitListLength() async {
    AggregateQuerySnapshot countSnapshot =
        await _fireStore.collection(unit).count().get();
    return countSnapshot.count ?? 0;
  }

  Future<List<UnitModel>> searchUnit(String searchText) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(unit)
        .where("unit_code", isGreaterThanOrEqualTo: searchText)
        .where("unit_code", isLessThan: '${searchText}z')
        .get();
    return snapshot.docs
        .map((docSnapshot) => UnitModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future deleteMultipleUnit(List<String> unitDocIdList) async {
    for (int i = 0; i < unitDocIdList.length; i++) {
      await _fireStore.collection(unit).doc(unitDocIdList[i]).delete();
    }
  }
}
