import 'package:bbarna/student/viewModel/student_viewmodel.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/core/widgets/custom_searchbar.dart';
import 'package:bbarna/utils/size_config.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/student/widgets/student_card.dart';
import 'package:provider/provider.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});
  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;
  @override
  void initState() {
    Provider.of<StudentViewModel>(context, listen: false).fetchFirstStudentList();
    Provider.of<StudentViewModel>(context, listen: false).getStudentListLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 20,
        ),
        child: Consumer<StudentViewModel>(
            builder: (context, studentDataProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "STUDENT LIST",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.0,
                        color: AppColorsInApp.colorBlack1),
                  ),
                  Container(
                    height: 35,
                    width: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColorsInApp.colorBlack1),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.sync,
                          color: AppColorsInApp.colorWhite,
                          size: 20,
                        ),
                        Text("Excel",
                            style: TextStyle(
                                color: AppColorsInApp.colorWhite,
                                fontSize: 16)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // FittedBox(
              //   child: Container(
              //     height: 35,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(5),
              //         color: AppColorsInApp.colorGrey.withOpacity(0.3)),
              //     child: Row(
              //       children: [
              //         InkWell(
              //           onTap: () {
              //             setState(() {
              //               selectedIndex = 0;
              //             });
              //           },
              //           child: Container(
              //             height: 35,
              //             width: SizeConfig.screenWidth! / 2,
              //             alignment: Alignment.center,
              //             decoration: BoxDecoration(
              //                 borderRadius: const BorderRadius.only(
              //                     topLeft: Radius.circular(5),
              //                     bottomLeft: Radius.circular(5)),
              //                 color: selectedIndex == 0
              //                     ? AppColorsInApp.colorSecondary
              //                     : AppColorsInApp.colorGrey.withOpacity(0.3)),
              //             child: const Text("All STUDENTS",
              //                 style: TextStyle(
              //                   fontSize: 17,
              //                   color: AppColorsInApp.colorWhite,
              //                   fontWeight: FontWeight.normal,
              //                   letterSpacing: 1.0,
              //                 )),
              //           ),
              //         ),
              //         InkWell(
              //           onTap: () {
              //             setState(() {
              //               selectedIndex = 1;
              //             });
              //           },
              //           child: Container(
              //             height: 35,
              //             width: SizeConfig.screenWidth! / 2,
              //             alignment: Alignment.center,
              //             decoration: BoxDecoration(
              //                 borderRadius: const BorderRadius.only(
              //                     topRight: Radius.circular(5),
              //                     bottomRight: Radius.circular(5)),
              //                 color: selectedIndex == 1
              //                     ? AppColorsInApp.colorSecondary
              //                     : AppColorsInApp.colorGrey.withOpacity(0.3)),
              //             child: const Text("PAID STUDENTS",
              //                 style: TextStyle(
              //                   fontSize: 17,
              //                   color: AppColorsInApp.colorWhite,
              //                   fontWeight: FontWeight.normal,
              //                   letterSpacing: 1.0,
              //                 )),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              CustomSearchBar(
                textEditingController: searchController,
                onChange: () {
                  studentDataProvider.searchStudent(
                      searchText: searchController.text);
                },
                onClear: () {
                  searchController.clear();
                  studentDataProvider.searchStudent(
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
                        color: AppColorsInApp.colorGrey.withOpacity(0.2)),
                    child: ListView.builder(
                      itemCount: studentDataProvider.studentList.length,
                      itemBuilder: (context, index) {
                        return SizeConfig.screenWidth! < 900
                            ? FittedBox(
                                child: StudentCard(
                                student: studentDataProvider.studentList[index],
                                index: index,
                              ))
                            : StudentCard(
                                student: studentDataProvider.studentList[index],
                                index: index,
                              );
                      },
                    )),
              ),
              if (studentDataProvider.studentListLength != 0 &&
                  searchController.text.isEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        searchController.clear();
                        if (studentDataProvider.studentList.length >
                            studentDataProvider.limit) {
                          studentDataProvider.removeStudentFromLast();
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
                        "${studentDataProvider.studentList.length}/${studentDataProvider.studentListLength}",
                        style: const TextStyle(
                            color: AppColorsInApp.colorBlack1,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        searchController.clear();
                        if (studentDataProvider.studentListLength >
                            studentDataProvider.studentList.length) {
                          studentDataProvider.fetchNextStudentList();
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
        }));
  }
}
