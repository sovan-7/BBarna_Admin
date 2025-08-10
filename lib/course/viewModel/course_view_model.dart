import 'dart:typed_data';

import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/course/model/course_model.dart';
import 'package:bbarna/course/repo/course_repo.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CourseViewModel with ChangeNotifier {
  final CourseRepo _courseRepo = CourseRepo();
  List<CourseModel> courseList = [];
  List<CourseModel> copyCourseList = [];

  Future<DocumentReference<Map<String, dynamic>>> addCourse(
      CourseModel courseModel) async {
    return await _courseRepo.addCourse(courseModel);
  }

  Future updateCourse(CourseModel courseModel, String courseId) async {
    LoaderDialogs.showLoadingDialog();

    await _courseRepo.updateCourse(courseModel, courseId).whenComplete(() {
      Navigator.pop(navigatorKey.currentContext!);
    });
  }

  Future deleteCourse(String courseId) async {
    await _courseRepo.deleteCourse(courseId).whenComplete(() {
      Helper.showSnackBarMessage(
          msg: "Course deleted successfully", isSuccess: false);
    });
  }

  Future uploadCourseImage(
      Uint8List image, String courseCode, String courseId) async {
    await _courseRepo.uploadCourseImage(image, courseCode, courseId);
  }

  Future getCourseList() async {
    LoaderDialogs.showLoadingDialog();
    courseList = await _courseRepo
        .getCourseList()
        .whenComplete(() => Navigator.pop(navigatorKey.currentContext!));
    copyCourseList = courseList;
    if (courseList.isNotEmpty) {
      filterCourse();
    }
    notifyListeners();
  }

  searchCourse({required String searchText}) {
    if (searchText.isEmpty) {
      courseList = copyCourseList;
    } else {
      courseList = copyCourseList
          .where((course) =>
              (course.code.toLowerCase().contains(searchText.toLowerCase())) ||
              (course.name.toLowerCase().contains(searchText.toLowerCase())))
          .toList();
    }
    notifyListeners();
  }

  filterCourse() {
    courseList.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
  }
}
