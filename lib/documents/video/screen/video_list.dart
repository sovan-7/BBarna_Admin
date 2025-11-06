import 'package:bbarna/documents/video/viewModel/video_view_model.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/core/widgets/add_widget.dart';
import 'package:bbarna/core/widgets/custom_searchbar.dart';
import 'package:bbarna/utils/size_config.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/documents/video/screen/add_video.dart';
import 'package:bbarna/documents/video/widgets/video_list_widget.dart';
import 'package:provider/provider.dart';

class VideoList extends StatefulWidget {
  const VideoList({super.key});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    VideoViewModel videoViewModel =
        Provider.of<VideoViewModel>(context, listen: false);
    videoViewModel.getFirstVideoList();
    videoViewModel.getVideoListLength();
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
      child: Consumer<VideoViewModel>(
          builder: (context, videoDataProvider, child) {
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
                      "VIDEO LIST",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.0,
                          color: AppColorsInApp.colorBlack1),
                    ),
                  ],
                ),
                AddWidget(
                  addCall: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddVideo()))
                        .whenComplete(() {
                      if (searchController.text.isEmpty) {
                        VideoViewModel videoViewModel =
                            Provider.of<VideoViewModel>(context, listen: false);
                        videoViewModel.getFirstVideoList();
                        videoViewModel.getVideoListLength();
                      }
                    });
                  },
                )
              ],
            ),
            CustomSearchBar(
              textEditingController: searchController,
              onChange: () {
                videoDataProvider.searchVideo(
                    searchText: searchController.text.toUpperCase());
              },
              onClear: () {
                searchController.clear();
                videoDataProvider.searchVideo(
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
                      color: AppColorsInApp.colorGrey.withValues(alpha: .2)),
                  child: ListView.builder(
                      itemCount: videoDataProvider.videoList.length,
                      itemBuilder: (context, index) {
                        return SizeConfig.screenWidth! < 900
                            ? FittedBox(
                                child: VideoListWidget(
                                videoData: videoDataProvider.videoList[index],
                                onEdit: () {
                                  if (searchController.text.isEmpty) {
                                    videoDataProvider.getFirstVideoList();
                                  }
                                },
                              ))
                            : VideoListWidget(
                                videoData: videoDataProvider.videoList[index],
                                onEdit: () {
                                  if (searchController.text.isEmpty) {
                                    videoDataProvider.getFirstVideoList();
                                  }
                                },
                              );
                      })),
            ),
            if (videoDataProvider.videoListLength != 0 &&
                searchController.text.isEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      searchController.clear();
                      if (videoDataProvider.videoList.length >
                          videoDataProvider.limit) {
                        videoDataProvider.removeQuizFromLast();
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
                      "${videoDataProvider.videoList.length}/${videoDataProvider.videoListLength}",
                      style: const TextStyle(
                          color: AppColorsInApp.colorBlack1,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      searchController.clear();
                      if (videoDataProvider.videoListLength >
                          videoDataProvider.videoList.length) {
                        videoDataProvider.getNextVideoList();
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
      }),
    );
  }
}
