import 'package:bbarna/quiz/model/quiz_model.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class QuizRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future<DocumentReference<Map<String, dynamic>>> addQuiz(
      QuizModel quizModel) async {
    return await _fireStore.collection(quiz).add(quizModel.toMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFirstQuizList(
      int limit) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(quiz)
        .orderBy("timeStamp", descending: true)
        .limit(limit)
        .get();
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getNextQuizList(
      int limit, lastDoc) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(quiz)
        .orderBy("timeStamp", descending: true)
        .startAfterDocument(lastDoc)
        .limit(limit)
        .get();
    return snapshot;
  }

  Future updateQuiz(QuizModel quizModel, String docId) async {
    await _fireStore.collection(quiz).doc(docId).update(quizModel.toMap());
  }

  Future deleteQuiz(String docId) async {
    await _fireStore.collection(quiz).doc(docId).delete();
  }
   Future<int> getQuizListLength() async {
    AggregateQuerySnapshot countSnapshot =
        await _fireStore.collection(quiz).count().get();
    return countSnapshot.count ?? 0;
  }

  Future<List<QuizModel>> searchQuiz(String searchText) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(quiz)
        .where("quiz_code", isGreaterThanOrEqualTo: searchText)
        .where("quiz_code", isLessThan: '${searchText}z')
        .get();
    return snapshot.docs
        .map((docSnapshot) => QuizModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
