// ignore_for_file: use_build_context_synchronously

import 'package:bbarna/banners/screen/add_banner.dart';
import 'package:bbarna/banners/viewModel/banners_viewmodel.dart';
import 'package:bbarna/core/widgets/add_widget.dart';
import 'package:bbarna/core/widgets/loader_dialog.dart';
import 'package:bbarna/core/widgets/remove_alert.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BannerList extends StatefulWidget {
  const BannerList({super.key});

  @override
  State<BannerList> createState() => _BannerListState();
}

class _BannerListState extends State<BannerList> {
  @override
  void initState() {
    BannersViewModel bannersViewModel =
        Provider.of<BannersViewModel>(context, listen: false);
    bannersViewModel.getBannerList();
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
      child: Consumer<BannersViewModel>(
          builder: (context, bannerDataProvider, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "BANNER LIST",
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
                                  builder: (context) => const AddBanner()))
                          .whenComplete(() {
                        bannerDataProvider.getBannerList();
                      });
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                ),
                padding: const EdgeInsets.all(8.0), // padding around the grid
                itemCount: bannerDataProvider
                    .bannersList.length, // total number of items
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(bannerDataProvider
                                  .bannersList[index].bannerImage),
                              fit: BoxFit.fill,
                            )),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: () async {
                            RemoveAlert.showRemoveAlert(
                                title: "Banner Image",
                                description: "Are you sure want to delete ?",
                                onPressYes: () async {
                                  LoaderDialogs.showLoadingDialog();
                                  await bannerDataProvider
                                      .deleteBanner(bannerDataProvider
                                          .bannersList[index].docId)
                                      .then((value) async {
                                    Navigator.pop(context);
                                    await bannerDataProvider.getBannerList();
                                    Navigator.pop(context);
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
                  );
                },
              ),
            )
          ],
        );
      }),
    );
  }
}
