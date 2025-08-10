// ignore_for_file: must_be_immutable

import 'package:bbarna/banners/screen/banner_list.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/core/widgets/app_header.dart';
import 'package:bbarna/core/widgets/extra_sidebar.dart';
import 'package:bbarna/core/widgets/sidebar_widget.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/course/screen/course_list.dart';
import 'package:bbarna/documents/audio/screen/audio_list.dart';
import 'package:bbarna/documents/pdf/screen/pdf_list.dart';
import 'package:bbarna/documents/video/screen/video_list.dart';
import 'package:bbarna/question/screen/question_list.dart';
import 'package:bbarna/quiz/screen/quiz_list.dart';
import 'package:bbarna/student/screen/student_list.dart';
import 'package:bbarna/subject/screen/subject_list.dart';
import 'package:bbarna/topic/screen/topic_list.dart';
import 'package:bbarna/units/screen/unit_list.dart';

class Sidebar extends StatefulWidget {
  final int sidebarIndex;
  const Sidebar({required this.sidebarIndex, super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  int selectedIndex = 0;

  List<Widget> screenList = [
    const BannerList(),
    const CourseList(),
    const SubjectList(),
    const UnitList(),
    const TopicList(),
    const VideoList(),
    const PDFList(),
    const AudioList(),
    const QuizList(),
    const QuestionList(),
    const StudentList()
  ];

  List<String> drawerItems = [
    "BANNERS",
    "COURSES",
    "SUBJECT",
    "UNIT",
    "TOPIC",
    "VIDEOS",
    "PDF",
    "AUDIO",
    "QUIZ",
    "QUESTIONS",
    "STUDENTS",
  ];

  List<IconData> iconList = [
    Icons.image,
    Icons.subject_outlined,
    Icons.book,
    Icons.ad_units,
    Icons.topic_outlined,
    Icons.video_file,
    Icons.picture_as_pdf,
    Icons.audio_file,
    Icons.quiz_outlined,
    Icons.question_mark_sharp,
    Icons.people,
  ];
  @override
  void initState() {
    selectedIndex = widget.sidebarIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
          key: key,
          body: PopScope(
            onPopInvoked: (val) {},
            canPop: false,
            child: Column(
              children: [
                AppHeader(
                  onTapIcon: () {
                    key.currentState?.openDrawer();
                  },
                ),
                Expanded(
                  child: Row(
                    children: [
                      if (width > 900)
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                // color: Colors.pink,
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color:
                                      AppColorsInApp.colorGrey.withOpacity(0.4),
                                  child: ListView.builder(
                                      itemCount: drawerItems.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = index;
                                              });
                                            },
                                            child: SidebarWidget(
                                              iconData: iconList[index],
                                              itemText: drawerItems[index],
                                              isSelected:
                                                  index == selectedIndex,
                                            ));
                                      }),
                                ),
                              )
                            ],
                          ),
                        ),
                      Expanded(flex: 5, child: screenList[selectedIndex])
                    ],
                  ),
                ),
              ],
            ),
          ),
          drawer: width < 900
              ? Drawer(
                  child: ExtraSideBar(
                    sidebarIndex: selectedIndex,
                    isFromLogin: true,
                  ),
                )
              : null),
    );
  }
}
