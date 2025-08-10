import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/student/viewModel/student_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnrolledUnitList extends StatefulWidget {
  const EnrolledUnitList({super.key});

  @override
  State<EnrolledUnitList> createState() => _EnrolledUnitListState();
}

class _EnrolledUnitListState extends State<EnrolledUnitList> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 600,
        width: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColorsInApp.colorWhite,
        ),
        child: Consumer<StudentViewModel>(builder: (context, studentVM, child) {
          return Column(
            children: [
              Container(
                height: 35,
                width: 600,
                color: AppColorsInApp.colorOrange,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    const Text(
                      "Unit List",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColorsInApp.colorBlack1),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            studentVM.setAllCheckList();
                          },
                          child: Text(
                            studentVM.selectedUnitList.contains("")
                                ? "Select All"
                                : "Remove All",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColorsInApp.colorBlack1),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                            size: 22,
                            color: AppColorsInApp.colorBlack1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: studentVM.unitList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 70,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColorsInApp.colorOrange.withOpacity(0.05),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  studentVM.unitList[index].image,
                                  height: 50,
                                  width: 50,
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
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                studentVM.unitList[index].name,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0.5,
                                    color: AppColorsInApp.colorBlack1),
                              ),
                            ],
                          ),
                          Checkbox(
                              value: studentVM.selectedUnitList[index]
                                  .contains(studentVM.unitList[index].code),
                              onChanged: (bool? val) {
                                studentVM.updateCheckList(index);
                              }),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
