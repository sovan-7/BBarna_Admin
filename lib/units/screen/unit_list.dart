import 'package:bbarna/units/viewModel/unit_view_model.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/core/widgets/add_widget.dart';
import 'package:bbarna/core/widgets/custom_searchbar.dart';
import 'package:bbarna/utils/size_config.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/units/screen/add_unit.dart';
import 'package:bbarna/units/widgets/unit_card.dart';
import 'package:provider/provider.dart';

class UnitList extends StatefulWidget {
  const UnitList({super.key});

  @override
  State<UnitList> createState() => _UnitListState();
}

class _UnitListState extends State<UnitList> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    UnitViewModel unitViewModel =
        Provider.of<UnitViewModel>(context, listen: false);
    unitViewModel.getFirstUnitList();
    unitViewModel.getUnitListLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UnitViewModel>(builder: (context, unitDataProvider, child) {
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
                  "UNIT LIST",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1.0,
                      color: AppColorsInApp.colorBlack1),
                ),
                Row(
                  children: [
                    // InkWell(
                    //   onTap: () {
                    //     unitDataProvider.changeVisibility();
                    //   },
                    //   child: const Icon(
                    //     Icons.delete,
                    //     color: AppColorsInApp.colorPrimary,
                    //     size: 25,
                    //   ),
                    // ),
                    // const SizedBox(width: 20,),
                    AddWidget(
                      addCall: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddUnit()))
                            .whenComplete(() async {
                          if (searchController.text.isEmpty) {
                            await unitDataProvider.getFirstUnitList();
                            await unitDataProvider.getUnitListLength();
                          }
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
            CustomSearchBar(
              onChange: () {
                unitDataProvider.searchUnit(
                    searchText: searchController.text.toUpperCase());
              },
              onClear: () {
                searchController.clear();
                unitDataProvider.searchUnit(searchText: searchController.text);
              },
              textEditingController: searchController,
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
                    color: Colors.grey.withValues(alpha: .2)),
                child: ListView.builder(
                    itemCount: unitDataProvider.unitList.length,
                    itemBuilder: (context, index) {
                      return SizeConfig.screenWidth! < 900
                          ? FittedBox(
                              child: UnitCard(
                              unitData: unitDataProvider.unitList[index],
                              onDelete: () {
                                if (searchController.text.isEmpty) {
                                  unitDataProvider.getFirstUnitList();
                                }
                              },
                              onEdit: () {
                                if (searchController.text.isEmpty) {
                                  unitDataProvider.getFirstUnitList();
                                }
                              },
                              onChangeLock: () {
                                if (searchController.text.isEmpty) {
                                  unitDataProvider.getFirstUnitList();
                                }
                              },
                            ))
                          : UnitCard(
                              unitData: unitDataProvider.unitList[index],
                              onChangeLock: () {
                                if (searchController.text.isEmpty) {
                                  unitDataProvider.getFirstUnitList();
                                }
                              },
                              onDelete: () {
                                if (searchController.text.isEmpty) {
                                  unitDataProvider.getFirstUnitList();
                                }
                              },
                              onEdit: () {
                                if (searchController.text.isEmpty) {
                                  unitDataProvider.getFirstUnitList();
                                }
                              },
                            );
                    }),
              ),
            ),
            if (unitDataProvider.unitLength != 0 &&
                searchController.text.isEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      searchController.clear();
                      if (unitDataProvider.unitList.length >
                          unitDataProvider.limit) {
                        unitDataProvider.removeUnitFromLast();
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
                      "${unitDataProvider.unitList.length}/${unitDataProvider.unitLength}",
                      style: const TextStyle(
                          color: AppColorsInApp.colorBlack1,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      searchController.clear();
                      if (unitDataProvider.unitLength >
                          unitDataProvider.unitList.length) {
                        unitDataProvider.getNextUnitList();
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
        ),
      );
    });
  }
}
