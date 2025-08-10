// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:bbarna/core/widgets/active_button.dart';
import 'package:bbarna/core/widgets/priority_button.dart';
import 'package:bbarna/core/widgets/remove_alert.dart';
import 'package:bbarna/course/model/course_model.dart';
import 'package:bbarna/course/screen/edit_course.dart';
import 'package:bbarna/course/viewModel/course_view_model.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseListWidget extends StatelessWidget {
  CourseModel courseData;
  Function onEdit;
  CourseListWidget({required this.courseData, required this.onEdit, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 65,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColorsInApp.colorWhite,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    courseData.image,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(
                    courseData.name,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.5,
                        color: AppColorsInApp.colorBlack1),
                  ),
                  if (courseData.description.isNotEmpty)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          margin:
                              const EdgeInsets.only(top: 5, bottom: 5, left: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColorsInApp.colorLightBlue),
                          child: const Text(
                            "Description: ",
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
                            courseData.description,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.5,
                                color: AppColorsInApp.colorBlack1),
                          ),
                        ),
                      ],
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
                  height: 25,
                  width: 90,
                  alignment: Alignment.center,
                  //padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                  ),
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
                            courseData.code,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.5,
                                color: AppColorsInApp.colorBlack1),
                          ),
                        ]),
                  ),
                ),
                PriorityButton(priority: "${courseData.displayPriority}"),
                ActiveButton(
                  isActive: courseData.willDisplay,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection(course)
                          .doc(courseData.docId)
                          .update({
                        'isLocked': !courseData.isLocked,
                      }).then((value) {
                        Provider.of<CourseViewModel>(context, listen: false)
                            .getCourseList();
                      });
                    },
                    child: Icon(
                      courseData.isLocked
                          ? Icons.lock_outline_rounded
                          : Icons.lock_open_outlined,
                      color: AppColorsInApp.colorPrimary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: InkWell(
                    onTap: () {
                      onEdit();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditCourse(
                                    courseData: courseData,
                                  )));
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
                    onTap: () async {
                      CourseViewModel courseViewModel =
                          Provider.of<CourseViewModel>(context, listen: false);
                      RemoveAlert.showRemoveAlert(
                          title: courseData.name.toString(),
                          description: "Are you sure want to delete ?",
                          onPressYes: () async {
                            await courseViewModel
                                .deleteCourse(courseData.docId)
                                .then((value) async {
                              await courseViewModel.getCourseList();
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
          )
        ],
      ),
    );
  }
}
