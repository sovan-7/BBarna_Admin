import 'dart:async';
import 'dart:typed_data';

import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/subject/model/subject_model.dart';
import 'package:bbarna/units/model/unit_model.dart';
import 'package:bbarna/units/repo/unit_repo.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UnitViewModel with ChangeNotifier {
  final UnitRepo _unitRepo = UnitRepo();
  List<UnitModel> unitList = [];
  List<UnitModel> copyUnitList = [];
  List<SubjectModel> subjectListByCourseId = [];
  Timer? _debounce;
  int limit = 50;
  int unitLength = 0;
  //List<String> selectedUnitCodeList = [];
  List<QueryDocumentSnapshot> docList = [];
  late DocumentSnapshot<Map<String, dynamic>> lastDoc;
 // bool willCheckBoxShow = false;
  Future<DocumentReference<Map<String, dynamic>>> addUnit(
      UnitModel unitModel) async {
    return await _unitRepo.addUnit(unitModel);
  }

  Future updateUnit(UnitModel unitModel, String unitId) async {
    await _unitRepo.updateUnit(unitModel, unitId);
  }

  Future deleteUnit(String unitId) async {
    await _unitRepo.deleteUnit(unitId).whenComplete(() {
      Helper.showSnackBarMessage(
          msg: "Unit deleted successfully", isSuccess: false);
    });
    getUnitListLength();
  }

  Future uploadUnitImage(
      Uint8List image, String unitCode, String unitId) async {
    await _unitRepo.uploadUnitImage(image, unitCode, unitId);
  }

  Future getFirstUnitList() async {
    LoaderDialogs.showLoadingDialog();
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _unitRepo.getFirstUnitList(limit);
    unitList.clear();
    for (int i = 0; i < snapshot.docs.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> docData =
          snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      if (i == snapshot.docs.length - 1) {
        lastDoc = snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      }
      unitList.add(UnitModel.fromDocumentSnapshot(docData));
    }
    copyUnitList = unitList;
    docList.addAll(snapshot.docs);
    Navigator.pop(navigatorKey.currentContext!);
    notifyListeners();
  }

  Future getNextUnitList() async {
    LoaderDialogs.showLoadingDialog();

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _unitRepo.getNextUnitList(limit, lastDoc);
    for (int i = 0; i < snapshot.docs.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> docData =
          snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      if (i == snapshot.docs.length - 1) {
        lastDoc = snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      }
      unitList.add(UnitModel.fromDocumentSnapshot(docData));
    }
    Navigator.pop(navigatorKey.currentContext!);
    copyUnitList = unitList;
    docList.addAll(snapshot.docs);
    notifyListeners();
  }

  Future getSubjectListByCourseCode(String courseCode) async {
    subjectListByCourseId =
        await _unitRepo.getSubjectListByCourseCode(courseCode);
    notifyListeners();
  }

  void filterUnit() {
    unitList.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
  }

  Future<void> searchUnit({required String searchText}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (searchText.isEmpty) {
        unitList = copyUnitList;
        notifyListeners();
      } else {
        try {
          //  LoaderDialogs.showLoadingDialog();
          unitList = await _unitRepo.searchUnit(searchText);

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

  void removeUnitFromLast() {
    int exesData = docList.length % limit;
    if (exesData > 0) {
      docList.removeRange((docList.length - exesData), docList.length);
      unitList.removeRange((docList.length - exesData), docList.length);
      lastDoc = docList.last as DocumentSnapshot<Map<String, dynamic>>;
      copyUnitList = unitList;
    } else {
      if ((docList.length - limit) >= limit) {
        docList.removeRange(docList.length - limit, docList.length);
        unitList.removeRange(unitList.length - limit, unitList.length);
        lastDoc = docList.last as DocumentSnapshot<Map<String, dynamic>>;
        copyUnitList = unitList;
      }
    }
    notifyListeners();
  }

  Future<void> getUnitListLength() async {
    unitLength = await _unitRepo.getUnitListLength();
    notifyListeners();
  }

  // selectMultipleUnit(int index) {
  //   if (selectedUnitCodeList.length < 50) {
  //     unitList[index].isSelected = !unitList[index].isSelected;
  //     selectedUnitCodeList.add(unitList[index].code);
  //   } else {
  //     Helper.showSnackBarMessage(
  //         msg: "You can't delete more than 50 unit at a time",
  //         isSuccess: false);
  //   }
  //   notifyListeners();
  // }

  // deselectMultipleUnit(int index) {
  //   unitList[index].isSelected = !unitList[index].isSelected;
  //   selectedUnitCodeList.removeAt(selectedUnitCodeList
  //       .indexWhere((element) => element == unitList[index].code));
  // }

  // deleteMultipleUnit() {}
  // changeVisibility() {
  //   willCheckBoxShow = !willCheckBoxShow;
  //   notifyListeners();
  // }
}
