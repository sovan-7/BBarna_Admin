import 'package:bbarna/documents/pdf/viewModel/pdf_view_model.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/core/widgets/add_widget.dart';
import 'package:bbarna/core/widgets/custom_searchbar.dart';
import 'package:bbarna/utils/size_config.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:bbarna/documents/pdf/screen/add_pdf.dart';
import 'package:bbarna/documents/pdf/widgets/pdf_list_widget.dart';
import 'package:provider/provider.dart';

class PDFList extends StatefulWidget {
  const PDFList({super.key});

  @override
  State<PDFList> createState() => _PDFListState();
}

class _PDFListState extends State<PDFList> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    PdfViewModel pdfViewModel =
        Provider.of<PdfViewModel>(context, listen: false);
    pdfViewModel.getFirstPdfList();
    pdfViewModel.getPdfListLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double width = SizeConfig.screenWidth!;

    return Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 20,
        ),
        child: Consumer<PdfViewModel>(
          builder: (context, pdfDataProvider, child) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PDF LIST",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1.0,
                              color: AppColorsInApp.colorBlack1),
                        ),
                      ],
                    ),
                    AddWidget(
                      addCall: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddPdf()))
                            .whenComplete(() {
                          if (searchController.text.isEmpty) {
                            pdfDataProvider.getFirstPdfList();
                            pdfDataProvider.getPdfListLength();
                          }
                        });
                      },
                    )
                  ],
                ),
                CustomSearchBar(
                  textEditingController: searchController,
                  onChange: () {
                    pdfDataProvider.searchPdf(
                        searchText: searchController.text.toUpperCase());
                  },
                  onClear: () {
                    searchController.clear();
                    pdfDataProvider.searchPdf(
                        searchText: searchController.text);
                  },
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColorsInApp.colorGrey.withValues(alpha: .2)),
                    child: ListView.builder(
                        itemCount: pdfDataProvider.pdfList.length,
                        itemBuilder: (context, index) {
                          return SizeConfig.screenWidth! < 900
                              ? FittedBox(
                                  child: PdfListWidget(
                                  pdfData: pdfDataProvider.pdfList[index],
                                  index: index,
                                  onEdit: () {
                                  if (searchController.text.isEmpty) {
                                      pdfDataProvider.getFirstPdfList();
                                    }
                                  },
                                ))
                              : PdfListWidget(
                                  pdfData: pdfDataProvider.pdfList[index],
                                  index: index,
                                  onEdit: () {
                                    if (searchController.text.isEmpty) {
                                      pdfDataProvider.getFirstPdfList();
                                    }
                                  },
                                );
                        }),
                  ),
                ),
                if (pdfDataProvider.pdfListLength != 0 &&
                    searchController.text.isEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          searchController.clear();
                          if (pdfDataProvider.pdfList.length >
                              pdfDataProvider.limit) {
                            pdfDataProvider.removePdfFromLast();
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
                          "${pdfDataProvider.pdfList.length}/${pdfDataProvider.pdfListLength}",
                          style: const TextStyle(
                              color: AppColorsInApp.colorBlack1,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          searchController.clear();
                          if (pdfDataProvider.pdfListLength >
                              pdfDataProvider.pdfList.length) {
                            pdfDataProvider.getNextPdfList();
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
          },
        ));
  }
}
