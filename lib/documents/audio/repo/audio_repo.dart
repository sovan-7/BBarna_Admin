import 'dart:typed_data';

import 'package:bbarna/documents/audio/model/audio_model.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AudioRepo {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();

  Future<DocumentReference<Map<String, dynamic>>> addAudio(
      AudioModel audioModel) async {
    return await _fireStore.collection(audio).add(audioModel.toMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFirstAudioList(
      int limit) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(audio)
        .orderBy("timeStamp", descending: true)
        .limit(limit)
        .get();
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getNextAudioList(
      int limit, lastDoc) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(audio)
        .orderBy("timeStamp", descending: true)
        .startAfterDocument(lastDoc)
        .limit(limit)
        .get();
    return snapshot;
  }

  Future updateAudio(AudioModel audioModel, String docId) async {
    await _fireStore.collection(audio).doc(docId).update(audioModel.toMap());
  }

  Future deleteAudio(String docId) async {
    await _fireStore.collection(audio).doc(docId).delete();
  }
  
 Future<void> uploadAudio(String audioCode, Uint8List audioData, String docId) async {
  try {
    Reference audioDirReference = storageReference.child(audio);
    Reference audioReference = audioDirReference.child("audio_$audioCode");
    final metadata = SettableMetadata(contentType: 'audio/mpeg'); 
    await audioReference.putData(audioData, metadata);
        String audioUrl = await audioReference.getDownloadURL();
        await FirebaseFirestore.instance
        .collection(audio)
        .doc(docId) 
        .update({"audio_link": audioUrl});
    
       
  } catch (e) {
   Helper.showSnackBarMessage(
          msg: "Error while uploading pdf", isSuccess: false);
  }
}
Future<int> getAudioListLength() async {
    AggregateQuerySnapshot countSnapshot =
        await _fireStore.collection(audio).count().get();
    return countSnapshot.count ?? 0;
  }

  Future<List<AudioModel>> searchPdf(String searchText) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _fireStore
        .collection(audio)
        .where("audio_code", isGreaterThanOrEqualTo: searchText)
        .where("audio_code", isLessThan: '${searchText}z')
        .get();
    return snapshot.docs
        .map((docSnapshot) => AudioModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
