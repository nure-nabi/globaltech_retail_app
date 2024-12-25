import 'dart:io';
import 'dart:typed_data';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/purchase_report/model/purchase_report_model.dart';
import 'package:retail_app/src/salesreport/model/sales_report_model.dart';
import '../../utils/utils.dart';

double myCellHeight = 20;

Future<Uint8List> generatePurchaseInvoiceShare({
  ///
  List<PurchaseDataModel>? purchaseReportList,

  ///
  required CompanyDetailsModel companyDataDetails,
  required String vNo,
  required String vDate,
  required String? vMiti,
  required String? glDesc,
  required String netAmt,
  bool showEnglishDate = false,
}) async {
  final invoice = Invoice(
    purchaseReportList: purchaseReportList ?? [],
    baseColor: PdfColors.orangeAccent,
    accentColor: PdfColors.blueGrey900,
    companyDataDetails: companyDataDetails,
    vNo: vNo,
    vDate: vDate,
    vMiti: vMiti,
    glDesc: glDesc,
    netAmt: netAmt,
    fileName: 'Purchase_Report',
    showEnglishDate: showEnglishDate,
  );

  return await invoice.buildPdf(PdfPageFormat.a4);
}

class Invoice {
  Invoice({
    required this.purchaseReportList,
    required this.baseColor,
    required this.accentColor,
    required this.companyDataDetails,
    required this.vNo,
    required this.vDate,
    required this.vMiti,
    required this.glDesc,
    required this.netAmt,
    required this.fileName,
    required this.showEnglishDate,
  });


  double calculateTotalNetAmount() {
    double totalNetAmount = 0.0;
    for (var sale in purchaseReportList) {
      totalNetAmount += double.parse(sale.netAmt.toStringAsFixed(2)); // Parse netAmount for each sale
    }
    return totalNetAmount;
  }


  final List<PurchaseDataModel> purchaseReportList;

  ///
  late CompanyDetailsModel companyDataDetails;
  late String vNo, vDate, netAmt;
  late String? vMiti, fileName, glDesc;

  // late String billDate, billNo, netAmount;
  // late String? salesType, glDesc, fileName;

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

          ///
          SizedBox(height: 20),

          ///
          _contentBalanceFooter(context),
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
                      'Purchase Report',
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

  Widget _contentBalanceFooter(Context context) {
    double totalNetAmount = calculateTotalNetAmount();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.0),
        Text(
          // 'Total Purchase Amt : $vNo',
          'Total Sales Amt : $totalNetAmount',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          width: 200,
          height: 0.5,
          color: PdfColors.grey.shade(0.2),
        ),
        SizedBox(height: 5.0),
        Text(
          '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _contentTrialTable(Context context, bool showEnglishDate) {
    final tableHeaders = ['Voucher No', 'Date', 'Miti', 'Party', 'Amount'];

    return TableHelper.fromTextArray(
      headers: ['S.No.'] + tableHeaders,
      border: null,
      cellAlignment: Alignment.centerLeft,
      headerDecoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: myCellHeight,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
      },
      headerStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
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
      //   purchaseReportList.length,
      //       (row) => List<String>.generate(
      //     tableHeaders.length,
      //         (col) => purchaseReportList[row].getIndex(col, showEnglishDate),
      //   ),
      // ),

      data: List<List<String>>.generate(
        purchaseReportList.length,
            (row) {
          List<String> rowData = List<String>.generate(
            tableHeaders.length,
                (col) => purchaseReportList[row].getIndex(col, showEnglishDate),
          );
          rowData.insert(0, '${row + 1}');
          return rowData;
        },
      ).where((rowData) => rowData.skip(1).any((value) => value != "0.0")).toList(),
    );
  }
}