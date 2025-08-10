import 'package:bbarna/resources/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String docId = stringDefault;
  String code = stringDefault;
  int timeStamp = intDefault;
  String title = stringDefault;
  String description = stringDefault;
  String link = stringDefault;
  String videoType = stringDefault;

  VideoModel(
    this.code,
    this.description,
    this.title,
    this.link,
    this.videoType,
    this.timeStamp,
  );

  Map<String, dynamic> toMap() {
    return {
      "video_code": code.trim(),
      "video_description": description,
      "video_title": title,
      "timeStamp": timeStamp,
      "video_link": link,
      "video_type": videoType,
    };
  }

  VideoModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : docId = doc.id,
        code = doc.data()!["video_code"] ?? stringDefault,
        description = doc.data()!["video_description"] ?? stringDefault,
        title = doc.data()!["video_title"] ?? stringDefault,
        link = doc.data()!["video_link"] ?? stringDefault,
        videoType = doc.data()!["video_type"] ?? stringDefault,
        timeStamp = doc.data()!["timeStamp"] ?? intDefault;
}
