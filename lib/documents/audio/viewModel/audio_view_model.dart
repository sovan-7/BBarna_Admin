import 'dart:async';
import 'dart:typed_data';

import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/documents/audio/model/audio_model.dart';
import 'package:bbarna/documents/audio/repo/audio_repo.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AudioViewModel with ChangeNotifier {
  final AudioRepo _audioRepo = AudioRepo();
  List<AudioModel> audioList = [];
  List<AudioModel> copyAudioList = [];
  Timer? _debounce;
  int limit = 50;
  int audioListLength = 0;
  List<QueryDocumentSnapshot> docList = [];
  late DocumentSnapshot<Map<String, dynamic>> lastDoc;

  Future<DocumentReference<Map<String, dynamic>>> addAudio(
      AudioModel audioModel) async {
    return await _audioRepo.addAudio(audioModel);
  }

  Future uploadAudio(Uint8List audio, String audioCode, String docId) async {
    await _audioRepo.uploadAudio(audioCode, audio, docId);
  }

  Future updateAudio(AudioModel audioModel, String docId) async {
    await _audioRepo.updateAudio(audioModel, docId);
  }

  Future deleteAudio(String docId) async {
    LoaderDialogs.showLoadingDialog();
    try {
      await _audioRepo.deleteAudio(docId).whenComplete(() {
        Navigator.pop(navigatorKey.currentContext!);
        Helper.showSnackBarMessage(
            msg: "Audio deleted successfully", isSuccess: false);
      });
    } catch (e) {
      Navigator.pop(navigatorKey.currentContext!);
    }
  }

  clearAudioList() {
    audioList.clear();
    copyAudioList.clear();
    notifyListeners();
  }

  Future getFirstAudioList() async {
    LoaderDialogs.showLoadingDialog();
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _audioRepo.getFirstAudioList(limit);
    audioList.clear();
    for (int i = 0; i < snapshot.docs.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> docData =
          snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      if (i == snapshot.docs.length - 1) {
        lastDoc = snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      }
      audioList.add(AudioModel.fromDocumentSnapshot(docData));
    }
    copyAudioList = audioList;
    docList.addAll(snapshot.docs);
    Navigator.pop(navigatorKey.currentContext!);
    notifyListeners();
  }

  Future getNextAudioList() async {
    LoaderDialogs.showLoadingDialog();

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _audioRepo.getNextAudioList(limit, lastDoc);
    for (int i = 0; i < snapshot.docs.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> docData =
          snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      if (i == snapshot.docs.length - 1) {
        lastDoc = snapshot.docs[i] as DocumentSnapshot<Map<String, dynamic>>;
      }
      audioList.add(AudioModel.fromDocumentSnapshot(docData));
    }
    Navigator.pop(navigatorKey.currentContext!);
    copyAudioList = audioList;
    docList.addAll(snapshot.docs);
    notifyListeners();
  }

  searchAudio({required String searchText}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (searchText.isEmpty) {
        audioList = copyAudioList;
        notifyListeners();
      } else {
        try {
          //  LoaderDialogs.showLoadingDialog();
          audioList = await _audioRepo.searchPdf(searchText);
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

  removeAudioFromLast() {
    int exesData = docList.length % limit;
    if (exesData > 0) {
      docList.removeRange((docList.length - exesData), docList.length);
      audioList.removeRange((docList.length - exesData), docList.length);
      lastDoc = docList.last as DocumentSnapshot<Map<String, dynamic>>;
      copyAudioList = audioList;
    } else {
      if ((docList.length - limit) >= limit) {
        docList.removeRange(docList.length - limit, docList.length);
        audioList.removeRange(audioList.length - limit, audioList.length);
        lastDoc = docList.last as DocumentSnapshot<Map<String, dynamic>>;
        copyAudioList = audioList;
      }
    }
    notifyListeners();
  }

  getAudioListLength() async {
    audioListLength = await _audioRepo.getAudioListLength();
    notifyListeners();
  }

  clearData() {
    audioList.clear();
    copyAudioList.clear();
    notifyListeners();
  }
}
