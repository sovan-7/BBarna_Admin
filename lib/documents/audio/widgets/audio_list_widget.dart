// ignore_for_file: must_be_immutable

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bbarna/core/widgets/remove_alert.dart';
import 'package:bbarna/documents/audio/model/audio_model.dart';
import 'package:bbarna/documents/audio/viewModel/audio_view_model.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bbarna/documents/audio/screen/edit_audio.dart';
import 'package:bbarna/utils/size_config.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class AudioListWidget extends StatefulWidget {
  final AudioModel audioData;
  final int index;
  Function onEdit;
  AudioListWidget(
      {required this.audioData,
      required this.index,
      required this.onEdit,
      super.key});

  @override
  State<AudioListWidget> createState() => _AudioListWidgetState();
}

class _AudioListWidgetState extends State<AudioListWidget> {
  AudioPlayer player = AudioPlayer();
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferPosition, duration) => PositionData(
              position, bufferPosition, duration ?? Duration.zero));
  @override
  void initState() {
    player.setUrl(widget.audioData.link);
    player.setLoopMode(LoopMode.off);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth! - 24,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.index + 1}.",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.5,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SelectableText(
                    "${widget.audioData.title} ",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: Colors.black),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                width: 105,
                height: 25,
                margin: const EdgeInsets.only(top: 5, bottom: 5, left: 20),
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
                          widget.audioData.code,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                              color: Colors.black),
                        ),
                      ]),
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      StreamBuilder<PlayerState>(
                        stream: player.playerStateStream,
                        builder:
                            (context, AsyncSnapshot<PlayerState> snapshot) {
                          final playerState = snapshot.data;
                          var processingState = playerState?.processingState;
                          final playing = playerState?.playing;
                          if (snapshot.hasData) {
                            if (!playing!) {
                              return InkWell(
                                  onTap: player.play,
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    size: 25,
                                    color: AppColorsInApp.colorLightBlue,
                                  ));
                            } else if (processingState !=
                                ProcessingState.completed) {
                              return InkWell(
                                  onTap: player.pause,
                                  child: const Icon(
                                    Icons.pause_rounded,
                                    size: 25,
                                    color: AppColorsInApp.colorLightBlue,
                                  ));
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }

                          return InkWell(
                              onTap: () {
                                player.setUrl(widget.audioData.link);
                                player.play();
                              },
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                size: 25,
                                color: AppColorsInApp.colorLightBlue,
                              ));
                        },
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                        width: 130,
                        child: StreamBuilder<PositionData>(
                            stream: _positionDataStream,
                            builder: (context,
                                AsyncSnapshot<PositionData> snapshot) {
                              var positionData = snapshot.data;
                              positionData = positionData?.position ==
                                      positionData?.duration
                                  ? null
                                  : snapshot.data;
                              return snapshot.hasData
                                  ? ProgressBar(
                                      barHeight: 5,
                                      baseBarColor:
                                          AppColorsInApp.colorLightBlue,
                                      bufferedBarColor:
                                          AppColorsInApp.colorLightBlue,
                                      progressBarColor:
                                          AppColorsInApp.colorLightRed,
                                      thumbColor: AppColorsInApp.colorLightRed,
                                      progress: positionData?.position ??
                                          Duration.zero,
                                      buffered: positionData?.bufferPosition ??
                                          Duration.zero,
                                      total: positionData?.duration ??
                                          Duration.zero,
                                      onSeek: player.seek,
                                    )
                                  : const SizedBox();
                            }),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: widget.audioData.audioType.toLowerCase() == "free"
                          ? AppColorsInApp.colorSecondary!.withOpacity(0.5)
                          : AppColorsInApp.colorPrimary.withOpacity(0.5)),
                  child: Text(
                    widget.audioData.audioType,
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
                              builder: (context) => EditAudio(
                                    audioData: widget.audioData,
                                  ))).whenComplete(() {
                        widget.onEdit();
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
                      AudioViewModel audioViewModel =
                          Provider.of<AudioViewModel>(context, listen: false);
                      RemoveAlert.showRemoveAlert(
                          title: widget.audioData.title.toString(),
                          description: "Are you sure want to delete ?",
                          onPressYes: () async {
                            Navigator.pop(context);
                            await audioViewModel
                                .deleteAudio(
                              widget.audioData.docId,
                            )
                                .whenComplete(() async {
                              audioViewModel.clearAudioList();
                              await audioViewModel.getFirstAudioList();
                              audioViewModel.getAudioListLength();
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
}

class PositionData {
  PositionData(this.position, this.bufferPosition, this.duration);
  final Duration position;
  final Duration bufferPosition;
  final Duration duration;
}
