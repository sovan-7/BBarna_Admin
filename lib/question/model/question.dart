import 'package:bbarna/resources/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  Question(
      {this.docId = "",
      this.questionCode = "",
      this.question = "",
      this.questionBody = "",
      this.hints = "",
      this.solution = "",
      this.answer = "",
      this.option1 = "",
      this.option2 = "",
      this.option3 = "",
      this.option4 = "",
      this.timeStamp = -1,
      this.isSelected=false});
  String docId = stringDefault;
  String questionCode = stringDefault;
  String question = stringDefault;
  String questionBody = stringDefault;
  String hints = stringDefault;
  String solution = stringDefault;
  String answer = stringDefault;
  String option1 = stringDefault;
  String option2 = stringDefault;
  String option3 = stringDefault;
  String option4 = stringDefault;
  int timeStamp = intDefault;
  bool isSelected = false;
  factory Question.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return Question(
      docId: doc.id,
      questionCode: doc.data()!['question_code'] ?? stringDefault,
      question: doc.data()!['question'] ?? stringDefault,
      questionBody: doc.data()!['question_body'] ?? stringDefault,
      hints: doc.data()!['hints'] ?? stringDefault,
      solution: doc.data()!['solution'] ?? stringDefault,
      answer: doc.data()!['answer'] ?? stringDefault,
      option1: doc.data()!['option1'] ?? stringDefault,
      option2: doc.data()!['option2'] ?? stringDefault,
      option3: doc.data()!['option3'] ?? stringDefault,
      option4: doc.data()!['option4'] ?? stringDefault,
      timeStamp: doc.data()!['timeStamp'] ?? intDefault,
      isSelected: false
    );
  }
}
