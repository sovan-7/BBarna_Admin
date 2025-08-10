import 'dart:async';
import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:bbarna/question/model/question.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:html_editor_enhanced/html_editor.dart';
// import 'package:html_editor_enhanced/html_editor.dart';

class QuestionViewModel extends ChangeNotifier {
  List<Question> questionList = [];
  List<Question> copyQuestionList = [];
  int selectIndex = -1;
  int questionListLength = 0;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  TextEditingController questionCodeController = TextEditingController();
  HtmlEditorController questionController = HtmlEditorController();
  HtmlEditorController solutionController = HtmlEditorController();
  HtmlEditorController optionOneController = HtmlEditorController();
  HtmlEditorController optionTwoController = HtmlEditorController();
  HtmlEditorController optionThreeController = HtmlEditorController();
  HtmlEditorController optionFourController = HtmlEditorController();
  HtmlEditorController questionBodyController = HtmlEditorController();
  HtmlEditorController hintController = HtmlEditorController();
  late DocumentSnapshot<Map<String, dynamic>> lastDoc;
  List<DocumentSnapshot<Map<String, dynamic>>> docList = [];

  Timer? _debounce;

  int limit = 50;
  Future<void> fetchFirstQuestionList() async {
    try {
      docList.clear();
      LoaderDialogs.showLoadingDialog();
      QuerySnapshot querySnapshot = await _fireStore
          .collection(question)
          .orderBy("timeStamp", descending: true)
          .limit(limit)
          .get();
      questionList.clear();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        DocumentSnapshot<Map<String, dynamic>> docData =
            querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
        if (i == querySnapshot.docs.length - 1) {
          lastDoc =
              querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
        }
        docList.add(
            querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>);
        questionList.add(Question.fromDocumentSnapshot(docData));
      }
      copyQuestionList = questionList;
      notifyListeners();
      Navigator.pop(navigatorKey.currentContext!);
    } catch (e) {
      Navigator.pop(navigatorKey.currentContext!);
      Helper.showSnackBarMessage(
          msg: "Error while fetching data", isSuccess: false);
    }
  }

  Future<void> deleteQuestion(
      {required String documentId, required int questionIndex}) async {
    try {
      DocumentReference documentReference =
          _fireStore.collection(question).doc(documentId);
      await documentReference.delete();
      questionList.removeAt(questionIndex);
      getQuestionListLength();
      Helper.showSnackBarMessage(
          msg: "Question deleted successfully", isSuccess: false);
    } catch (e) {
      Helper.showSnackBarMessage(msg: "Error while deleting", isSuccess: false);
    }
    notifyListeners();
  }

  setControllerData({required Question question}) async {
    questionCodeController.text = question.questionCode;
    questionController.setText(question.question);
    questionBodyController.setText(question.questionBody);
    solutionController.setText(question.solution);
    optionOneController.setText(question.option1);
    optionTwoController.setText(question.option2);
    optionThreeController.setText(question.option3);
    optionFourController.setText(question.option4);
    hintController.setText(question.hints);
    selectIndex = await getSelectedOption(question.answer, question);
    notifyListeners();
  }

  clearControllerData() {
    questionCodeController.clear();
    questionController.clear();
    questionBodyController.clear();
    optionOneController.clear();
    optionTwoController.clear();
    optionThreeController.clear();
    optionFourController.clear();
    hintController.clear();
    solutionController.clear();
    selectIndex = -1;
  }

  Future<int> getSelectedOption(String answer, Question question) async {
    int option = -1;

    if (question.option1 == answer) {
      option = 1;
    } else if (question.option2 == answer) {
      option = 2;
    } else if (question.option3 == answer) {
      option = 3;
    } else {
      option = 4;
    }

    return option;
  }

  setSelectedIndex(int index) {
    selectIndex = index;
    notifyListeners();
  }

  getQuestionListLength() async {
    AggregateQuerySnapshot countSnapshot =
        await _fireStore.collection(question).count().get();
    questionListLength = countSnapshot.count ?? 0;

    notifyListeners();
  }

  Future<void> fetchNextQuestionList() async {
    try {
      LoaderDialogs.showLoadingDialog();
      QuerySnapshot querySnapshot = await _fireStore
          .collection(question)
          .orderBy("timeStamp", descending: true)
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
        questionList.add(Question.fromDocumentSnapshot(docData));

        copyQuestionList = questionList;
      }
      notifyListeners();
      Navigator.pop(navigatorKey.currentContext!);
    } catch (e) {
      Navigator.pop(navigatorKey.currentContext!);
      Helper.showSnackBarMessage(
          msg: "Error while fetching data", isSuccess: false);
    }
  }

  removeQuestionFromLast() {
    int range = (questionList.length % limit);
    if (range == 0) {
      range = limit;
    }
    questionList.removeRange(questionList.length - range, questionList.length);
    docList.removeRange(docList.length - range, docList.length);
    copyQuestionList = questionList;
    notifyListeners();
  }

  searchQuestion({required String searchText}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (searchText.isEmpty) {
        fetchFirstQuestionList();
      } else {
        try {
          //  LoaderDialogs.showLoadingDialog();
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection(question)
              .where("question_code", isGreaterThanOrEqualTo: searchText)
              .where("question_code", isLessThan: '${searchText}z')
              .get();
          List<Question> dummyQuestionList = [];
          for (int i = 0; i < querySnapshot.docs.length; i++) {
            DocumentSnapshot<Map<String, dynamic>> docData =
                querySnapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
            dummyQuestionList.add(Question.fromDocumentSnapshot(docData));
          }
          questionList = dummyQuestionList;
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
}
