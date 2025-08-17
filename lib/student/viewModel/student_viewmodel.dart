import 'dart:developer';

import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/course/model/course_model.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/student/model/enrolled_course_model.dart';
import 'package:bbarna/student/model/student_model.dart';
import 'package:bbarna/student/repo/student_repo.dart';
import 'package:bbarna/subject/model/subject_model.dart';
import 'package:bbarna/units/model/unit_model.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentViewModel with ChangeNotifier {
  List<Student> studentList = [];
  List<Student> copyStudentList = [];

  final StudentRepo _studentRepo = StudentRepo();
  List<CourseModel> courseList = [];
  List<SubjectModel> subjectList = [];
  List<UnitModel> unitList = [];
  List<String> selectedUnitList = [];
  List<String> editedUnitList = [];
  EnrolledCourseBaseModel? enrolledCourseBaseModel;
  int selectedUnitLength = 0;
  int selectedEditedUnitListLength = 0;
  int limit = 300;
  int studentListLength = 0;
  late DocumentSnapshot<Map<String, dynamic>> lastDoc;
  List<DocumentSnapshot<Map<String, dynamic>>> docList = [];
  List<UnitModel> selectedEditUnitList = [];
  EnrolledCourseModel? selectedSubjectModel;

  List<UnitModel> editUnitList = [];
  clearStudentData() {
    enrolledCourseBaseModel = null;
    selectedEditUnitList.clear();
    unitList.clear();
    studentListLength = 0;
    docList.clear();
  }

  // Future getStudentList() async {
  //   LoaderDialogs.showLoadingDialog();
  //   studentList = await _studentRepo
  //       .getStudentList()
  //       .whenComplete(() => Navigator.pop(navigatorKey.currentContext!));
  //   copyStudentList.clear();
  //   copyStudentList.addAll(studentList);
  //   notifyListeners();
  // }

  getEnrolledCourseList(String studentId) async {
    try {
      enrolledCourseBaseModel =
          await _studentRepo.getEnrolledCourseList(studentId);
      log(enrolledCourseBaseModel?.docId ?? "pppppppppp");
      notifyListeners();
    } catch (e) {
      log(e.toString());
      //   Helper.showSnackBarMessage(
      //       msg: "Error while fetching data", isSuccess: false);
    }
  }

  Future getCourseList() async {
    LoaderDialogs.showLoadingDialog();
    courseList = await _studentRepo
        .getCourseList()
        .whenComplete(() => Navigator.pop(navigatorKey.currentContext!));
    notifyListeners();
  }

  Future getSubjectList(String courseCode) async {
    subjectList = await _studentRepo.getSubjectList(courseCode);
    clearUnitList();
    notifyListeners();
  }

  Future getUnitList({required String subjectCode}) async {
    LoaderDialogs.showLoadingDialog();
    clearUnitList();
    unitList = await _studentRepo
        .getUnitList(subjectCode: subjectCode)
        .whenComplete(() => Navigator.pop(navigatorKey.currentContext!));
    for (int i = 0; i < unitList.length; i++) {
      selectedUnitList.add("");
    }
    notifyListeners();
  }

  clearUnitList() {
    selectedUnitList.clear();
    unitList.clear();
    selectedUnitLength = 0;
  }

  updateCheckList(int index) {
    if (selectedUnitList[index] == "") {
      selectedUnitList[index] = unitList[index].code;
    } else {
      selectedUnitList[index] = "";
    }
    selectedUnitLength = selectedUnitList
        .where(
          (element) => element != "",
        )
        .toList()
        .length;
    notifyListeners();
  }

  setAllCheckList() {
    if (selectedUnitList.contains("")) {
      for (int i = 0; i < unitList.length; i++) {
        selectedUnitList[i] = unitList[i].code;
      }
    } else {
      for (int i = 0; i < unitList.length; i++) {
        selectedUnitList[i] = "";
      }
    }
    selectedUnitLength = selectedUnitList
        .where(
          (element) => element != "",
        )
        .toList()
        .length;
    notifyListeners();
  }

  Future enrolledCourse(
      String subjectCode,
      String subjectName,
      String subjectImage,
      int accessTill,
      String studentId,
      String studentName) async {
    LoaderDialogs.showLoadingDialog();
    try {
      selectedUnitList.removeWhere((element) => element == "");
      if (enrolledCourseBaseModel != null) {
        Map<String, dynamic> data = {
          "access_till": accessTill,
          "access_type": "PAID",
          "subject_code": subjectCode,
          "subject_image": subjectImage,
          "subject_name": subjectName,
          "unit_code_list": selectedUnitList
        };
        _studentRepo.addCourse(data, studentId).then((value) {
          Navigator.pop(navigatorKey.currentContext!);
          getEnrolledCourseList(studentId);
        });
      } else {
        Map<String, dynamic> data = {
          "course_list": [
            {
              "access_till": accessTill,
              "access_type": "PAID",
              "subject_code": subjectCode,
              "subject_image": subjectImage,
              "subject_name": subjectName,
              "unit_code_list": selectedUnitList
            },
          ],
          "student_id": studentId,
          "student_name": studentName,
        };
        _studentRepo.addCourse(data, studentId).then((value) {
          Navigator.pop(navigatorKey.currentContext!);
          getEnrolledCourseList(studentId);
        });
      }
    } catch (e) {
      log(e.toString());
      Navigator.pop(navigatorKey.currentContext!);
      Helper.showSnackBarMessage(msg: e.toString(), isSuccess: false);
    }
  }

  searchStudent({required String searchText}) {
    if (searchText.isEmpty) {
      studentList = copyStudentList;
    } else {
      studentList = copyStudentList
          .where((student) => (student.studentName
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              student.studentPhoneNumber.contains(searchText)))
          .toList();
    }
    notifyListeners();
  }

  Future removeCourse(String courseId) async {
    EnrolledCourseBaseModel enrolledCourseData = enrolledCourseBaseModel!;
    enrolledCourseData.enrolledCourseList
        .removeWhere((element) => element.subjectCode == courseId);
    try {
      if (enrolledCourseData.enrolledCourseList.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('enrolledCourses')
            .doc(enrolledCourseBaseModel?.docId)
            .update(enrolledCourseData.toMap())
            .then((value) {
          Navigator.pop(navigatorKey.currentContext!);
          Helper.showSnackBarMessage(
              msg: "Course removed successfully", isSuccess: false);
        });
      } else {
        await FirebaseFirestore.instance
            .collection('enrolledCourses')
            .doc(enrolledCourseBaseModel!.docId)
            .delete()
            .then((value) {
          Navigator.pop(navigatorKey.currentContext!);
          enrolledCourseBaseModel = null;
          notifyListeners();
        });
      }
    } catch (e) {
      Navigator.pop(navigatorKey.currentContext!);
      Helper.showSnackBarMessage(
          msg: "Sorry something went wrong", isSuccess: false);
    }
  }

  setEditedUnitList(String subjectCode) async {
    LoaderDialogs.showLoadingDialog();
    selectedEditUnitList.clear();
    selectedSubjectModel = null;
    selectedSubjectModel = enrolledCourseBaseModel!.enrolledCourseList
        .where((element) => element.subjectCode == subjectCode)
        .first;

    selectedEditUnitList = await _studentRepo
        .getUnitList(subjectCode: subjectCode)
        .whenComplete(() => Navigator.pop(navigatorKey.currentContext!));

    editedUnitList.clear();
    for (int i = 0; i < selectedEditUnitList.length; i++) {
      if (selectedSubjectModel!.unitCodeList
          .contains(selectedEditUnitList[i].code)) {
        editedUnitList.add(selectedEditUnitList[i].code);
      } else {
        editedUnitList.add("");
      }
    }
    notifyListeners();
  }

  updateEditedUnitList() {
    if (editedUnitList.contains("")) {
      for (int i = 0; i < editedUnitList.length; i++) {
        editedUnitList[i] = selectedEditUnitList[i].code;
      }
    } else {
      for (int i = 0; i < editedUnitList.length; i++) {
        editedUnitList[i] = "";
      }
    }
    selectedUnitLength = editedUnitList
        .where(
          (element) => element != "",
        )
        .toList()
        .length;
    notifyListeners();
  }

  updateEditedCheckList(int index) {
    if (editedUnitList[index] == "") {
      editedUnitList[index] = selectedEditUnitList[index].code;
    } else {
      editedUnitList[index] = "";
    }
    selectedEditedUnitListLength = editedUnitList
        .where(
          (element) => element != "",
        )
        .toList()
        .length;
    notifyListeners();
  }

  setEditUnitData(List<UnitModel> unitData) {
    editUnitList = unitData;
    notifyListeners();
  }

  Future updateEditUnitCourse(String courseId) async {
    LoaderDialogs.showLoadingDialog();
    EnrolledCourseBaseModel enrolledCourseData = enrolledCourseBaseModel!;
    int courseIndex = enrolledCourseData.enrolledCourseList
        .indexWhere((element) => element.subjectCode == courseId);
    editedUnitList.removeWhere((element) => element == "");
    enrolledCourseData.enrolledCourseList[courseIndex].unitCodeList =
        editedUnitList;
    try {
      await FirebaseFirestore.instance
          .collection('enrolledCourses')
          .doc(enrolledCourseBaseModel?.docId)
          .update(enrolledCourseData.toMap())
          .then((value) {
        Navigator.pop(navigatorKey.currentContext!);
        Helper.showSnackBarMessage(
            msg: "Course updated successfully", isSuccess: true);
      });
    } catch (e) {
      Navigator.pop(navigatorKey.currentContext!);
      Helper.showSnackBarMessage(
          msg: "Sorry something went wrong", isSuccess: false);
    }
  }

  removeStudent(int index) {
    studentList.removeAt(index);
    notifyListeners();
  }

  clearDeviceCount(int index) {
    studentList[index].deviceCount = 0;

    notifyListeners();
  }

  Future<void> fetchFirstStudentList() async {
    try {
      LoaderDialogs.showLoadingDialog();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(student)
          .orderBy("name", descending: false)
          .limit(limit)
          .get();
      studentList.clear();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        DocumentSnapshot<Map<String, dynamic>> docData =
            querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
        if (i == querySnapshot.docs.length - 1) {
          lastDoc =
              querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
        }
        docList.add(
            querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>);

        studentList.add(Student.fromDocumentSnapshot(docData));
      }

      copyStudentList = studentList;
      notifyListeners();
      Navigator.pop(navigatorKey.currentContext!);
    } catch (e) {
      
      Navigator.pop(navigatorKey.currentContext!);
      Helper.showSnackBarMessage(
          msg: "Error while fetching data", isSuccess: false);
    }
  }

  Future<void> fetchNextStudentList() async {
    try {
      LoaderDialogs.showLoadingDialog();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(student)
          .orderBy("name", descending: false)
          .startAfterDocument(lastDoc)
          .limit(limit)
          .get();

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        DocumentSnapshot<Map<String, dynamic>> docData =
            querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
        if (i == querySnapshot.docs.length - 1) {
          lastDoc =
              querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
        }
        docList.add(
            querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>);
        studentList.add(Student.fromDocumentSnapshot(docData));

        copyStudentList = studentList;
      }
      notifyListeners();
      Navigator.pop(navigatorKey.currentContext!);
    } catch (e) {
      Navigator.pop(navigatorKey.currentContext!);
      Helper.showSnackBarMessage(
          msg: "Error while fetching data", isSuccess: false);
    }
  }

  removeStudentFromLast() {
    int range = (studentList.length % limit);
    if (range == 0) {
      range = limit;
    }
    studentList.removeRange(studentList.length - range, studentList.length);
    docList.removeRange(docList.length - range, docList.length);
    copyStudentList = studentList;
    lastDoc = docList[docList.length - 1];
    notifyListeners();
  }

  getStudentListLength() async {
    AggregateQuerySnapshot countSnapshot =
        await FirebaseFirestore.instance.collection(student).count().get();
    studentListLength = countSnapshot.count ?? 0;

    notifyListeners();
  }
}
