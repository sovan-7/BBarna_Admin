import 'package:bbarna/resources/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AudioModel {
  String docId = stringDefault;
  String code = stringDefault;
  int timeStamp = intDefault;
  String title = stringDefault;
  String description = stringDefault;
  String link = stringDefault;
  String audioType = stringDefault;

  AudioModel(
    this.code,
    this.description,
    this.title,
    this.link,
    this.audioType,
    this.timeStamp,
  );

  Map<String, dynamic> toMap() {
    return {
      "audio_code": code.trim(),
      "audio_description": description,
      "audio_title": title,
      "timeStamp": timeStamp,
      "audio_link": link,
      "audio_type": audioType,
    };
  }

  AudioModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : docId = doc.id,
        code = doc.data()!["audio_code"] ?? stringDefault,
        description = doc.data()!["audio_description"] ?? stringDefault,
        title = doc.data()!["audio_title"] ?? stringDefault,
        link = doc.data()!["audio_link"] ?? stringDefault,
        audioType = doc.data()!["audio_type"] ?? stringDefault,
        timeStamp = doc.data()!["timeStamp"] ?? intDefault;
}
