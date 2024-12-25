import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;

import 'package:nepali_utils/nepali_utils.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import '../../utils/utils.dart';
import '../ledger_report_party_bill/model/ledger_report_model.dart';

double myCellHeight = 20;

Future<Uint8List> generateVendorLedgerReport({
  List<LedgerReportModel>? purchaseLedgerReport,
  required CompanyDetailsModel companyDataDetails,
  required String vno,
  required String date,
  required String? miti,
  required String? source,
  required String dr,
  required String cr,
  required String narration,
  required String remarks,
  bool showEnglishDate = false,
}) async {
  final invoice = Invoice(
    purchaseLedgerReport: purchaseLedgerReport ?? [],
    baseColor: PdfColors.orangeAccent,
    accentColor: PdfColors.blueGrey900,
    companyDataDetails: companyDataDetails,
    vno: vno,
    date: date,
    miti: miti,
    source: source,
    dr: dr,
    cr: cr,
    narration: narration,
    remarks: remarks,
    fileName: '',
    showEnglishDate: showEnglishDate,
  );

  return await invoice.buildPdf(PdfPageFormat.a4);
}

class Invoice {
  Invoice({
    required this.purchaseLedgerReport,
    required this.baseColor,
    required this.accentColor,
    required this.companyDataDetails,
    required this.vno,
    required this.date,
    required this.miti,
    required this.source,
    required this.dr,
    required this.cr,
    required this.narration,
    required this.remarks,
    required this.fileName,
    required this.showEnglishDate,
  });

  final List<LedgerReportModel> purchaseLedgerReport;

  ///
  late CompanyDetailsModel companyDataDetails;
  late String vno, date, dr, cr;
  late String? source, miti, narration, fileName, remarks;

  final PdfColor baseColor;
  final PdfColor accentColor;
  final bool showEnglishDate;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    final doc = Document();

    doc.addPage(
      MultiPage(
        footer: _buildFooter,
        build: (context) => [
          _buildHeader(context),

          ///
          _contentTrialTable(context, showEnglishDate),

          // _contentBalanceFooter(context),
          SizedBox(height: 25.0),
          RichText(
              text: TextSpan(
                  text: 'Print Date and Time : ',
                  style: const TextStyle(),
                  children: [
                    TextSpan(
                        text:
                        " ${NepaliDateTime.now().format("yyyy/MM/dd h:mm a").toUpperCase()}",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ])),
        ],
      ),
    );

    var bytes = doc.save();

    Directory directory = (await getApplicationDocumentsDirectory());
    String path = directory.path;
    File file = File('$path/$fileName.pdf');
    await file.writeAsBytes(List.from(await bytes), flush: true);
    OpenFilex.open('$path/$fileName.pdf');
    // Share.shareFiles(["$path/$fileName.pdf"], text: "Ledger");

    return doc.save();
  }

