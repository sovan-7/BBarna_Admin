import 'package:bbarna/documents/video/model/video_model.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/subject/model/subject_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VideoRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future<DocumentReference<Map<String, dynamic>>> addVideo(
      VideoModel videoModel) async {
    return await _fireStore.collection(video).add(videoModel.toMap());
  }

   Future<QuerySnapshot<Map<String, dynamic>>> getFirstVideoList(
      int limit) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(video)
        .orderBy("timeStamp", descending: true)
        .limit(limit)
        .get();
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getNextVideoList(
      int limit, lastDoc) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(video)
        .orderBy("timeStamp", descending: true)
        .startAfterDocument(lastDoc)
        .limit(limit)
        .get();
    return snapshot;
  }


  Future updateVideo(VideoModel videoModel, String docId) async {
    await _fireStore.collection(video).doc(docId).update(videoModel.toMap());
  }

  Future deleteVideo(String docId) async {
    await _fireStore.collection(video).doc(docId).delete();
  }
  Future<List<SubjectModel>> getSubjectList({required String courseCode}) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _fireStore.collection(subject).where("course_code", isEqualTo:courseCode).get();
    return snapshot.docs
        .map((docSnapshot) => SubjectModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
  
 Future<int> getVideoListLength() async {
    AggregateQuerySnapshot countSnapshot =
        await _fireStore.collection(video).count().get();
    return countSnapshot.count ?? 0;
  }

  Future<List<VideoModel>> searchVideo(String searchText) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(video)
        .where("video_code", isGreaterThanOrEqualTo: searchText)
        .where("video_code", isLessThan: '${searchText}z')
        .get();
    return snapshot.docs
        .map((docSnapshot) => VideoModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
