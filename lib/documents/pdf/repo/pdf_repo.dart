import 'dart:typed_data';
import 'package:bbarna/documents/pdf/model/pdf_model.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PdfRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future<DocumentReference<Map<String, dynamic>>> addPdf(
      PdfModel pdfModel) async {
    return await _fireStore.collection(pdf).add(pdfModel.toMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFirstPdfList(
      int limit) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(pdf)
        .orderBy("timeStamp", descending: true)
        .limit(limit)
        .get();
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getNextPdfList(
      int limit, lastDoc) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(pdf)
        .orderBy("timeStamp", descending: true)
        .startAfterDocument(lastDoc)
        .limit(limit)
        .get();
    return snapshot;
  }
  Future updatePdf(PdfModel pdfModel, String docId) async {
    await _fireStore.collection(pdf).doc(docId).update(pdfModel.toMap());
  }

  Future deletePdf(String docId) async {
    await _fireStore.collection(pdf).doc(docId).delete();
  }

  Future<void> uploadPDF(String pdfCode, Uint8List pdfData, String pdfId) async {
  try {
       Reference pdfDirReference = storageReference.child("pdf");
    Reference pdfReference = pdfDirReference.child("pdf_$pdfCode");
    final metadata = SettableMetadata(contentType: 'application/pdf');
    await pdfReference.putData(pdfData, metadata);
    String pdfUrl = await pdfReference.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('pdf')  
        .doc(pdfId)         
        .update({"pdf_link": pdfUrl});
  } catch (e) {
   Helper.showSnackBarMessage(
          msg: "Error while uploading pdf", isSuccess: false);
  }
}
Future<int> getPdfListLength() async {
    AggregateQuerySnapshot countSnapshot =
        await _fireStore.collection(pdf).count().get();
    return countSnapshot.count ?? 0;
  }

  Future<List<PdfModel>> searchPdf(String searchText) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(pdf)
        .where("pdf_code", isGreaterThanOrEqualTo: searchText)
        .where("pdf_code", isLessThan: '${searchText}z')
        .get();
    return snapshot.docs
        .map((docSnapshot) => PdfModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
