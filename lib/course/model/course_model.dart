import 'package:bbarna/resources/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  String docId = stringDefault;
  String code = stringDefault;
  int timeStamp = intDefault;
  String description = stringDefault;
  String name = stringDefault;
  String image = stringDefault;
  int displayPriority = intDefault;
  bool willDisplay = boolDefault;
  bool isLocked = boolDefault;

  CourseModel(
      this.code,
      this.description,
      this.name,
      this.image,
      this.displayPriority,
      this.timeStamp,
      this.willDisplay,
      this.isLocked);

  Map<String, dynamic> toMap() {
    return {
      "course_code": code.trim(),
      "course_description": description,
      "course_name": name,
      "timeStamp": timeStamp,
      "course_image": image,
      "display_priority": displayPriority,
      "willDisplay": willDisplay,
      "isLocked": isLocked
    };
  }

  CourseModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : docId = doc.id,
        code = doc.data()!["course_code"] ?? stringDefault,
        description = doc.data()!["course_description"] ?? stringDefault,
        name = doc.data()!["course_name"] ?? stringDefault,
        image = doc.data()!["course_image"] ?? stringDefault,
        displayPriority = doc.data()!["display_priority"] ?? intDefault,
        timeStamp = doc.data()!["timeStamp"] ?? intDefault,
        willDisplay = doc.data()!["willDisplay"] ?? boolDefault,
        isLocked = doc.data()!["isLocked"] ?? boolDefault;
}
