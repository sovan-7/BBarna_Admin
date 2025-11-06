import 'package:bbarna/quiz/viewModel/quiz_view_model.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/core/widgets/add_widget.dart';
import 'package:bbarna/core/widgets/custom_searchbar.dart';
import 'package:bbarna/utils/size_config.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/quiz/screen/add_quiz.dart';
import 'package:bbarna/quiz/widgets/quiz_list_widget.dart';
import 'package:provider/provider.dart';

class QuizList extends StatefulWidget {
  const QuizList({super.key});

  @override
  State<QuizList> createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    QuizViewModel quizViewModel =
        Provider.of<QuizViewModel>(context, listen: false);
    quizViewModel.getFirstQuizList();
    quizViewModel.getQuizListLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (val) {
        Navigator.pop(context);
      },
      canPop: true,
      child: Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 20,
        ),
        child: Consumer<QuizViewModel>(
            builder: (context, quizDataProvider, child) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "QUIZ LIST",
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
                                  builder: (context) => const AddQuiz()))
                          .whenComplete(() {
                        if (searchController.text.isEmpty) {
                          quizDataProvider.getFirstQuizList();
                          quizDataProvider.getQuizListLength();
                        }
                      });
                    },
                  )
                ],
              ),
              CustomSearchBar(
                textEditingController: searchController,
                onChange: () {
                  quizDataProvider.searchQuiz(
                      searchText: searchController.text.toUpperCase());
                },
                onClear: () {
                  searchController.clear();
                  quizDataProvider.searchQuiz(
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
                      itemCount: quizDataProvider.quizList.length,
                      itemBuilder: (context, index) {
                        return SizeConfig.screenWidth! < 900
                            ? FittedBox(
                                child: QuizListWidget(
                                quizModel: quizDataProvider.quizList[index],
                                quizIndex: index + 1,
                                onEdit: () {
                                  if (searchController.text.isEmpty) {
                                    quizDataProvider.getFirstQuizList();
                                  }
                                },
                              ))
                            : QuizListWidget(
                                quizModel: quizDataProvider.quizList[index],
                                quizIndex: index + 1,
                                onEdit: () {
                                  if (searchController.text.isEmpty) {
                                    quizDataProvider.getFirstQuizList();
                                  }
                                },
                              );
                      }),
                ),
              ),
              if (quizDataProvider.quizLength != 0 &&
                  searchController.text.isEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        searchController.clear();
                        if (quizDataProvider.quizList.length >
                            quizDataProvider.limit) {
                          quizDataProvider.removeQuizFromLast();
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
                        "${quizDataProvider.quizList.length}/${quizDataProvider.quizLength}",
                        style: const TextStyle(
                            color: AppColorsInApp.colorBlack1,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        searchController.clear();
                        if (quizDataProvider.quizLength >
                            quizDataProvider.quizList.length) {
                          quizDataProvider.getNextQuizList();
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
      ),
    );
  }
}
