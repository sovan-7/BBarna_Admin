// ignore_for_file: must_be_immutable

import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/core/widgets/priority_button.dart';
import 'package:bbarna/core/widgets/remove_alert.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/units/model/unit_model.dart';
import 'package:bbarna/units/viewModel/unit_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/core/widgets/active_button.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/units/screen/edit_unit.dart';
import 'package:provider/provider.dart';

class UnitCard extends StatelessWidget {
  UnitModel unitData;
  Function onEdit;
  Function onDelete;
  Function onChangeLock;
  UnitCard(
      {required this.unitData,
      required this.onEdit,
      required this.onDelete,
      required this.onChangeLock,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
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
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    unitData.image,
                    height: 80,
                    width: 80,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/logo.png",
                        height: 60,
                        width: 60,
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
                    unitData.name,
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
                            color: AppColorsInApp.colorOrange.withValues(alpha: .6)),
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
                          unitData.courseName,
                          style: const TextStyle(
                              fontSize: 11,
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
                          unitData.subjectName,
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
                  width: 100,
                  alignment: Alignment.center,
                  // padding: const EdgeInsets.all(5),
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
                            unitData.code,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.5,
                                color: AppColorsInApp.colorBlack1),
                          ),
                        ]),
                  ),
                ),
                PriorityButton(priority: "${unitData.displayPriority}"),
                const ActiveButton(),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection(unit)
                          .doc(unitData.id)
                          .update({
                        'lock_status': !unitData.lockStatus,
                      }).then((value) {
                        onChangeLock();
                       
                      });
                    },
                    child: Icon(
                      unitData.lockStatus
                          ? Icons.lock_outline_rounded
                          : Icons.lock_open_outlined,
                      color: AppColorsInApp.colorPrimary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditUnit(
                                    unitData: unitData,
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
                      RemoveAlert.showRemoveAlert(
                          title: unitData.name.toString(),
                          description: "Are you sure want to delete ?",
                          onPressYes: () async {
                            UnitViewModel unitViewModel =
                                Provider.of<UnitViewModel>(context,
                                    listen: false);
                            LoaderDialogs.showLoadingDialog();
                            await unitViewModel
                                .deleteUnit(unitData.id)
                                .then((value) async {
                              /// remove loader
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
          )
        ],
      ),
    );
  }
}
