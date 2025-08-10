import 'package:bbarna/resources/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PdfModel {
  String docId = stringDefault;
  String code = stringDefault;
  int timeStamp = intDefault;
  String title = stringDefault;
  String description = stringDefault;
  String pdfLink = stringDefault;
  String pdfType = stringDefault;
  bool isDownloadable = boolDefault;
  bool isLocked = boolDefault;

  PdfModel(
    this.code,
    this.description,
    this.title,
    this.pdfLink,
    this.isDownloadable,
    this.pdfType,
    this.timeStamp,
    this.isLocked,
  );

  Map<String, dynamic> toMap() {
    return {
      "pdf_code": code.trim(),
      "pdf_description": description,
      "pdf_title": title,
      "timeStamp": timeStamp,
      "pdf_link": pdfLink,
      "pdf_type": pdfType,
      "is_downloadable": isDownloadable,
      "is_locked":isLocked
    };
  }

  PdfModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : docId = doc.id,
        code = doc.data()!["pdf_code"] ?? stringDefault,
        description = doc.data()!["pdf_description"] ?? stringDefault,
        title = doc.data()!["pdf_title"] ?? stringDefault,
        pdfLink = doc.data()!["pdf_link"] ?? stringDefault,
        pdfType = doc.data()!["pdf_type"] ?? stringDefault,
        isDownloadable = doc.data()!["is_downloadable"] ?? boolDefault,
        timeStamp = doc.data()!["timeStamp"] ?? intDefault,
        isLocked=doc.data()!["is_locked"] ?? boolDefault;
}
