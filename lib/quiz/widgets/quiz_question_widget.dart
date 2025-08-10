// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'package:bbarna/question/model/question.dart';
import 'package:bbarna/quiz/model/quiz_model.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart' as html_parser;

class QuizQuestionListWidget extends StatelessWidget {
  final Question question;
  final int questionIndex;
  final QuizModel quizData;
  final bool isSelected;
  Function onPress;

  QuizQuestionListWidget(
      {required this.question,
      required this.questionIndex,
      required this.quizData,
      required this.isSelected,
      required this.onPress,
      super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColorsInApp.colorWhite,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: (width - 180) - (width > 1200 ? 235 : 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${questionIndex + 1}. ",
                          maxLines: 3,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: AppColorsInApp.colorBlack1),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: Text(
                            parseHtmlString(
                              getHTMLContent(question.question),
                            ),
                            maxLines: 5,
                            style: const TextStyle(
                                color: AppColorsInApp.colorBlack1,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        // HtmlWidget(
                        //   getHTMLContent(question.question),
                        //   textStyle: const TextStyle(
                        //     overflow: TextOverflow.visible,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: 110,
                        margin: const EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColorsInApp.colorYellow1),
                        child: Text(
                          "Q Code - ${question.questionCode}",
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                              color: AppColorsInApp.colorBlack1),
                        ),
                      ),
                      Container(
                        width: getWidth(width),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        margin: const EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: HtmlWidget(
                          getHTMLContent(question.answer),
                          textStyle: TextStyle(
                              color: Colors.green[700],
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25),
              child: Checkbox(
                activeColor:AppColorsInApp.colorSecondary ,
                checkColor: AppColorsInApp.colorWhite,
                  value: isSelected,
                  onChanged: (val) {
                    onPress(val);
                  })),
        ],
      ),
    );
  }

  String getHTMLContent(String content) {
    var start =
        "<body style=\"background: #000000; color:#ffffff; height:auto\">";
    String end = "</body>";
    var htmlString = start + content + end;
    return htmlString;
  }

  String parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    final String parsedString = document.body?.text ?? '';
    return parsedString;
  }

  
  double getWidth(double screenWidth) {
    double width = (screenWidth - 320);
    if ((screenWidth - 320 - 235).isNegative) {
      width = 300;
    } else {
      if (screenWidth > 1200) {
        width -= 235;
      } else {
        width -= 200;
      }
    }
    return width;
  }
}
