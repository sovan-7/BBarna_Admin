// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/core/widgets/priority_button.dart';
import 'package:bbarna/core/widgets/remove_alert.dart';
import 'package:bbarna/topic/model/topic_model.dart';
import 'package:bbarna/topic/viewModel/topic_view_model.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/topic/screen/edit_topic.dart';
import 'package:bbarna/topic/screen/topic_details.dart';
import 'package:provider/provider.dart';

class TopicCard extends StatelessWidget {
  TopicModel topicData;
  Function onEdit;
  Function onAddClick;
  Function onDelete;
  TopicCard(
      {required this.topicData,
      required this.onEdit,
      required this.onAddClick,
      required this.onDelete,
      super.key});

  @override
  Widget build(BuildContext context) {
    List<String> dataList = [
      "Video: ${topicData.videoCodeList.length}",
      "Audio: ${topicData.audioCodeList.length}",
      "Pdf: ${topicData.pdfCodeList.length}",
      "Quiz: ${topicData.quizCodeList.length}"
    ];
    List<Color> colorList = [
      AppColorsInApp.colorOrange.withOpacity(0.5),
      AppColorsInApp.colorSecondary!.withOpacity(0.5),
      AppColorsInApp.colorPrimary.withOpacity(0.5),
      AppColorsInApp.colorBlue.withOpacity(0.5)
    ];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      //height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColorsInApp.colorWhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectableText(
            topicData.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.5,
              color: AppColorsInApp.colorBlack1,
              overflow: TextOverflow.visible,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColorsInApp.colorBlue.withOpacity(0.5)),
                        child: const Text(
                          "Course Name: ",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                              color: AppColorsInApp.colorBlack1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          topicData.courseName,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                              color: AppColorsInApp.colorBlack1),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColorsInApp.colorLightBlue),
                        child: const Text(
                          "Subject Name: ",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                              color: AppColorsInApp.colorBlack1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          topicData.subjectName,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                              color: AppColorsInApp.colorBlack1),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColorsInApp.colorLightRed),
                        child: const Text(
                          "   Unit Name:   ",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                              color: AppColorsInApp.colorBlack1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          topicData.unitName,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                              color: AppColorsInApp.colorBlack1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: List.generate(
                        dataList.length,
                        (index) => Container(
                          width: 80,
                          height: 25,
                          margin: EdgeInsets.only(
                              left: 20, right: index == 3 ? 0 : 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: colorList[index]),
                          child: Text(
                            dataList[index],
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.5,
                                color: AppColorsInApp.colorBlack1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        PriorityButton(
                            priority: "${topicData.displayPriority}"),
                        Container(
                          height: 25,
                          width: 110,
                          alignment: Alignment.center,

                          //padding: const EdgeInsets.all(5),
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
                                    topicData.code,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 0.5,
                                        color: AppColorsInApp.colorBlack1),
                                  ),
                                ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TopicDetails(
                                            topicData: topicData,
                                          ))).whenComplete(() {
                                onAddClick();
                              });
                            },
                            child: Icon(
                              Icons.add,
                              color: AppColorsInApp.colorSecondary,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: InkWell(
                            onTap: () {
                              onEdit();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditTopic(
                                            topicData: topicData,
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
                          padding: const EdgeInsets.only(left: 20.0),
                          child: InkWell(
                            onTap: () {
                              TopicViewModel topicViewModel =
                                  Provider.of<TopicViewModel>(context,
                                      listen: false);
                              RemoveAlert.showRemoveAlert(
                                  title: topicData.name.toString(),
                                  description: "Are you sure want to delete ?",
                                  onPressYes: () async {
                                    LoaderDialogs.showLoadingDialog();
                                    await topicViewModel
                                        .deleteTopic(topicData.docId)
                                        .whenComplete(() async {
                                      Navigator.pop(context);

                                      Navigator.pop(context);
                                      onDelete();
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
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
