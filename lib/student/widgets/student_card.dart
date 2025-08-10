// ignore_for_file: must_be_immutable

import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/core/widgets/remove_alert.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/student/model/student_model.dart';
import 'package:bbarna/student/viewModel/student_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/student/screen/settings_student.dart';
import 'package:provider/provider.dart';

class StudentCard extends StatelessWidget {
  Student student;
  int index;
  StudentCard({required this.student, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
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
              Text(
                student.studentName,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.5,
                    color: Colors.black),
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 5.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: AppColorsInApp.colorGrey,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "+91 ${student.studentPhoneNumber}",
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.5,
                        color: AppColorsInApp.colorBlack1),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone_android_rounded,
                          color: AppColorsInApp.colorGrey,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 5.0, left: 5.0),
                    child: Row(
                      children: [
                        Text(
                          "Whatsapp",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                              color: AppColorsInApp.colorBlack1),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    student.studentWhatsappNumber != stringDefault
                        ? student.studentWhatsappNumber
                        : "+91 1234567890",
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.5,
                        color: AppColorsInApp.colorBlack1),
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
                        color: student.studentWhatsappNumber != stringDefault
                            ? AppColorsInApp.colorSecondary
                            : AppColorsInApp.colorPrimary),
                    child: Text(
                      student.studentWhatsappNumber == stringDefault
                          ? "Pending"
                          : "Verified",
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.5,
                          color: AppColorsInApp.colorWhite),
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(
                      Icons.email,
                      color: AppColorsInApp.colorGrey,
                      size: 15,
                    ),
                  ),
                  Text(
                    "myexample@gmail.com",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.5,
                        color: AppColorsInApp.colorBlack1),
                  ),
                ],
              ),
              Row(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Mail Status",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0.5,
                            color: AppColorsInApp.colorBlack1),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 2,
                          bottom: 2,
                        ),
                        margin: const EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: 10,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColorsInApp.colorPrimary),
                        child: const Text(
                          "No",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                              color: AppColorsInApp.colorWhite),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: [
                        const Text(
                          "SMS Status",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                              color: AppColorsInApp.colorBlack1),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 2,
                            bottom: 2,
                          ),
                          margin: const EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColorsInApp.colorSecondary),
                          child: const Text(
                            "Yes",
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.5,
                                color: AppColorsInApp.colorWhite),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  try {
                    LoaderDialogs.showLoadingDialog();
                    FirebaseFirestore.instance
                        .collection("student")
                        .doc(student.studentId)
                        .update({
                      'device_count': 0,
                    }).whenComplete(() {
                      Navigator.pop(context);
                      Provider.of<StudentViewModel>(context, listen: false)
                          .clearDeviceCount(index);
                    });
                  } catch (e) {
                    Navigator.pop(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: AppColorsInApp.colorYellow),
                      Text(
                        " - ${student.deviceCount}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0.5,
                            color: AppColorsInApp.colorPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingStudent(
                                studentId: student.studentId,
                                studentName: student.studentName,
                              )));
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: AppColorsInApp.colorBlue),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  RemoveAlert.showRemoveAlert(
                      title: "Remove Student",
                      description: "Are you sure want to remove student ?",
                      onPressYes: () {
                        Navigator.pop(context);
                        try {
                          LoaderDialogs.showLoadingDialog();
                          FirebaseFirestore.instance
                              .collection("student")
                              .doc(student.studentId)
                              .delete()
                              .whenComplete(() {
                            Navigator.pop(context);
                            Provider.of<StudentViewModel>(context,
                                    listen: false)
                                .removeStudent(index);
                          });
                        } catch (e) {
                          Navigator.pop(context);
                        }
                      });
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Row(
                    children: [
                      Icon(Icons.cancel_outlined,
                          color: AppColorsInApp.colorPrimary),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
