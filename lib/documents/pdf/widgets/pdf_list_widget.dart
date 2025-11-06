// ignore_for_file: must_be_immutable

import 'package:bbarna/core/widgets/remove_alert.dart';
import 'package:bbarna/documents/pdf/model/pdf_model.dart';
import 'package:bbarna/documents/pdf/screen/edit_pdf.dart';
import 'package:bbarna/documents/pdf/viewModel/pdf_view_model.dart';
import 'package:bbarna/resources/constant.dart';
import 'package:bbarna/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bbarna/resources/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfListWidget extends StatelessWidget {
  final PdfModel pdfData;
  final int index;
  Function onEdit;
  PdfListWidget(
      {required this.pdfData,
      required this.index,
      required this.onEdit,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColorsInApp.colorWhite,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "${index + 1}.",
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0.5,
                    color: AppColorsInApp.colorBlack1),
              ),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () {
                  _launchUrl(pdfData.pdfLink);
                },
                child: Text(
                  pdfData.title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0.5,
                      color: AppColorsInApp.colorBlue),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Container(
                  height: 25,
                  width: 110,
                  alignment: Alignment.center,
                  //padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(
                      top: 5, left: 10, bottom: 5, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColorsInApp.colorYellow1),
                  child: FittedBox(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Code: ",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.5,
                                color: AppColorsInApp.colorBlack1),
                          ),
                          SelectableText(
                            pdfData.code,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.5,
                                color: AppColorsInApp.colorBlack1),
                          ),
                        ]),
                  ),
                ),
                Container(
                  width: 80,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: pdfData.pdfType.toLowerCase() == "free"
                          ? AppColorsInApp.colorSecondary!.withValues(alpha: .5)
                          : AppColorsInApp.colorPrimary.withValues(alpha: .5)),
                  child: Text(
                    pdfData.pdfType,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.5,
                        color: AppColorsInApp.colorBlack1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection(pdf)
                          .doc(pdfData.docId)
                          .update({
                        'is_locked': !pdfData.isLocked,
                      });
                    },
                    child: Icon(
                      pdfData.isLocked
                          ? Icons.lock_outline_rounded
                          : Icons.lock_open_outlined,
                      color: AppColorsInApp.colorPrimary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditPdf(pdfData: pdfData))).whenComplete(() {
                        onEdit();
                      });
                    },
                    child: Icon(
                      Icons.edit,
                      color: AppColorsInApp.colorYellow,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: InkWell(
                      onTap: () {
                        PdfViewModel pdfViewModel =
                            Provider.of<PdfViewModel>(context, listen: false);
                        RemoveAlert.showRemoveAlert(
                            title: pdfData.title.toString(),
                            description: "Are you sure want to delete ?",
                            onPressYes: () async {
                              await pdfViewModel
                                  .deletePdf(pdfData.docId)
                                  .whenComplete(() async {
                                Navigator.pop(context);
                                await pdfViewModel.getFirstPdfList();
                                await pdfViewModel.getPdfListLength();
                              });
                            });
                      },
                      child: const Icon(Icons.delete,
                          color: AppColorsInApp.colorPrimary)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchUrl(String pdfLink) async {
    try {
      await launchUrl(Uri.parse(pdfLink));
    } catch (e) {
      Helper.showSnackBarMessage(
          msg: "Sorry something went wrong", isSuccess: false);
    }
  }
}