  Widget _buildFooter(Context context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          child: Text("Copyright ©.All Rights Reserved to Global Tech"),
        ),
        Text(
          '${context.pageNumber}/${context.pagesCount}',
          style: const TextStyle(
            fontSize: 12,
            color: PdfColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Context context) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              alignment: Alignment.centerLeft,
              child: Text(
                companyDataDetails.companyName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: baseColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              alignment: Alignment.centerLeft,
              child: Text(
                companyDataDetails.companyAddress,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: baseColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              alignment: Alignment.centerLeft,
              child: Text(
                companyDataDetails.vatNo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: baseColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              width: double.infinity,
              height: 0.5,
              color: PdfColors.black.shade(0.2),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ledger Report',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: baseColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Day : ${MyDate.getWeekName(weekId: "${NepaliDateTime.now().weekday}")}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: PdfColors.black,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Date : ${NepaliDateTime.now().toString().substring(0, 10).replaceAll("-", "/")}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: PdfColors.black,
                            fontSize: 13,
                          ),
                        ),
                      ]),
                ]),
            SizedBox(height: 10.0),
          ],
        ),
      ],
    );
  }

  // Widget _contentBalanceFooter(Context context) {
  //   double drAmt = 0;
  //   double crAmt = 0;
  //   for (int i = 0; i < purchaseLedgerReport.length; i++) {
  //     drAmt += double.parse(purchaseLedgerReport[i].dr) ?? 0;
  //     crAmt += double.parse(purchaseLedgerReport[i].cr) ?? 0;
  //   }
  //   double totalNetAmount = (drAmt - crAmt);
  //   int totalAmountWord = totalNetAmount.toInt();
  //   // int totalAmountWord = int.parse(totalNetAmount.toString().split(".").first);
  //   return Container(
  //     padding: const EdgeInsets.only(right: 0),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: PdfColor.fromHex("#000000")),
  //     ),
  //     // alignment: Alignment.centerRight,
  //     child: Column(
  //         // crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           // SizedBox(height: 5),
  //           pw.Container(
  //             // color: PdfColors.pink,
  //             height: 15,
  //             child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 //  crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: [
  //                   Container(
  //                     // color: PdfColors.blue,
  //                     width: 40,
  //                     child: Text("Total:",
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                         )),
  //                   ),
  //                   Container(width: 1, color: PdfColors.black, height: 20),
  //                   Container(
  //                     width: 75,
  //                     child: pw.Text(drAmt.toStringAsFixed(2),
  //                         textAlign: pw.TextAlign.right,
  //                         //  overflow: TextOverflow.clip,
  //                         style: pw.TextStyle(
  //                           fontSize: 10,
  //                           fontWeight: FontWeight.bold,
  //                         )),
  //                   ),
  //                   Container(width: 1, color: PdfColors.black, height: 20),
  //                   Container(
  //                     width: 75,
  //                     child: pw.Text(crAmt.toStringAsFixed(2),
  //                         textAlign: pw.TextAlign.right,
  //                         style: pw.TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 10,
  //                         )),
  //                   ),
  //                   Container(width: 1, color: PdfColors.black, height: 20),
  //                   Container(
  //                     width: 75.6,
  //                     child: pw.Text(totalNetAmount.toStringAsFixed(2),
  //                         textAlign: pw.TextAlign.right,
  //                         style: TextStyle(
  //                           fontSize: 10,
  //                           fontWeight: FontWeight.bold,
  //                         )),
  //                   )
  //                 ]),
  //           ),
  //           pw.Container(color: PdfColors.black, width: 500, height: 1),
  //           Row(
  //             children: [
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   pw.Padding(
  //                       padding: const pw.EdgeInsets.only(
  //                           left: 10, top: 2, bottom: 2),
  //                       child: RichText(
  //                         text: TextSpan(
  //                           text: 'In Word: ',
  //                           style: const TextStyle(),
  //                           children: [
  //                             TextSpan(
  //                               text:
  //                                   "${NumberToWordsEnglish.convert(totalAmountWord).toFirstLetterCapital()} only.",
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.normal,
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       )),
  //                 ],
  //               )
  //             ],
  //           )
  //         ]),
  //   );
  // }

  Widget _contentTrialTable(Context context, bool showEnglishDate) {
    final tableHeaders = [
      'Voucher No',
      showEnglishDate ? 'Date' : 'Miti',
      'Miti',
      'Dr Amount',
      'Cr Amount',
      'Balance',
    ];

    return TableHelper.fromTextArray(
      headers: ['S.No.'] + tableHeaders,
      cellAlignment: Alignment.centerLeft,
      headerDecoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: myCellHeight,
      columnWidths: {
        0: const FlexColumnWidth(1),
        1: const FlexColumnWidth(1),
        2: const FlexColumnWidth(1),
        3: const FlexColumnWidth(1),
        4: const FlexColumnWidth(1.2),
        5: const FlexColumnWidth(1.2),
        6: const FlexColumnWidth(1.2),
      },
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
      },
      headerStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      // headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      border: TableBorder.symmetric(
        inside: const BorderSide(width: 1),
        outside: const BorderSide(width: 1),
      ),
      cellStyle: const TextStyle(
        fontSize: 10,
      ),
      rowDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),

      // data: List<List<String>>.generate(
      //   salesLedgerReport.length,
      //       (row) => List<String>.generate(
      //     tableHeaders.length,
      //         (col) => salesLedgerReport[row].getIndex(col,salesLedgerReport),
      //   ),
      // ),
      data: List<List<String>>.generate(
        purchaseLedgerReport.length,
            (row) {
          List<String> rowData = List<String>.generate(
            tableHeaders.length,
                (col) =>
                purchaseLedgerReport[row].getIndex(col, purchaseLedgerReport),
          );
          rowData.insert(0, '${row + 1}');
          return rowData;
        },
      )
          .where((rowData) => rowData.skip(1).any((value) => value != "0.0"))
          .toList(),
    );
  }
}