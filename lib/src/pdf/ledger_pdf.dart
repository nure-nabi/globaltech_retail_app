// import 'dart:io';
// import 'dart:typed_data';
// import 'package:nepali_utils/nepali_utils.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart';
// import 'package:retail_app/src/ledgerReport/model/ledger_report_model.dart';
// import 'package:retail_app/src/login/model/login_model.dart';
// import '../../utils/utils.dart';
//
//
// double myCellHeight = 20;
//
// Future<Uint8List> generateInvoice({
//   ///
//   List<LedgerReportDataModel>? ledgerReportList,
//
//   ///
//   required CompanyDetailsModel companyDataDetails,
//   required String clientName,
//   required String totalBalance,
//   required String? totalDebit,
//   required String? totalCredit,
//   required String fileName,
//   bool showEnglishDate = false,
// }) async {
//   final invoice = Invoice(
//     ledgerReportList: ledgerReportList ?? [],
//
//     ///
//     baseColor: PdfColors.orangeAccent,
//     accentColor: PdfColors.blueGrey900,
//     companyDataDetails: companyDataDetails,
//     clientName: clientName,
//     totalBalance: totalBalance,
//     totalDebit: totalDebit,
//     totalCredit: totalCredit,
//     fileName: fileName,
//     showEnglishDate: showEnglishDate,
//   );
//
//   return await invoice.buildPdf(PdfPageFormat.a4);
// }
//
// class Invoice {
//   Invoice({
//     ///
//     required this.ledgerReportList,
//
//     ///
//     required this.baseColor,
//     required this.accentColor,
//     required this.companyDataDetails,
//     required this.clientName,
//     required this.totalDebit,
//     required this.totalCredit,
//     required this.totalBalance,
//     required this.fileName,
//     required this.showEnglishDate,
//   });
//
//   final List<LedgerReportDataModel> ledgerReportList;
//
//   ///
//   late CompanyDetailsModel companyDataDetails;
//   late String clientName, totalBalance, fileName;
//   late String? totalDebit, totalCredit;
//
//   final PdfColor baseColor;
//   final PdfColor accentColor;
//   final bool showEnglishDate;
//
//   Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
//     final doc = Document();
//
//     doc.addPage(
//       MultiPage(
//         footer: _buildFooter,
//         build: (context) => [
//           _buildHeader(context),
//
//           ///
//           _contentTrialTable(context, showEnglishDate),
//
//           ///
//           SizedBox(height: 20),
//
//           ///
//           _contentBalanceFooter(context),
//         ],
//       ),
//     );
//
//     var bytes = doc.save();
//
//     Directory directory = (await getApplicationDocumentsDirectory());
//     String path = directory.path;
//     File file = File('$path/$fileName.pdf');
//     await file.writeAsBytes(List.from(await bytes), flush: true);
//
//     OpenFilex.open('$path/$fileName.pdf');
//     // Share.shareFiles(["$path/$fileName.pdf"], text: "Ledger");
//
//     return doc.save();
//   }
//
//   Widget _buildFooter(Context context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Container(
//           child: Text("Copyright ©.All Rights Reserved to Global Tech"),
//         ),
//         Text(
//           '${context.pageNumber}/${context.pagesCount}',
//           style: const TextStyle(
//             fontSize: 12,
//             color: PdfColors.black,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildHeader(Context context) {
//     return Column(
//       children: [
//         Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.only(left: 20.0),
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 companyDataDetails.companyName,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: baseColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//             // Container(
//             //   margin: const EdgeInsets.only(left: 20.0),
//             //   alignment: Alignment.centerLeft,
//             //   child: Text(
//             //     "${companyDataDetails.companyAddress} \nContact: ${companyDataDetails.phoneNo}",
//             //     style: TextStyle(
//             //       color: PdfColors.black,
//             //       fontWeight: FontWeight.bold,
//             //       fontSize: 13,
//             //     ),
//             //   ),
//             // ),
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 10.0),
//               width: double.infinity,
//               height: 0.5,
//               color: PdfColors.grey.shade(0.2),
//             ),
//             Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(left: 20.0),
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       clientName,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: baseColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Day : ${MyDate.getWeekName(weekId: "${NepaliDateTime.now().weekday}")}",
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: PdfColors.black,
//                             fontSize: 13,
//                           ),
//                         ),
//                         Text(
//                           'Date : ${NepaliDateTime.now().toString().substring(0, 10).replaceAll("-", "/")}',
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: PdfColors.black,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ]),
//                 ]),
//             SizedBox(height: 10.0),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _contentBalanceFooter(Context context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: 10.0),
//         Text(
//           'Total Debit Amt : $totalDebit',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 10.0),
//         Text(
//           'Total Credit Amt : $totalCredit',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 5.0),
//         Container(
//           margin: const EdgeInsets.symmetric(vertical: 10.0),
//           width: 200,
//           height: 0.5,
//           color: PdfColors.grey.shade(0.2),
//         ),
//         SizedBox(height: 5.0),
//         Text(
//           'Total Balance : ${double.parse(totalBalance).toStringAsFixed(2)}',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _contentTrialTable(Context context, bool showEnglishDate) {
//     final tableHeaders = [
//       showEnglishDate ? 'Date' : 'Miti',
//       'Voucher No',
//       'DR',
//       'CR',
//       'Balance'
//     ];
//
//     return TableHelper.fromTextArray(
//       border: null,
//       cellAlignment: Alignment.centerLeft,
//       headerDecoration: BoxDecoration(
//         borderRadius: const BorderRadius.all(Radius.circular(2)),
//         color: baseColor,
//       ),
//       headerHeight: 25,
//       cellHeight: myCellHeight,
//       cellAlignments: {
//         0: Alignment.centerLeft,
//         1: Alignment.center,
//         2: Alignment.centerRight,
//         3: Alignment.centerRight,
//         4: Alignment.centerRight,
//       },
//       headerStyle: TextStyle(
//         fontSize: 10,
//         fontWeight: FontWeight.bold,
//       ),
//       cellStyle: const TextStyle(
//         fontSize: 10,
//       ),
//       rowDecoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: accentColor,
//             width: .5,
//           ),
//         ),
//       ),
//       headers: List<String>.generate(
//         tableHeaders.length,
//             (col) => tableHeaders[col],
//       ),
//       data: List<List<String>>.generate(
//         ledgerReportList.length,
//             (row) => List<String>.generate(
//           tableHeaders.length,
//               (col) => ledgerReportList[row].getIndex(col, showEnglishDate),
//         ),
//       ),
//     );
//   }
// }
