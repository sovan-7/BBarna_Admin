import 'dart:async';
import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/subject/model/subject_model.dart';
import 'package:bbarna/topic/model/topic_model.dart';
import 'package:bbarna/topic/repo/topic_repo.dart';
import 'package:bbarna/units/model/unit_model.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TopicViewModel with ChangeNotifier {
  final TopicRepo _topicRepo = TopicRepo();
  List<TopicModel> topicList = [];
  List<TopicModel> copyTopicList = [];
  List<SubjectModel> subjectList = [];
  List<UnitModel> unitList = [];
  Timer? _debounce;
  int limit = 50;
  int topicLength = 0;
  List<QueryDocumentSnapshot> docList = [];
  late DocumentSnapshot<Map<String, dynamic>> lastDoc;
  Future<DocumentReference<Map<String, dynamic>>> addTopic(
      TopicModel topicModel) async {
    return await _topicRepo.addTopic(topicModel);
  }

  Future updateTopic(TopicModel topicModel, String docId) async {
    LoaderDialogs.showLoadingDialog();

    await _topicRepo.updateTopic(topicModel, docId).whenComplete(() {
      Navigator.pop(navigatorKey.currentContext!);
    });
  }

  Future deleteTopic(String docId) async {
    topicList.removeWhere((element) => element.docId == docId);
    await _topicRepo.deleteTopic(docId).whenComplete(() {
      Helper.showSnackBarMessage(
          msg: "Topic deleted successfully", isSuccess: false);
    });
    getTopicListLength();
  }

  Future getFirstTopicList() async {
    LoaderDialogs.showLoadingDialog();
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _topicRepo.getFirstTopicList(limit);
    topicList.clear();
    for (int i = 0; i < snapshot.docs.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> docData =
          snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      if (i == snapshot.docs.length - 1) {
        lastDoc = snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      }
      topicList.add(TopicModel.fromDocumentSnapshot(docData));
    }
    copyTopicList = topicList;
    docList.addAll(snapshot.docs);
    Navigator.pop(navigatorKey.currentContext!);
    notifyListeners();
  }

  Future getNextTopicList() async {
    LoaderDialogs.showLoadingDialog();

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _topicRepo.getNextTopicList(limit, lastDoc);
    for (int i = 0; i < snapshot.docs.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> docData =
          snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      if (i == snapshot.docs.length - 1) {
        lastDoc = snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      }
      topicList.add(TopicModel.fromDocumentSnapshot(docData));
    }
    Navigator.pop(navigatorKey.currentContext!);
    copyTopicList = topicList;
    docList.addAll(snapshot.docs);
    notifyListeners();
  }

  Future getSubjectList({required String courseCode}) async {
    LoaderDialogs.showLoadingDialog();
    subjectList = await _topicRepo
        .getSubjectList(courseCode: courseCode)
        .whenComplete(() => Navigator.pop(navigatorKey.currentContext!));
    notifyListeners();
  }

  Future getUnitList({required String subjectCode}) async {
    LoaderDialogs.showLoadingDialog();
    unitList = await _topicRepo
        .getUnitList(subjectCode: subjectCode)
        .whenComplete(() => Navigator.pop(navigatorKey.currentContext!));
    notifyListeners();
  }

  searchTopic({required String searchText}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (searchText.isEmpty) {
        topicList = copyTopicList;
        notifyListeners();
      } else {
        try {
          //  LoaderDialogs.showLoadingDialog();
          topicList = await _topicRepo.searchTopic(searchText);
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

  removeTopicFromLast() {
    int exesData = docList.length % limit;
    if (exesData > 0) {
      docList.removeRange((docList.length - exesData), docList.length);
      topicList.removeRange((docList.length - exesData), docList.length);
      lastDoc = docList.last as DocumentSnapshot<Map<String, dynamic>>;
      copyTopicList = topicList;
    } else {
      if ((docList.length - limit) >= limit) {
        docList.removeRange(docList.length - limit, docList.length);
        topicList.removeRange(topicList.length - limit, topicList.length);
        lastDoc = docList.last as DocumentSnapshot<Map<String, dynamic>>;
        copyTopicList = topicList;
      }
    }
    notifyListeners();
  }

  getTopicListLength() async {
    topicLength = await _topicRepo.getTopicListLength();
    notifyListeners();
  }

  Future<bool> isVideoExists(String videoCode) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(video)
          .where('video_code', isEqualTo: videoCode)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
}
