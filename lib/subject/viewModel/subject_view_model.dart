import 'dart:typed_data';
import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/subject/model/subject_model.dart';
import 'package:bbarna/subject/repo/subject_repo.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubjectViewModel with ChangeNotifier {
  final SubjectRepo _subjectRepo = SubjectRepo();
  List<SubjectModel> subjectList = [];
  List<SubjectModel> copySubjectList = [];

  Future<DocumentReference<Map<String, dynamic>>> addSubject(
      SubjectModel subjectModel) async {
    return await _subjectRepo.addSubject(subjectModel);
  }

  Future updateSubject(SubjectModel subjectModel, String subjectId) async {
    await _subjectRepo.updateSubject(subjectModel, subjectId);
  }

  Future deleteSubject(String subjectId) async {
    await _subjectRepo.deleteSubject(subjectId).whenComplete(() {
      Helper.showSnackBarMessage(
          msg: "Subject deleted successfully", isSuccess: false);
    });
  }

  Future uploadSubjectImage(
      Uint8List image, String subjectCode, String subjectId) async {
    await _subjectRepo.uploadSubjectImage(image, subjectCode, subjectId);
  }

  Future getSubjectList() async {
    LoaderDialogs.showLoadingDialog();
    subjectList = await _subjectRepo
        .getSubjectList()
        .whenComplete(() => Navigator.pop(navigatorKey.currentContext!));
    copySubjectList = subjectList;
    if (subjectList.isNotEmpty) {
      filterSubject();
    }
    notifyListeners();
  }

  searchSubject({required String searchText}) {
    if (searchText.isEmpty) {
      subjectList = copySubjectList;
    } else {
      subjectList = copySubjectList
          .where((subject) =>
              (subject.code
                  .toLowerCase()
                  .contains(searchText.toLowerCase())) ||
              (subject.name.toLowerCase().contains(searchText.toLowerCase())))
          .toList();
    }

    notifyListeners();
  }

  filterSubject() {
    subjectList
        .sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
  }
}
