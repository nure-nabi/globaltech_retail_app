import 'dart:io';

import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:retail_app/src/bill_report/model/bill_report_model.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/sales_bill_report/model/sales_bill_report_model.dart';

import '../../utils/utils.dart';

class FileHandleApiPurchase {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  // open pdf file function
  static Future openFile(File file) async {
    final url = file.path;
    await OpenFilex.open(url);
  }
}

class PdfInvoiceApiPurchase{
  static Future<File> generate({
    required CompanyDetailsModel companyDetails,
    required String billTitleName,
    required String vNo,
    required String customer,
    required String address,
    required String phone,
    required String panNo,
    required String date,
    required String miti,
    required String totalNetAmount,
    required String totalTermAmount,
    required String balanceAmt,
    required double totalAmount,
    required String dpDesc,
    required List<PurchaseReportDataModel> dataList,

  }) async {
    final pdf = Document();

    int totalAmountWord = int.parse(totalNetAmount.toString().split(".").first);


    Widget dataValue({required String title, required String value}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Row(children: [
          Flexible(
              child: Text(
                "$title ",
                style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold,color: PdfColors.orangeAccent),
              )),
          Flexible(
              child: Text(
                " $value",
                style: const TextStyle(fontSize: 13.0,color: PdfColors.orangeAccent),
              )),
        ]),
      );
    }

    // final iconImage =
    // (await rootBundle.load('images/app_icon.png')).buffer.asUint8List();

    final tableHeaders = [

      'Particular',
      'Unit',
      'Qty',
      'Rate',
      'Term Amt',
      'Net Amt',
    ];

    Widget buildHeader(
        {required String companyName,
          required String address,
          required String companyPanNo}) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        // Image(MemoryImage(iconImage), height: 50, width: 50),
        Column(children: [
          Text(companyName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: PdfColors.orangeAccent
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
        // header: (context) =>
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
            Center(child: Text(billTitleName,style: TextStyle(fontWeight: FontWeight.bold,color: PdfColors.orangeAccent))),
            Divider(),
            Row(children: [
              Expanded(
                child: RichText(
                    text: TextSpan(
                        text: 'Voucher No ',
                        style: TextStyle(fontWeight: FontWeight.bold,color: PdfColors.orangeAccent),
                        children:  [
                          TextSpan(text: vNo.toString(), style: TextStyle())
                        ])),
              ),
              Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                        text: TextSpan(
                            text: 'Date : ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(text: "$date ($miti)", style: const TextStyle())
                            ])),
                  )),
            ]),

            SizedBox(height: 5.0),
            RichText(
                text: TextSpan(
                    text: 'Vendor : ',
                    style: TextStyle(fontWeight: FontWeight.bold,color: PdfColors.orangeAccent),
                    children: [
                      TextSpan(text: customer, style: const TextStyle())
                    ])),

            if (address.isNotEmpty)dataValue(title: "Address:", value: address),
            if (phone.isNotEmpty) dataValue(title: "Phone:", value: phone),
            if (panNo.isNotEmpty) dataValue(title: "PAN No.:", value: panNo),
            SizedBox(height: 10.0),

            ///
            /// PDF Table Create
            TableHelper.fromTextArray(
                headers: ['S.No.'] +tableHeaders,
                // data: List<List<String>>.generate(
                //   dataList.length,
                //       (row) => List<String>.generate(
                //     tableHeaders.length,
                //         (col) => dataList[row].getIndex(col),
                //   ),
                // ),
                data: List<List<String>>.generate(
                  dataList.length,
                      (row) {
                    List<String> rowData = List<String>.generate(
                      tableHeaders.length,
                          (col) => dataList[row].getIndex(col),
                    );
                    rowData.insert(0, '${row + 1}');
                    return rowData;
                  },
                ).where((rowData) => rowData.skip(1).any((value) => value != "0.0")).toList(),
                border: TableBorder.symmetric(
                  inside: const BorderSide(width: 1),
                  outside: const BorderSide(width: 1),
                ),
                headerStyle: TextStyle(fontWeight: FontWeight.bold),
                headerDecoration: const BoxDecoration(color: PdfColors.orangeAccent),
                cellHeight: 30.0,
                columnWidths: {
                  0: const FlexColumnWidth(1),
                  1: const FlexColumnWidth(2),
                  2: const FlexColumnWidth(.9),
                  3: const FlexColumnWidth(.9),
                  4: const FlexColumnWidth(1),
                  5: const FlexColumnWidth(1.3),
                 // 7: const FlexColumnWidth(1.5),
                },

                cellAlignments: {
                  0: Alignment.center,
                  1: Alignment.centerLeft,
                  2: Alignment.center,
                  3: Alignment.center,
                  4: Alignment.centerRight,
                  5: Alignment.centerRight,
                //  6: Alignment.centerRight,
                //  7: Alignment.centerRight,
                }),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: PdfColor.fromHex("#000000")),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
              //  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 5.0, bottom: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'In Word: ',
                              style: const TextStyle(),
                              children: [
                                TextSpan(
                                  text:
                                  "${NumberToWordsEnglish.convert(totalAmountWord).toFirstLetterCapital()} only.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50.0,
                    width: 1.0,
                    color: PdfColor.fromHex("#000000"),
                  ),
                  SizedBox(width: 24.0),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(
                                child: Text(
                                  'Total : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Text(totalAmount.toStringAsFixed(2),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ]),
                          Row(children: [
                            Expanded(
                                child: Text(
                                  'Term Amt : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Text(totalTermAmount,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ]),
                          Row(children: [
                            Expanded(
                                child: Text(
                                  'Net Total : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Text(totalNetAmount,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ]),
                          // Row(children: [
                          //   Expanded(
                          //       child: Text(
                          //     'Term Amount:',
                          //     style: TextStyle(fontWeight: FontWeight.bold),
                          //   )),
                          //   Text(totalTermAmount,
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //       )),
                          // ]),
                          // Row(children: [
                          //   Expanded(
                          //       child: Text(
                          //     'Net Amount:',
                          //     style: TextStyle(fontWeight: FontWeight.bold),
                          //   )),
                          //   Text(totalNetAmount,
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //       )),
                          // ]),
                          // Divider(),
                          // Row(children: [
                          //   Expanded(
                          //       child: Text(
                          //     'Total:',
                          //     style: TextStyle(fontWeight: FontWeight.bold),
                          //   )),
                          //   Text("$totalBalance.00"),
                          // ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // int.parse(
            // "${double.parse(totalTermAmount) + double.parse(totalNetAmount)}")
            SizedBox(height: 25.0),
            // SizedBox(height: 10.0),
            RichText(
                text: TextSpan(
                    text: 'Your current Due(s) : ',
                    style: const TextStyle(),
                    children: [
                      TextSpan(
                          text: balanceAmt,
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ])),
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
          ];
        },
      ),
    );

    return FileHandleApiPurchase.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }
}
