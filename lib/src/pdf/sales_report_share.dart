import 'dart:io';
import 'dart:typed_data';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/salesreport/model/sales_report_model.dart';
import '../../utils/utils.dart';

double myCellHeight = 20;

Future<Uint8List> generateSalesInvoice({
  ///
  List<SalesDataModel>? salesReportList,

  ///
  required CompanyDetailsModel companyDataDetails,
  required String billDate,
  required String billNo,
  required String? glDesc,
  required String? salesType,
  required String netAmount,
  bool showEnglishDate = false,
}) async {
  final invoice = Invoice(
    salesReportList: salesReportList ?? [],
    baseColor: PdfColors.orangeAccent,
    accentColor: PdfColors.blueGrey900,
    companyDataDetails: companyDataDetails,
    billDate: billDate,
    billNo: billNo,
    glDesc: glDesc,
    salesType: salesType,
    netAmount: netAmount,
    fileName: '',
    showEnglishDate: showEnglishDate,
  );

  return await invoice.buildPdf(PdfPageFormat.a4);
}

class Invoice {
  Invoice({
    required this.salesReportList,
    required this.baseColor,
    required this.accentColor,
    required this.companyDataDetails,
    required this.billDate,
    required this.billNo,
    required this.glDesc,
    required this.salesType,
    required this.netAmount,
    required this.fileName,
    required this.showEnglishDate,
  });

  double calculateTotalNetAmount() {
    double totalNetAmount = 0.0;
    for (var sale in salesReportList) {
      totalNetAmount += double.parse(sale.netAmount.toString()); // Parse netAmount for each sale
    }
    return totalNetAmount;
  }

  final List<SalesDataModel> salesReportList;

  ///
  late CompanyDetailsModel companyDataDetails;
  late String billDate, billNo, netAmount;
  late String? salesType, glDesc, fileName;

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
          _contentBalanceFooter(context),
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
                  color: PdfColors.orangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              width: double.infinity,
              height: 0.5,
              color: PdfColors.grey.shade(0.2),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sales Report',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PdfColors.orangeAccent,
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

  Widget _contentBalanceFooter(Context context) {
    double totalNetAmount = calculateTotalNetAmount();
    int totalAmountWord = int.parse(totalNetAmount.toString().split(".").first);
    return  Container(
      padding: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        border: Border.all(color: PdfColor.fromHex("#000000")),
      ),
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

            Text("Total:          ", textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold)),
                // Container(
                //   margin: const EdgeInsets.only(right: 100),
                //   height: 20.0,
                //   width: 1.0,
                //   color: PdfColor.fromHex("#000000"),
                // ),
            Text(
              textAlign: TextAlign.end,
              totalNetAmount.toStringAsFixed(2),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

          ]),

          Divider(),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, top: 0.0, bottom: 5.0),
            child: RichText(
              textAlign: TextAlign.start,
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
          ),
        ],
      ),
    );

    //   Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     SizedBox(height: 10.0),
    //     Text(
    //       'Total Sales Amt : $totalNetAmount',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //
    //     SizedBox(height: 5.0),
    //     Container(
    //       margin: const EdgeInsets.symmetric(vertical: 10.0),
    //       width: 200,
    //       height: 0.5,
    //       color: PdfColors.grey.shade(0.2),
    //     ),
    //     SizedBox(height: 5.0),
    //     Text(
    //       '',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget _contentTrialTable(Context context, bool showEnglishDate) {
    final tableHeaders = [
      showEnglishDate ? 'Date':'Miti',
      'Voucher No',
      'Party',
      'Sales Type',
      'Amount'
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
        2: const FlexColumnWidth(1.3),
        3: const FlexColumnWidth(1),
        4: const FlexColumnWidth(1),
      },
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerRight,
      },
      headerStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
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
      data: List<List<String>>.generate(
        salesReportList.length,
            (row) {
          List<String> rowData = List<String>.generate(
            tableHeaders.length,
                (col) => salesReportList[row].getIndex(col, showEnglishDate),
          );
          rowData.insert(0, '${row + 1}');
          return rowData;
        },
      ).where((rowData) => rowData.skip(1).any((value) => value != "0.0")).toList(),
      // headers: List<String>.generate(
      //   tableHeaders.length,
      //       (col) => tableHeaders[col],
      // ),
      // data: List<List<String>>.generate(
      //   salesReportList.length,
      //       (row) => List<String>.generate(
      //     tableHeaders.length,
      //         (col) => salesReportList[row].getIndex(col, showEnglishDate),
      //   ),
      // ),
    );

  }
}