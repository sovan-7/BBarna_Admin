// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:bbarna/utils/size_config.dart';
import 'package:bbarna/resources/app_colors.dart';

class TopicTable extends StatelessWidget {
  String? topicText;
  String? topicName;
  Function onAdd;
  Function onRemove;
  Function onSave;
  Function onChanged;
  List<TextEditingController> controllerList;
  TopicTable(
      {required this.topicText,
      required this.topicName,
      required this.onAdd,
      required this.onRemove,
      required this.onSave,
      required this.onChanged,
      required this.controllerList,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.only(top: 1, bottom: 1, left: 5),
          color: AppColorsInApp.colorLightBlue,
          child: Row(
            children: [
              Text(
                "$topicText: ",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: AppColorsInApp.colorBlack1),
              ),
              Text(
                "$topicName -",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Color(0xFFFF68B4)),
              ),
            ],
          ),
        ),

        Row(
          children: [
            Expanded(
              child: Container(
                width: SizeConfig.screenWidth!,
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 10,
                  bottom: 10,
                ),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 1,
                  color: AppColorsInApp.colorGrey,
                )),
                child: Text(
                  "$topicText Code",
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: AppColorsInApp.colorBlack1),
                ),
              ),
            ),
          ],
        ),

        /// Dynamic text fields
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(controllerList.length, (index) {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                            width: 1, color: AppColorsInApp.colorGrey),
                        right: BorderSide(
                            width: 1, color: AppColorsInApp.colorGrey),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColorsInApp.colorWhite,
                      ),
                      child: TextField(
                        controller: controllerList[index],
                        onChanged: (value) {
                          onChanged(value);
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: AppColorsInApp.colorGrey)),
                          labelText: "$topicText Code",
                          labelStyle: const TextStyle(
                              color: AppColorsInApp.colorGrey, fontSize: 12),
                          contentPadding: const EdgeInsets.only(
                            left: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    width: 100,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                width: 1, color: AppColorsInApp.colorGrey))),
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 40,
                        color: AppColorsInApp.colorPrimary,
                      ),
                      onPressed: () {
                        onRemove(index);
                      },
                    )),
              ],
            );
          }),
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
              border: controllerList.isNotEmpty
                  ? Border.all(width: 1, color: AppColorsInApp.colorGrey)
                  : const Border(
                      bottom:
                          BorderSide(width: 1, color: AppColorsInApp.colorGrey),
                      left:
                          BorderSide(width: 1, color: AppColorsInApp.colorGrey),
                      right:
                          BorderSide(width: 1, color: AppColorsInApp.colorGrey),
                    )),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  onAdd();
                },
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColorsInApp.colorBlue,
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Add more line",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: AppColorsInApp.colorWhite),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  onSave();
                },
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColorsInApp.colorSecondary,
                  ),
                  child: const Text(
                    "Save all",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: AppColorsInApp.colorWhite),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
