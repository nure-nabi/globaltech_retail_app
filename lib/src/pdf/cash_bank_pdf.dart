import 'dart:io';

import 'package:nepali_date_picker/nepali_date_picker.dart';


import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/utils/number_to_words.dart';
import 'package:retail_app/utils/text_formatter.dart';

import 'bill_pdf.dart';

class CashBankPdfInvoiceApi {
  static Future<File> generate({
    required CompanyDetailsModel companyDetails,
    required String billTitleName,
    required String receivedNo,
    required String date,
    required String receivedFrom,
    required double recAmount,
    required double payAmount,
    required String remarks,
    required String receivedBy,
  }) async {
    final pdf = Document();

    /// ================================================

    Widget dataValue({
      required String title,
      required String value,
      bool? isBold = false,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                "$title ",
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight:
                  isBold == true ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Flexible(child: Text(":")),
            Expanded(
              flex: 3,
              child: Text(
                " $value",
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight:
                  isBold == true ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildHeader({
      required String companyName,
      required String address,
      required String companyPanNo,
    }) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        // Image(MemoryImage(iconImage), height: 50, width: 50),
        Column(children: [
          Text(companyName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              )),
          Text(address,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
              )),
          Text(companyPanNo,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
              )),
        ]),
      ]);
    }

    Widget buildFooter(Context context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Text("Copyright ©.All Rights Reserved to Global Tech"),
          ),
          Text(
            'Page No.:${context.pageNumber}/${context.pagesCount}',
            style: const TextStyle(
              fontSize: 12,
              color: PdfColors.black,
            ),
          ),
        ],
      );
    }

    pdf.addPage(
      MultiPage(
        footer: (context) => buildFooter(context),
        build: (context) {
          return [
            buildHeader(
              companyPanNo: "",
              address: "",
              companyName: companyDetails.companyName,
            ),
            SizedBox(height: 10.0),
            Divider(),
            Center(child: Text(billTitleName)),
            Divider(),

            ///
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: PdfColor.fromHex("#000000")),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  dataValue(title: "Received No", value: " $receivedNo"),
                  dataValue(title: "Date", value: " $date"),
                  SizedBox(height: 10.0),
                  // dataValue(title: "Bank Name", value: " $bankName"),
                  // dataValue(title: "Cheque No", value: " $chequeNo"),
                  // dataValue(title: "Cheque Date", value: " $chequeDate"),
                  // SizedBox(height: 10.0),
                  dataValue(
                    title: "Received From",
                    value: " $receivedFrom",
                    isBold: true,
                  ),
                  if (recAmount != 0.00) ...[
                    dataValue(
                      title: "Rec Amount",
                      value: " $recAmount",
                      isBold: true,
                    ),
                    dataValue(
                      title: "In Words",
                      value:
                      "${NumberToWordsEnglish.convert(recAmount.toInt()).toFirstLetterCapital()} only.",
                    ),
                  ],

                  if (payAmount != 0.00) ...[
                    dataValue(
                      title: "Pay Amount",
                      value: " $payAmount",
                      isBold: true,
                    ),
                    dataValue(
                      title: "In Words",
                      value:
                      "${NumberToWordsEnglish.convert(payAmount.toInt()).toFirstLetterCapital()} only.",
                    ),
                  ],
                  dataValue(title: "Remarks", value: " $remarks"),
                  SizedBox(height: 15.0),
                  dataValue(title: "Received By", value: " $receivedBy"),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            ////
            RichText(
              text: TextSpan(
                text: 'Print Date and Time : ',
                style: const TextStyle(),
                children: [
                  TextSpan(
                    text:
                    " ${NepaliDateTime.now().format("yyyy/MM/dd h:mm a").toUpperCase()}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ];
        },
      ),
    );

    return FileHandleApi.saveDocument(name: 'cash_bank.pdf', pdf: pdf);
  }
}
