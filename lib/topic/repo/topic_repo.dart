
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/subject/model/subject_model.dart';
import 'package:bbarna/topic/model/topic_model.dart';
import 'package:bbarna/units/model/unit_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TopicRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future<DocumentReference<Map<String, dynamic>>> addTopic(
      TopicModel topicModel) async {
    return await _fireStore.collection(topic).add(topicModel.toMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFirstTopicList(
      int limit) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(topic)
        .orderBy("timeStamp", descending: true)
        .limit(limit)
        .get();
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getNextTopicList(
      int limit, lastDoc) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(topic)
        .orderBy("timeStamp", descending: true)
        .startAfterDocument(lastDoc)
        .limit(limit)
        .get();
    return snapshot;
  }

  

  Future updateTopic(TopicModel topicModel, String docId) async {
    await _fireStore.collection(topic).doc(docId).update(topicModel.toMap());
  }

  Future deleteTopic(String docId) async {
    await _fireStore.collection(topic).doc(docId).delete();
  }

  Future<List<SubjectModel>> getSubjectList(
      {required String courseCode}) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(subject)
        .where("course_code", isEqualTo: courseCode)
        .get();
    return snapshot.docs
        .map((docSnapshot) => SubjectModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<UnitModel>> getUnitList({required String subjectCode}) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(unit)
        .where("subject_code", isEqualTo: subjectCode)
        .get();
    return snapshot.docs
        .map((docSnapshot) => UnitModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<int> getTopicListLength() async {
    AggregateQuerySnapshot countSnapshot =
        await _fireStore.collection(topic).count().get();
    return countSnapshot.count ?? 0;
  }

  Future<List<TopicModel>> searchTopic(String searchText) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(topic)
        .where("topic_code", isGreaterThanOrEqualTo: searchText)
        .where("topic_code", isLessThan: '${searchText}z')
        .get();
    return snapshot.docs
        .map((docSnapshot) => TopicModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
