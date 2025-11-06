// ignore_for_file: must_be_immutable

import 'package:bbarna/core/widgets/remove_alert.dart';
import 'package:bbarna/documents/video/model/video_model.dart';
import 'package:bbarna/documents/video/screen/edit_video.dart';
import 'package:bbarna/documents/video/viewModel/video_view_model.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/utils/size_config.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:provider/provider.dart';

class VideoListWidget extends StatelessWidget {
  final VideoModel videoData;
  Function onEdit;
  VideoListWidget({required this.videoData, required this.onEdit, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth! - 24,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColorsInApp.colorWhite,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                _getYouTubeThumbnailUrl(videoData.link),
                height: 40,
                width: 40,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/logo.png",
                    height: 40,
                    width: 40,
                    fit: BoxFit.fill,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 5,
              left: 10,
            ),
            child: SelectableText(
              videoData.title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.5,
                  color: AppColorsInApp.colorBlack1),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Container(
                  height: 25,
                  width: 100,
                  alignment: Alignment.center,
                  //  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColorsInApp.colorYellow1),
                  child: FittedBox(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Code: ",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.5,
                                color: AppColorsInApp.colorBlack1),
                          ),
                          SelectableText(
                            videoData.code,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.5,
                                color: AppColorsInApp.colorBlack1),
                          ),
                        ]),
                  ),
                ),
                Container(
                  width: 80,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: videoData.videoType.toLowerCase() == "free"
                          ? AppColorsInApp.colorSecondary!.withValues(alpha: .5)
                          : AppColorsInApp.colorPrimary.withValues(alpha: .5)),
                  child: Text(
                    videoData.videoType,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.5,
                        color: AppColorsInApp.colorBlack1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: InkWell(
                    onTap: () {
                     
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditVideo(
                                    videoData: videoData,
                                  ))).whenComplete(() {
                                     onEdit();
                                  });
                    },
                    child: Icon(
                      Icons.edit,
                      color: AppColorsInApp.colorYellow,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: InkWell(
                    onTap: () {
                      VideoViewModel videoViewModel =
                          Provider.of<VideoViewModel>(context, listen: false);
                      RemoveAlert.showRemoveAlert(
                          title: videoData.title.toString(),
                          description: "Are you sure want to delete ?",
                          onPressYes: () async {
                            await videoViewModel
                                .deleteVideo(videoData.docId)
                                .whenComplete(() async {
                              Navigator.pop(context);
                              await videoViewModel.getFirstVideoList();
                              await videoViewModel.getVideoListLength();
                            });
                          });
                    },
                    child: const Icon(
                      Icons.delete,
                      color: AppColorsInApp.colorPrimary,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String _getYouTubeThumbnailUrl(String url) {
    final Uri uri = Uri.parse(url);
    final String? videoId = uri.queryParameters['v'];
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }
}
