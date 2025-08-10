import 'dart:async';

import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/question/model/question.dart';
import 'package:bbarna/quiz/model/quiz_model.dart';
import 'package:bbarna/quiz/repo/quiz_repo.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuizViewModel with ChangeNotifier {
  final QuizRepo _quizRepo = QuizRepo();
  List<QuizModel> quizList = [];
  List<QuizModel> copyQuizList = [];
  List<Question> questionList = [];
  List<Question> quizQuestionList = [];
  List<String> selectedQuestionCodeList = [];

  Timer? _debounce;
  int limit = 50;
  int quizLength = 0;
  List<QueryDocumentSnapshot> docList = [];
  late DocumentSnapshot<Map<String, dynamic>> lastDoc;
  Future<DocumentReference<Map<String, dynamic>>> addQuiz(
      QuizModel quizModel) async {
    return await _quizRepo.addQuiz(quizModel);
  }

  Future updateQuiz(QuizModel quizModel, String docId) async {
    LoaderDialogs.showLoadingDialog();
    await _quizRepo.updateQuiz(quizModel, docId).whenComplete(() {
      Navigator.pop(navigatorKey.currentContext!);
    });
  }

  Future deleteQuiz(String docId) async {
    await _quizRepo.deleteQuiz(docId).whenComplete(() {
      getQuizListLength();
      Helper.showSnackBarMessage(
          msg: "Quiz deleted successfully", isSuccess: false);
    });
  }

  Future getFirstQuizList() async {
    LoaderDialogs.showLoadingDialog();
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _quizRepo.getFirstQuizList(limit);
    quizList.clear();
    for (int i = 0; i < snapshot.docs.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> docData =
          snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      if (i == snapshot.docs.length - 1) {
        lastDoc = snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      }
      quizList.add(QuizModel.fromDocumentSnapshot(docData));
    }
    copyQuizList = quizList;
    docList.addAll(snapshot.docs);
    Navigator.pop(navigatorKey.currentContext!);
    notifyListeners();
  }

  Future getNextQuizList() async {
    LoaderDialogs.showLoadingDialog();
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _quizRepo.getNextQuizList(limit, lastDoc);
    for (int i = 0; i < snapshot.docs.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> docData =
          snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      if (i == snapshot.docs.length - 1) {
        lastDoc = snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      }
      quizList.add(QuizModel.fromDocumentSnapshot(docData));
    }
    Navigator.pop(navigatorKey.currentContext!);
    copyQuizList = quizList;
    docList.addAll(snapshot.docs);
    notifyListeners();
  }

  fetchQuestionListById(String questionCode) async {
    try {
      LoaderDialogs.showLoadingDialog();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(question)
          .where("question_code", isGreaterThanOrEqualTo: questionCode)
          .where("question_code", isLessThan: '${questionCode}z')
          .get();
      questionList.clear();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        DocumentSnapshot<Map<String, dynamic>> docData =
            querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
        Question question = Question.fromDocumentSnapshot(docData);
        if (!selectedQuestionCodeList
            .contains(question.questionCode.trim())) {
          questionList.add(Question.fromDocumentSnapshot(docData));
        } 
      }
      
      notifyListeners();
      Navigator.pop(navigatorKey.currentContext!);
    } catch (e) {
      Navigator.pop(navigatorKey.currentContext!);
      Helper.showSnackBarMessage(
          msg: "Error while fetching data", isSuccess: false);
    }
  }

  fetchQuizQuestionList(List<String> questionCodeList) async {
    try {
      quizQuestionList.clear();

      LoaderDialogs.showLoadingDialog();
      selectedQuestionCodeList.clear();

      for (int j = 0; j < questionCodeList.length; j += 25) {
        List<String> dummyQuestionCodeList = questionCodeList.sublist(
          j,
          j + 25 > questionCodeList.length ? questionCodeList.length : j + 25,
        );
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection(question)
            .where("question_code", whereIn: dummyQuestionCodeList)
            .get();
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          DocumentSnapshot<Map<String, dynamic>> docData =
              querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
          quizQuestionList.add(Question.fromDocumentSnapshot(docData));
        }
        for (var element in quizQuestionList) {
          element.isSelected = true;
          selectedQuestionCodeList.add(element.questionCode.trim());
        }
        Future.delayed(const Duration(milliseconds: 100));
      }
      notifyListeners();
      Navigator.pop(navigatorKey.currentContext!);
    } catch (e) {
      Navigator.pop(navigatorKey.currentContext!);
      Helper.showSnackBarMessage(
          msg: "Error while fetching data", isSuccess: false);
    }
  }

  clearData() {
    questionList.clear();
    quizQuestionList.clear();
  }

  addNewQuestion(int index) {
    questionList[index].isSelected = !questionList[index].isSelected;
    notifyListeners();
  }

  updateOldQuestion(int index) {
    quizQuestionList[index].isSelected = !quizQuestionList[index].isSelected;
    notifyListeners();
  }

  searchQuiz({required String searchText}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (searchText.isEmpty) {
        quizList = copyQuizList;
        notifyListeners();
      } else {
        try {
          //  LoaderDialogs.showLoadingDialog();
          quizList = await _quizRepo.searchQuiz(searchText);
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

  removeQuizFromLast() {
    int exesData = docList.length % limit;
    if (exesData > 0) {
      docList.removeRange((docList.length - exesData), docList.length);
      quizList.removeRange((docList.length - exesData), docList.length);
      lastDoc = docList.last as DocumentSnapshot<Map<String, dynamic>>;
      copyQuizList = quizList;
    } else {
      if ((docList.length - limit) >= limit) {
        docList.removeRange(docList.length - limit, docList.length);
        quizList.removeRange(quizList.length - limit, quizList.length);
        lastDoc = docList.last as DocumentSnapshot<Map<String, dynamic>>;
        copyQuizList = quizList;
      }
    }

    notifyListeners();
  }

  getQuizListLength() async {
    quizLength = await _quizRepo.getQuizListLength();
    notifyListeners();
  }

  selectAllQuestion(bool isSelect) {
    if (isSelect) {
      for (int i = 0; i < questionList.length; i++) {
        questionList[i].isSelected = true;
      }
    } else {
      for (int i = 0; i < questionList.length; i++) {
        questionList[i].isSelected = false;
      }
    }
    notifyListeners();
  }
}
