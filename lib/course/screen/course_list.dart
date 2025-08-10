import 'package:bbarna/core/widgets/add_widget.dart';
import 'package:bbarna/core/widgets/custom_searchbar.dart';
import 'package:bbarna/course/screen/add_course.dart';
import 'package:bbarna/course/viewModel/course_view_model.dart';
import 'package:bbarna/course/widgets/course_list_widget.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseList extends StatefulWidget {
  const CourseList({super.key});

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  CourseViewModel courseViewModel = CourseViewModel();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    courseViewModel = Provider.of<CourseViewModel>(context, listen: false);
    getCourseList();
    super.initState();
  }

  void getCourseList() async {
    await courseViewModel.getCourseList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseViewModel>(builder: (context, courseVM, child) {
      return Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "COURSE LIST",
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
                                builder: (context) => const AddCourse()))
                        .whenComplete(() {
                      if (searchController.text.isEmpty) {
                        Provider.of<CourseViewModel>(context, listen: false)
                            .getCourseList();
                      }
                    });
                  },
                )
              ],
            ),
            CustomSearchBar(
              textEditingController: searchController,
              onChange: () {
                courseViewModel.searchCourse(searchText: searchController.text);
              },
              onClear: () {
                searchController.clear();
                courseViewModel.searchCourse(searchText: searchController.text);
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
                    color: Colors.grey.withOpacity(0.2)),
                child: ListView.builder(
                    itemCount: courseVM.courseList.length,
                    itemBuilder: (context, index) {
                      return SizeConfig.screenWidth! < 900
                          ? FittedBox(
                              child: CourseListWidget(
                              courseData: courseVM.courseList[index],
                              onEdit: () {
                                if (searchController.text.isEmpty) {
                                  courseVM.getCourseList();
                                }
                              },
                            ))
                          : CourseListWidget(
                              courseData: courseVM.courseList[index],
                              onEdit: () {
                                if (searchController.text.isEmpty) {
                                  courseVM.getCourseList();
                                }
                              },
                            );
                    }),
              ),
            )
          ],
        ),
      );
    });
  }
}
