// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/core/widgets/priority_button.dart';
import 'package:bbarna/core/widgets/remove_alert.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/subject/model/subject_model.dart';
import 'package:bbarna/subject/viewModel/subject_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/core/widgets/active_button.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/subject/screen/edit_subject.dart';
import 'package:provider/provider.dart';

class SubjectCard extends StatelessWidget {
  SubjectModel subjectData;
  Function onEdit;
  SubjectCard({required this.subjectData, required this.onEdit, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    subjectData.image,
                    height: 50,
                    width: 50,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/logo.png",
                        height: 50,
                        width: 50,
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
                    subjectData.name,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.5,
                        color: AppColorsInApp.colorBlack1),
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
                                subjectData.code,
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0.5,
                                    color: AppColorsInApp.colorBlack1),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          subjectData.courseName,
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
                Text(
                  "₹ ${subjectData.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColorsInApp.colorOrange),
                ),
                PriorityButton(priority: "${subjectData.displayPriority}"),
                ActiveButton(
                  isActive: subjectData.willDisplay,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection(subject)
                          .doc(subjectData.docId)
                          .update({
                        'isLocked': !subjectData.isLocked,
                      }).whenComplete(() {
                        Provider.of<SubjectViewModel>(context, listen: false)
                            .getSubjectList();
                      });
                    },
                    child: Icon(
                      subjectData.isLocked
                          ? Icons.lock_outline_rounded
                          : Icons.lock_open_outlined,
                      color: AppColorsInApp.colorPrimary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection(subject)
                          .doc(subjectData.docId)
                          .update({
                        'isPopular': !subjectData.isPopular,
                      }).whenComplete(() {
                        Provider.of<SubjectViewModel>(context, listen: false)
                            .getSubjectList();
                      });
                    },
                    child: Icon(
                      Icons.favorite,
                      color: subjectData.isPopular
                          ? AppColorsInApp.colorPrimary
                          : AppColorsInApp.colorGrey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: () {
                     
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditSubject(
                                    subjectData: subjectData,
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
                    onTap: () async {
                      SubjectViewModel subjectViewModel =
                          Provider.of<SubjectViewModel>(context, listen: false);
                      RemoveAlert.showRemoveAlert(
                          title: subjectData.name.toString(),
                          description: "Are you sure want to delete ?",
                          onPressYes: () async {
                            LoaderDialogs.showLoadingDialog();
                            await subjectViewModel
                                .deleteSubject(subjectData.docId)
                                .whenComplete(() async {
                              Navigator.pop(context);
                              await subjectViewModel.getSubjectList();
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
