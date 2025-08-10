import 'package:bbarna/documents/audio/viewModel/audio_view_model.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/core/widgets/add_widget.dart';
import 'package:bbarna/core/widgets/custom_searchbar.dart';
import 'package:bbarna/utils/size_config.dart';
import 'package:bbarna/documents/audio/screen/add_audio.dart';
import 'package:bbarna/documents/audio/widgets/audio_list_widget.dart';
import 'package:provider/provider.dart';

class AudioList extends StatefulWidget {
  const AudioList({super.key});

  @override
  State<AudioList> createState() => _AudioListState();
}

class _AudioListState extends State<AudioList> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    AudioViewModel audioViewModel =
        Provider.of<AudioViewModel>(context, listen: false);
    audioViewModel.getFirstAudioList();
    audioViewModel.getAudioListLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double width = SizeConfig.screenWidth!;
    return Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 20,
        ),
        child: Consumer<AudioViewModel>(
            builder: (context, audioDataProvider, child) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "AUDIO LIST",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1.0,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  AddWidget(
                    addCall: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddAudio()))
                          .whenComplete(() {
                        if (searchController.text.isEmpty) {
                          audioDataProvider.getFirstAudioList();
                          audioDataProvider.getAudioListLength();
                        }
                      });
                    },
                  )
                ],
              ),
              CustomSearchBar(
                textEditingController: searchController,
                onChange: () {
                  audioDataProvider.searchAudio(
                      searchText: searchController.text.toUpperCase());
                },
                onClear: () {
                  searchController.clear();
                  audioDataProvider.searchAudio(
                      searchText: searchController.text);
                },
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.2)),
                  child: ListView.builder(
                      itemCount: audioDataProvider.audioList.length,
                      itemBuilder: (context, index) {
                        return SizeConfig.screenWidth! < 900
                            ? FittedBox(
                                child: AudioListWidget(
                                audioData: audioDataProvider.audioList[index],
                                index: index,
                                onEdit: () {
                                  if (searchController.text.isEmpty) {
                                    audioDataProvider.getFirstAudioList();
                                  }
                                },
                              ))
                            : AudioListWidget(
                                audioData: audioDataProvider.audioList[index],
                                index: index,
                                onEdit: () {
                                  if (searchController.text.isEmpty) {
                                    audioDataProvider.getFirstAudioList();
                                  }
                                },
                              );
                      }),
                ),
              ),
              if (audioDataProvider.audioListLength != 0 &&
                  searchController.text.isEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        searchController.clear();
                        if (audioDataProvider.audioList.length >
                            audioDataProvider.limit) {
                          audioDataProvider.removeAudioFromLast();
                        } else {
                          Helper.showSnackBarMessage(
                              msg: "You are already in first page",
                              isSuccess: false);
                        }
                      },
                      child: Container(
                        height: 38,
                        width: 95,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColorsInApp.colorLightBlue,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          "Previous",
                          style: TextStyle(
                              color: AppColorsInApp.colorBlack1,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "${audioDataProvider.audioList.length}/${audioDataProvider.audioListLength}",
                        style: const TextStyle(
                            color: AppColorsInApp.colorBlack1,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        searchController.clear();
                        if (audioDataProvider.audioListLength >
                            audioDataProvider.audioList.length) {
                          audioDataProvider.getNextAudioList();
                        } else {
                          Helper.showSnackBarMessage(
                              msg: "You are already in last page",
                              isSuccess: false);
                        }
                      },
                      child: Container(
                        height: 38,
                        width: 95,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColorsInApp.colorLightBlue,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                              color: AppColorsInApp.colorBlack1,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
            ],
          );
        }));
  }
}
