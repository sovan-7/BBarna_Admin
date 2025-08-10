import 'package:bbarna/course/viewModel/course_view_model.dart';
import 'package:bbarna/subject/viewModel/subject_view_model.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/core/widgets/add_widget.dart';
import 'package:bbarna/core/widgets/custom_searchbar.dart';
import 'package:bbarna/utils/size_config.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/subject/screen/add_subject.dart';
import 'package:bbarna/subject/widgets/subject_card.dart';
import 'package:provider/provider.dart';

class SubjectList extends StatefulWidget {
  const SubjectList({super.key});

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  CourseViewModel _courseViewModel = CourseViewModel();
  SubjectViewModel _subjectViewModel = SubjectViewModel();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _courseViewModel = Provider.of(context, listen: false);
    _subjectViewModel = Provider.of(context, listen: false);
    getSubjectList();
    if (_courseViewModel.courseList.isEmpty) {
      _courseViewModel.getCourseList();
    }
    super.initState();
  }

  void getSubjectList() async {
    await _subjectViewModel.getSubjectList();
  }

  @override
  Widget build(BuildContext context) {
    // double width = SizeConfig.screenWidth!;

    return Consumer<SubjectViewModel>(builder: (context, subjectVM, child) {
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
                  "SUBJECT LIST",
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
                                builder: (context) => const AddSubject()))
                        .whenComplete(() {
                      if (searchController.text.isEmpty) {
                        Provider.of<SubjectViewModel>(context, listen: false)
                            .getSubjectList();
                      }
                    });
                  },
                )
              ],
            ),
            CustomSearchBar(
              textEditingController: searchController,
              onChange: () {
                subjectVM.searchSubject(searchText: searchController.text);
              },
              onClear: () {
                searchController.clear();
                subjectVM.searchSubject(searchText: searchController.text);
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
                    itemCount: subjectVM.subjectList.length,
                    itemBuilder: (context, index) {
                      return SizeConfig.screenWidth! < 900
                          ? FittedBox(
                              child: SubjectCard(
                              subjectData: subjectVM.subjectList[index],
                              onEdit: () {
                                if (searchController.text.isEmpty) {
                                  subjectVM.getSubjectList();
                                }
                              },
                            ))
                          : SubjectCard(
                              subjectData: subjectVM.subjectList[index],
                              onEdit: () {
                                if (searchController.text.isEmpty) {
                                  subjectVM.getSubjectList();
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
