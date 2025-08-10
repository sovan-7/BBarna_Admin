// import 'package:flutter/material.dart';
// import 'package:bbarna/core/widgets/app_header.dart';
// import 'package:bbarna/core/widgets/custom_text_field.dart';
// import 'package:bbarna/core/widgets/extra_sidebar.dart';
// import 'package:bbarna/core/widgets/save_button.dart';
// import 'package:bbarna/utils/size_config.dart';
// import 'package:bbarna/resources/app_colors.dart';

// class EditStudent extends StatefulWidget {
//   const EditStudent({super.key});

//   @override
//   State<EditStudent> createState() => _EditStudentState();
// }

// class _EditStudentState extends State<EditStudent> {
//   TextEditingController studentNameCodeTextController = TextEditingController();
//   TextEditingController emailTextController = TextEditingController();
//   TextEditingController phoneTextController = TextEditingController();
//   TextEditingController totalCourseFeesTextController = TextEditingController();
//   TextEditingController paidAmountTextController = TextEditingController();
//   TextEditingController displayPriorityTextController = TextEditingController();
//   String _selectedValue = 'Uddipan';
//   String _selectedValueForPayment = "FULL PAID";
//   final List<String> _dropdownItems = [
//     'Uddipan',
//     'Prodipan',
//   ];
//   final List<String> _dropdownItemsForPayment = [
//     'FULL PAID',
//     'PART PAID',
//     'PENDING'
//   ];
//   final GlobalKey<ScaffoldState> key = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     // double width = SizeConfig.screenWidth!;
//     return Scaffold(
//         key: key,
//         body: PopScope(
//           onPopInvoked: (bool val) {},
//           canPop: true,
//           child: Column(
//             children: [
//               AppHeader(
//                 onTapIcon: () {
//                   key.currentState?.openDrawer();
//                 },
//               ),
//               Expanded(
//                 child: Row(
//                   children: [
//                     if (SizeConfig.screenWidth! > 900)
//                       const Expanded(
//                           child: ExtraSideBar(
//                         sidebarIndex: 10,
//                       )),
//                     Expanded(
//                       flex: 5,
//                       child: Container(
//                         padding: const EdgeInsets.only(
//                           left: 20,
//                           right: 20,
//                         ),
//                         color: AppColorsInApp.colorGrey.withOpacity(0.1),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   crossAxisAlignment:
//                                       SizeConfig.screenWidth! < 900
//                                           ? CrossAxisAlignment.center
//                                           : CrossAxisAlignment.center,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceEvenly,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 const Text(
//                                                   "Course",
//                                                   style: TextStyle(
//                                                       fontSize: 15,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       color: AppColorsInApp
//                                                           .colorGrey),
//                                                 ),
//                                                 Container(
//                                                   width: 350,
//                                                   margin: const EdgeInsets.only(
//                                                     top: 10,
//                                                     bottom: 20,
//                                                   ),
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           left: 15),
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                     color: AppColorsInApp
//                                                         .colorWhite,
//                                                   ),
//                                                   child: DropdownButton<String>(
//                                                     value: _selectedValue,
//                                                     elevation: 16,
//                                                     style: const TextStyle(
//                                                         color: AppColorsInApp
//                                                             .colorBlack1),
//                                                     underline: Container(),
//                                                     onChanged:
//                                                         (String? newValue) {
//                                                       setState(() {
//                                                         _selectedValue =
//                                                             newValue!;
//                                                       });
//                                                     },
//                                                     items: _dropdownItems.map<
//                                                             DropdownMenuItem<
//                                                                 String>>(
//                                                         (String value) {
//                                                       return DropdownMenuItem<
//                                                           String>(
//                                                         value: value,
//                                                         child: Text(value),
//                                                       );
//                                                     }).toList(),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             CustomTextField(
//                                               title: "Student Name",
//                                               labelText: "your name ..",
//                                               textEditingController:
//                                                   studentNameCodeTextController,
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   top: 20.0),
//                                               child: CustomTextField(
//                                                 title: "Email",
//                                                 labelText: "your email ...",
//                                                 textEditingController:
//                                                     emailTextController,
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   top: 20.0),
//                                               child: CustomTextField(
//                                                 title: "Phone",
//                                                 labelText: "your phone no ...",
//                                                 textEditingController:
//                                                     phoneTextController,
//                                               ),
//                                             ),
//                                             if (SizeConfig.screenWidth! < 900)
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceEvenly,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 20.0),
//                                                     child: CustomTextField(
//                                                       title:
//                                                           "Total Course Fees",
//                                                       labelText: "1111",
//                                                       textEditingController:
//                                                           totalCourseFeesTextController,
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 20.0),
//                                                     child: CustomTextField(
//                                                       title: "Paid Amount",
//                                                       labelText: "10000",
//                                                       textEditingController:
//                                                           paidAmountTextController,
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 20.0),
//                                                     child: Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         const Text(
//                                                           "Payment Status",
//                                                           style: TextStyle(
//                                                               fontSize: 15,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               color:
//                                                                   AppColorsInApp
//                                                                       .colorGrey),
//                                                         ),
//                                                         Container(
//                                                           width: 350,
//                                                           margin:
//                                                               const EdgeInsets
//                                                                   .only(
//                                                             top: 10,
//                                                             bottom: 20,
//                                                           ),
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .only(
//                                                                   left: 15),
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         10),
//                                                             color:
//                                                                 AppColorsInApp
//                                                                     .colorWhite,
//                                                           ),
//                                                           child: DropdownButton<
//                                                               String>(
//                                                             value:
//                                                                 _selectedValueForPayment,
//                                                             elevation: 16,
//                                                             style: const TextStyle(
//                                                                 color: AppColorsInApp
//                                                                     .colorBlack1),
//                                                             underline:
//                                                                 Container(),
//                                                             onChanged: (String?
//                                                                 newValue) {
//                                                               setState(() {
//                                                                 _selectedValueForPayment =
//                                                                     newValue!;
//                                                               });
//                                                             },
//                                                             items: _dropdownItemsForPayment.map<
//                                                                 DropdownMenuItem<
//                                                                     String>>((String
//                                                                 value) {
//                                                               return DropdownMenuItem<
//                                                                   String>(
//                                                                 value: value,
//                                                                 child:
//                                                                     Text(value),
//                                                               );
//                                                             }).toList(),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                           ],
//                                         ),
//                                         if (SizeConfig.screenWidth! > 900)
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: SizeConfig.screenWidth! >
//                                                         900
//                                                     ? 50
//                                                     : 10),
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceEvenly,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceEvenly,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               top: 20.0),
//                                                       child: CustomTextField(
//                                                         title:
//                                                             "Total Course Fees",
//                                                         labelText: "1111",
//                                                         textEditingController:
//                                                             totalCourseFeesTextController,
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               top: 20.0),
//                                                       child: CustomTextField(
//                                                         title: "Paid Amount",
//                                                         labelText: "10000",
//                                                         textEditingController:
//                                                             paidAmountTextController,
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               top: 20.0),
//                                                       child: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceBetween,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           const Text(
//                                                             "Payment Status",
//                                                             style: TextStyle(
//                                                                 fontSize: 15,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                                 color: AppColorsInApp
//                                                                     .colorGrey),
//                                                           ),
//                                                           Container(
//                                                             width: 350,
//                                                             margin:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                               top: 10,
//                                                               bottom: 20,
//                                                             ),
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     left: 15),
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10),
//                                                               color:
//                                                                   AppColorsInApp
//                                                                       .colorWhite,
//                                                             ),
//                                                             child:
//                                                                 DropdownButton<
//                                                                     String>(
//                                                               value:
//                                                                   _selectedValueForPayment,
//                                                               elevation: 16,
//                                                               style: const TextStyle(
//                                                                   color: AppColorsInApp
//                                                                       .colorBlack1),
//                                                               underline:
//                                                                   Container(),
//                                                               onChanged: (String?
//                                                                   newValue) {
//                                                                 setState(() {
//                                                                   _selectedValueForPayment =
//                                                                       newValue!;
//                                                                 });
//                                                               },
//                                                               items: _dropdownItemsForPayment.map<
//                                                                   DropdownMenuItem<
//                                                                       String>>((String
//                                                                   value) {
//                                                                 return DropdownMenuItem<
//                                                                     String>(
//                                                                   value: value,
//                                                                   child: Text(
//                                                                       value),
//                                                                 );
//                                                               }).toList(),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         SaveButton(
//                                           onPRess: () {},
//                                           buttonText: "Update",
//                                           buttonColor:
//                                               AppColorsInApp.colorYellow,
//                                         ),
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 8.0),
//                                           child: SaveButton(onPRess: () {}),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         drawer: SizeConfig.screenWidth! < 900
//             ? const Drawer(
//                 child: ExtraSideBar(sidebarIndex: 10),
//               )
//             : null);
//   }
// }
