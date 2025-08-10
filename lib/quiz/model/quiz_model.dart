import 'package:bbarna/resources/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  String docId = stringDefault;
  String code = stringDefault;
  int timeStamp = intDefault;
  String name = stringDefault;
  String status = stringDefault;
  String type = stringDefault;
  int totalTime = intDefault;
  int totalMarks = intDefault;
  int numberDeduction = intDefault;
  int totalWrongAnswer = intDefault;
  int totalQuestion = intDefault;
  List<String> questionCodeList = [];

  QuizModel(
      this.code,
      this.name,
      this.status,
      this.type,
      this.totalTime,
      this.timeStamp,
      this.totalMarks,
      this.numberDeduction,
      this.totalWrongAnswer,
      this.totalQuestion,
      this.questionCodeList);

  Map<String, dynamic> toMap() {
    return {
      "quiz_code": code.trim(),
      "quiz_name": name,
      "timeStamp": timeStamp,
      "quiz_status": status,
      "quiz_type": type,
      "total_time": totalTime,
      "total_marks": totalMarks,
      "number_deduction": numberDeduction,
      "total_wrong_answer": totalWrongAnswer,
      "total_question": totalQuestion,
      "question_code_list": questionCodeList
    };
  }

  QuizModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : docId = doc.id,
        code = doc.data()!["quiz_code"] ?? stringDefault,
        name = doc.data()!["quiz_name"] ?? stringDefault,
        type = doc.data()!["quiz_type"] ?? stringDefault,
        status = doc.data()!["quiz_status"] ?? stringDefault,
        totalTime = doc.data()!["total_time"] ?? stringDefault,
        totalMarks = doc.data()!["total_marks"] ?? stringDefault,
        numberDeduction = doc.data()!["number_deduction"] ?? stringDefault,
        timeStamp = doc.data()!["timeStamp"] ?? intDefault,
        totalWrongAnswer = doc.data()!["total_wrong_answer"] ?? intDefault,
        totalQuestion = doc.data()!["total_question"] ?? intDefault,
        questionCodeList=doc.data()!["question_code_list"]==null?[]:List<String>.from(doc.data()!["question_code_list"].map((x)=>x));
}
