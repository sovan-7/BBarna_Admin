import 'package:bbarna/topic/viewModel/topic_view_model.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/core/widgets/add_widget.dart';
import 'package:bbarna/core/widgets/custom_searchbar.dart';
import 'package:bbarna/utils/size_config.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/topic/screen/add_topic.dart';
import 'package:bbarna/topic/widgets/topic_card.dart';
import 'package:provider/provider.dart';

class TopicList extends StatefulWidget {
  const TopicList({super.key});

  @override
  State<TopicList> createState() => _TopicListState();
}

class _TopicListState extends State<TopicList> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    TopicViewModel topicViewModel =
        Provider.of<TopicViewModel>(context, listen: false);
    topicViewModel.getFirstTopicList();
    topicViewModel.getTopicListLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double width = SizeConfig.screenWidth!;

    return Consumer<TopicViewModel>(
        builder: (context, topicDataProvider, child) {
      return Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "TOPIC LIST",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1.0,
                      color: AppColorsInApp.colorBlack1),
                ),
                AddWidget(
                  addCall: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddTopic()))
                        .whenComplete(() {
                      if (searchController.text.isEmpty) {
                        topicDataProvider.getFirstTopicList();
                        topicDataProvider.getTopicListLength();
                      }
                    });
                  },
                )
              ],
            ),
            CustomSearchBar(
              textEditingController: searchController,
              onChange: () {
                topicDataProvider.searchTopic(
                    searchText: searchController.text.toUpperCase());
              },
              onClear: () {
                searchController.clear();
                topicDataProvider.searchTopic(
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
                    color: Colors.grey.withValues(alpha: .2)),
                child: ListView.builder(
                    itemCount: topicDataProvider.topicList.length,
                    itemBuilder: (context, index) {
                      return SizeConfig.screenWidth! < 900
                          ? FittedBox(
                              child: TopicCard(
                              topicData: topicDataProvider.topicList[index],
                              onEdit: () {
                                if (searchController.text.isEmpty) {
                                  topicDataProvider.getFirstTopicList();
                                }
                              },
                              onAddClick: () {
                                if (searchController.text.isEmpty) {
                                  topicDataProvider.getFirstTopicList();
                                }
                              },
                              onDelete: () {
                                if (searchController.text.isEmpty) {
                                  topicDataProvider.getFirstTopicList();
                                }
                              },
                            ))
                          : TopicCard(
                              topicData: topicDataProvider.topicList[index],
                              onEdit: () {
                                if (searchController.text.isEmpty) {
                                  topicDataProvider.getFirstTopicList();
                                }
                              },
                              onAddClick: () {
                                if (searchController.text.isEmpty) {
                                  topicDataProvider.getFirstTopicList();
                                }
                              },
                              onDelete: () {
                                if (searchController.text.isEmpty) {
                                  topicDataProvider.getFirstTopicList();
                                }
                              },
                            );
                    }),
              ),
            ),
            if (topicDataProvider.topicLength != 0 &&
                searchController.text.isEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      searchController.clear();
                      if (topicDataProvider.topicList.length >
                          topicDataProvider.limit) {
                        topicDataProvider.removeTopicFromLast();
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
                      "${topicDataProvider.topicList.length}/${topicDataProvider.topicLength}",
                      style: const TextStyle(
                          color: AppColorsInApp.colorBlack1,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      searchController.clear();
                      if (topicDataProvider.topicLength >
                          topicDataProvider.topicList.length) {
                        topicDataProvider.getNextTopicList();
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
        ),
      );
    });
  }
}
