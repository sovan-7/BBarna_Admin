import 'dart:async';

import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/documents/video/model/video_model.dart';
import 'package:bbarna/documents/video/repo/video_repo.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VideoViewModel with ChangeNotifier {
  final VideoRepo _videoRepo = VideoRepo();
  List<VideoModel> videoList = [];
  List<VideoModel> copyVideoList = [];
  Timer? _debounce;
  int limit = 50;
  int videoListLength = 0;
  List<QueryDocumentSnapshot> docList = [];
  late DocumentSnapshot<Map<String, dynamic>> lastDoc;
  Future<DocumentReference<Map<String, dynamic>>> addVideo(
      VideoModel videoModel) async {
    return await _videoRepo.addVideo(videoModel);
  }

  Future updateVideo(VideoModel videoModel, String docId) async {
    LoaderDialogs.showLoadingDialog();

    await _videoRepo.updateVideo(videoModel, docId).whenComplete(() {
      Navigator.pop(navigatorKey.currentContext!);
    });
  }

  Future deleteVideo(String docId) async {
    await _videoRepo.deleteVideo(docId).whenComplete(() {
      Helper.showSnackBarMessage(
          msg: "Video deleted successfully", isSuccess: false);
      getVideoListLength();
    });
  }

  Future getFirstVideoList() async {
    LoaderDialogs.showLoadingDialog();
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _videoRepo.getFirstVideoList(limit);
    videoList.clear();
    for (int i = 0; i < snapshot.docs.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> docData =
          snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      if (i == snapshot.docs.length - 1) {
        lastDoc = snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      }
      videoList.add(VideoModel.fromDocumentSnapshot(docData));
    }
    copyVideoList = videoList;
    docList.addAll(snapshot.docs);
    Navigator.pop(navigatorKey.currentContext!);
    notifyListeners();
  }

  Future getNextVideoList() async {
    LoaderDialogs.showLoadingDialog();

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _videoRepo.getNextVideoList(limit, lastDoc);
    for (int i = 0; i < snapshot.docs.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> docData =
          snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      if (i == snapshot.docs.length - 1) {
        lastDoc = snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      }
      videoList.add(VideoModel.fromDocumentSnapshot(docData));
    }
    Navigator.pop(navigatorKey.currentContext!);
    copyVideoList = videoList;
    docList.addAll(snapshot.docs);
    notifyListeners();
  }

  searchVideo({required String searchText}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (searchText.isEmpty) {
        videoList = copyVideoList;
        notifyListeners();
      } else {
        try {
          //  LoaderDialogs.showLoadingDialog();
          videoList = await _videoRepo.searchVideo(searchText);
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
      videoList.removeRange((docList.length - exesData), docList.length);
      lastDoc = docList.last as DocumentSnapshot<Map<String, dynamic>>;
      copyVideoList = videoList;
    } else {
      if ((docList.length - limit) >= limit) {
        docList.removeRange(docList.length - limit, docList.length);
        videoList.removeRange(videoList.length - limit, videoList.length);
        lastDoc = docList.last as DocumentSnapshot<Map<String, dynamic>>;
        copyVideoList = videoList;
      }
    }
    notifyListeners();
  }

  getVideoListLength() async {
    videoListLength = await _videoRepo.getVideoListLength();
    notifyListeners();
  }
}
