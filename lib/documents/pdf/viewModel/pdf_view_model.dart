import 'dart:async';
import 'dart:typed_data';

import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/documents/pdf/model/pdf_model.dart';
import 'package:bbarna/documents/pdf/repo/pdf_repo.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PdfViewModel with ChangeNotifier {
  final PdfRepo _pdfRepo = PdfRepo();
  List<PdfModel> pdfList = [];
  List<PdfModel> copyPdfList = [];
  Timer? _debounce;
  int limit = 50;
  int pdfListLength = 0;
  List<QueryDocumentSnapshot> docList = [];
  late DocumentSnapshot<Map<String, dynamic>> lastDoc;

  Future<DocumentReference<Map<String, dynamic>>> addPdf(
      PdfModel topicModel) async {
    return await _pdfRepo.addPdf(topicModel);
  }

  Future uploadPdf(Uint8List pdf, String pdfCode, String docId) async {
    await _pdfRepo.uploadPDF(pdfCode, pdf, docId);
  }

  Future updatePdf(PdfModel pdfModel, String docId) async {
    LoaderDialogs.showLoadingDialog();

    await _pdfRepo.updatePdf(pdfModel, docId).whenComplete(() {
      Navigator.pop(navigatorKey.currentContext!);
    });
  }

  Future deletePdf(String docId) async {
    await _pdfRepo.deletePdf(docId).whenComplete(() {
      Helper.showSnackBarMessage(
          msg: "Pdf deleted successfully", isSuccess: false);
      getPdfListLength();
    });
  }

  Future getFirstPdfList() async {
    LoaderDialogs.showLoadingDialog();
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _pdfRepo.getFirstPdfList(limit);
    pdfList.clear();
    for (int i = 0; i < snapshot.docs.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> docData =
          snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      if (i == snapshot.docs.length - 1) {
        lastDoc = snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      }
      pdfList.add(PdfModel.fromDocumentSnapshot(docData));
    }
    copyPdfList = pdfList;
    docList.addAll(snapshot.docs);
    Navigator.pop(navigatorKey.currentContext!);
    notifyListeners();
  }

  Future getNextPdfList() async {
    LoaderDialogs.showLoadingDialog();

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _pdfRepo.getNextPdfList(limit, lastDoc);
    for (int i = 0; i < snapshot.docs.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> docData =
          snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      if (i == snapshot.docs.length - 1) {
        lastDoc = snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      }
      pdfList.add(PdfModel.fromDocumentSnapshot(docData));
    }
    Navigator.pop(navigatorKey.currentContext!);
    copyPdfList = pdfList;
    docList.addAll(snapshot.docs);
    notifyListeners();
  }

  Future<void> searchPdf({required String searchText}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (searchText.isEmpty) {
        pdfList = copyPdfList;
        notifyListeners();
      } else {
        try {
          //  LoaderDialogs.showLoadingDialog();
          pdfList = await _pdfRepo.searchPdf(searchText);
          notifyListeners();
          //Navigator.pop(navigatorKey.currentContext!);
        } catch (e) {
          Navigator.pop(navigatorKey.currentContext!);
          Helper.showSnackBarMessage(
              msg: "Error while fetching data", isSuccess: false);
        }
      }
    });
  }

  void removePdfFromLast() {
    int exesData = docList.length % limit;
    if (exesData > 0) {
      docList.removeRange((docList.length - exesData), docList.length);
      pdfList.removeRange((docList.length - exesData), docList.length);
      lastDoc = docList.last as DocumentSnapshot<Map<String, dynamic>>;
      copyPdfList = pdfList;
    } else {
      if ((docList.length - limit) >= limit) {
        docList.removeRange(docList.length - limit, docList.length);
        pdfList.removeRange(pdfList.length - limit, pdfList.length);
        lastDoc = docList.last as DocumentSnapshot<Map<String, dynamic>>;
        copyPdfList = pdfList;
      }
    }
    notifyListeners();
  }

  Future<void> getPdfListLength() async {
    pdfListLength = await _pdfRepo.getPdfListLength();
    notifyListeners();
  }
}
