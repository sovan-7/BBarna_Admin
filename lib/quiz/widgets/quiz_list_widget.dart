// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/core/widgets/remove_alert.dart';
import 'package:bbarna/quiz/model/quiz_model.dart';
import 'package:bbarna/quiz/viewModel/quiz_view_model.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/quiz/screen/edit_quiz.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:provider/provider.dart';

class QuizListWidget extends StatelessWidget {
  final QuizModel quizModel;
  final int quizIndex;
  Function onEdit;
  QuizListWidget(
      {required this.quizModel,
      required this.quizIndex,
      required this.onEdit,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColorsInApp.colorWhite,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectableText(
                "$quizIndex. ${quizModel.name}",
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.5,
                    color: AppColorsInApp.colorBlack1),
              ),
              Row(
                children: [
                  Container(
                    height: 25,
                    width: 110,
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColorsInApp.colorYellow1),
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
                          quizModel.code,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                              color: AppColorsInApp.colorBlack1),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColorsInApp.colorLightBlue),
                    child: Text(
                      "Total Question: ${quizModel.totalQuestion}",
                      style: const TextStyle(
                          fontSize: 10,
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
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: quizModel.type.toLowerCase() == "free"
                          ? AppColorsInApp.colorSecondary!.withOpacity(0.5)
                          : AppColorsInApp.colorPrimary.withOpacity(0.5)),
                  child: Text(
                    quizModel.type,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.5,
                        color: AppColorsInApp.colorBlack1),
                  ),
                ),
                DefaultSelectionStyle(
                  mouseCursor: MouseCursor.defer,
                  cursorColor: Colors.black,
                  child: Container(
                    width: 80,
                    height: 25,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColorsInApp.colorOrange.withOpacity(0.5)),
                    child: Text(
                      quizModel.status,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.5,
                          color: AppColorsInApp.colorBlack1),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditQuiz(
                                  quizModel: quizModel,
                                ))).whenComplete(() {
                      onEdit();
                    });
                  },
                  child: Icon(
                    Icons.edit,
                    color: AppColorsInApp.colorYellow,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: () {
                      QuizViewModel quizViewModel =
                          Provider.of<QuizViewModel>(context, listen: false);
                      RemoveAlert.showRemoveAlert(
                          title: quizModel.name.toString(),
                          description: "Are you sure want to delete ?",
                          onPressYes: () async {
                            LoaderDialogs.showLoadingDialog();
                            await quizViewModel
                                .deleteQuiz(quizModel.docId)
                                .whenComplete(() async {
                              Navigator.pop(context);
                              await quizViewModel.getFirstQuizList();
                              await quizViewModel.getQuizListLength();
                              Navigator.pop(context);
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
          ),
        ],
      ),
    );
  }
}
