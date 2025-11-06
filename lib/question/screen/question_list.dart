import 'package:bbarna/core/widgets/custom_searchbar.dart';
import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/core/widgets/remove_alert.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/core/widgets/add_widget.dart';
import 'package:bbarna/utils/size_config.dart';
import 'package:bbarna/question/question_viewmodel/question_viewmodel.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/question/screen/add_question.dart';
import 'package:bbarna/question/widgets/question_list_widget.dart';
import 'package:provider/provider.dart';

class QuestionList extends StatefulWidget {
  const QuestionList({super.key});

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    QuestionViewModel questionViewModel =
        Provider.of<QuestionViewModel>(context, listen: false);
    questionViewModel.getQuestionListLength();
    questionViewModel.fetchFirstQuestionList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth!;

    return Consumer<QuestionViewModel>(
        builder: (context, questionDataProvider, child) {
      return Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "QUESTION LIST",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1.0,
                      color: AppColorsInApp.colorBlack1),
                ),
                Row(
                  children: [
                    AddWidget(
                      icon: Icons.sync,
                      title: "SYNC",
                      addCall: () {
                        searchController.clear();
                        questionDataProvider
                            .fetchFirstQuestionList()
                            .then((value) {
                          scrollController.animateTo(0,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeIn);
                        });
                      },
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    AddWidget(
                      addCall: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddQuestion()))
                            .whenComplete(() {
                          if (searchController.text.isEmpty) {
                            questionDataProvider.fetchFirstQuestionList();
                            questionDataProvider.getQuestionListLength();
                          }
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
            CustomSearchBar(
              textEditingController: searchController,
              onChange: () {
                questionDataProvider.searchQuestion(
                    searchText: searchController.text.toUpperCase());
              },
              onClear: () {
                searchController.clear();
                questionDataProvider.searchQuestion(
                    searchText: searchController.text.toUpperCase());
              },
            ),
            Expanded(
              child: questionDataProvider.questionList.isEmpty
                  ? const SizedBox()
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColorsInApp.colorGrey.withValues(alpha: .2)),
                      child: ListView.builder(
                          itemCount: questionDataProvider.questionList.length,
                          controller: scrollController,
                          itemBuilder: (context, index) {
                            return width < 900
                                ? FittedBox(
                                    child: QuestionListWidget(
                                    question: questionDataProvider
                                        .questionList[index],
                                    questionIndex: index,
                                    onEdit: () {
                                      if (searchController.text.isEmpty) {
                                        questionDataProvider
                                            .fetchFirstQuestionList();
                                      }
                                    },
                                    onDelete: () {
                                      QuestionViewModel questionViewModel =
                                          Provider.of<QuestionViewModel>(
                                              context,
                                              listen: false);
                                      RemoveAlert.showRemoveAlert(
                                          title: "${index + 1}",
                                          description:
                                              "Are you sure want to delete ?",
                                          onPressYes: () {
                                            LoaderDialogs.showLoadingDialog();
                                            questionViewModel
                                                .deleteQuestion(
                                                    documentId:
                                                        questionDataProvider
                                                            .questionList[index]
                                                            .docId,
                                                    questionIndex: index)
                                                .whenComplete(() {
                                              Navigator.pop(context);
                                              // questionViewModel
                                              //     .fetchFirstQuestionList();
                                              // questionViewModel
                                              //     .getQuestionListLength();
                                              Navigator.pop(context);
                                            });
                                          });
                                    },
                                  ))
                                : QuestionListWidget(
                                    question: questionDataProvider
                                        .questionList[index],
                                    questionIndex: index,
                                    onEdit: () {
                                      if (searchController.text.isEmpty) {
                                        questionDataProvider
                                            .fetchFirstQuestionList();
                                      }
                                    },
                                    onDelete: () {
                                      QuestionViewModel questionViewModel =
                                          Provider.of<QuestionViewModel>(
                                              context,
                                              listen: false);
                                      RemoveAlert.showRemoveAlert(
                                          title: "${index + 1}",
                                          description:
                                              "Are you sure want to delete ?",
                                          onPressYes: () {
                                            LoaderDialogs.showLoadingDialog();
                                            questionViewModel
                                                .deleteQuestion(
                                                    documentId:
                                                        questionDataProvider
                                                            .questionList[index]
                                                            .docId,
                                                    questionIndex: index)
                                                .whenComplete(() {
                                              Navigator.pop(context);
                                              // questionViewModel
                                              //     .fetchFirstQuestionList();
                                              // questionViewModel
                                              //     .getQuestionListLength();
                                              Navigator.pop(context);
                                            });
                                          });
                                    },
                                  );
                          }),
                    ),
            ),
            if (questionDataProvider.questionListLength != 0 &&
                searchController.text.isEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      searchController.clear();
                      if (questionDataProvider.questionList.length >
                          questionDataProvider.limit) {
                        questionDataProvider.removeQuestionFromLast();
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
                      "${questionDataProvider.questionList.length}/${questionDataProvider.questionListLength}",
                      style: const TextStyle(
                          color: AppColorsInApp.colorBlack1,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      searchController.clear();
                      if (questionDataProvider.questionListLength >
                          questionDataProvider.questionList.length) {
                        questionDataProvider.fetchNextQuestionList();
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
