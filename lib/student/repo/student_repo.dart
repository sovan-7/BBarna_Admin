import 'package:bbarna/course/model/course_model.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/student/model/enrolled_course_model.dart';
import 'package:bbarna/student/model/student_model.dart';
import 'package:bbarna/subject/model/subject_model.dart';
import 'package:bbarna/units/model/unit_model.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Student>> getStudentList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection(student).get();
    return snapshot.docs
        .map((docSnapshot) => Student.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<CourseModel>> getCourseList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection(course).get();
    return snapshot.docs
        .map((docSnapshot) => CourseModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<SubjectModel>> getSubjectList(String courseId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection(subject)
        .where("course_code", isEqualTo: courseId)
        .get();
    return snapshot.docs
        .map((docSnapshot) => SubjectModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<UnitModel>> getUnitList({required String subjectCode}) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection(unit)
        .where("subject_code", isEqualTo: subjectCode)
        .get();
    return snapshot.docs
        .map((docSnapshot) => UnitModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<EnrolledCourseBaseModel> getEnrolledCourseList(
      String studentId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection(enrolledCourse)
        .where("student_id", isEqualTo: studentId)
        .get();

    return EnrolledCourseBaseModel.fromDocumentSnapshot(snapshot.docs.first);
  }

  Future addCourse(Map<String, dynamic> newCourse, String studentId) async {
    try {
      CollectionReference studentsRef =
          FirebaseFirestore.instance.collection(enrolledCourse);
      // Query the document where student_id matches
      QuerySnapshot querySnapshot =
          await studentsRef.where('student_id', isEqualTo: studentId).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming student_id is unique and you fetch only one document
        DocumentSnapshot studentDoc = querySnapshot.docs.first;

        // Update the course_list array with the new course
        await studentDoc.reference.update({
          'course_list': FieldValue.arrayUnion([newCourse]),
        });
      } else {
        studentsRef.add(newCourse);
      }
    } catch (e) {
      Helper.showSnackBarMessage(
          msg: "Error while fetching data", isSuccess: false);
    }
  }
}
