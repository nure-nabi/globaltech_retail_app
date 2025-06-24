import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:retail_app/services/services.dart';
import 'package:retail_app/src/bill_report/model/bill_report_model.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/sales_bill_report/model/sales_bill_report_model.dart';
import 'package:retail_app/utils/text_formatter.dart';

import '../../../utils/number_to_words.dart';
import '../model/product_sales_model.dart';
import '../model/temp_product_sales_model.dart';

class FileHandleApiSalesProduct {
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

class PdfInvoiceProductSales {
  static Future<File> generate({
    required CompanyDetailsModel companyDetails,
    required int indexes,
    required double qty,
    required double rate,
    required double pTermDic,
    required double pTermVat,
    required double pTermAdditional,
    required double bTermDisc1,
    required double bTermVat2,
    required double totalAmount,
    required String customerName,
    required String sign1,
    required String sign2,
    required String sign3,
    required String voucherNo,
    required List<ProductOrderModel> productList,
     String? paymentMode,
  }) async {
    final pdf = Document();

    double bTermDis1 =0.0;
    double bTermVate2 =0.0;
    double bTerm3 = 0.0;
    String pTermDis1 = "";
    String pTermVat2 = "";
    String pTermOther3 = "";




    List<ProductOrderModel> tempOrderList = [];
    for(var element in productList){

      if(sign1 == "-"){
        pTermDis1 = element.pTerm1Amount;
      }else if(sign1 == "+"){
        pTermVat2 = element.pTerm1Amount;
      }
      if(sign2 == "-"){
        pTermDis1 = element.pTerm2Amount;
      }else if(sign2 == "+"){
        pTermVat2 = element.pTerm2Amount;
      }
      if(sign3 == "-"){
        pTermDis1 = element.pTerm3Amount;
      }else if(sign3 == "+"){
        pTermVat2 = element.pTerm3Amount;
      }

      tempOrderList.add(ProductOrderModel(
          itemCode: element.itemCode,
          pName: element.pName,
          qty: element.qty,
          rate: element.rate,
          totalAmt: element.totalAmt,
          netTotalAmt: element.netTotalAmt,
          pTerm1Code: element.pTerm1Code,
          pTerm1Rate: element.pTerm1Rate,
          pTerm1Amount: pTermDis1,
          sign1: element.sign1,
          pTerm2Code: element.pTerm2Code,
          pTerm2Rate: element.pTerm2Rate,
          pTerm2Amount: pTermVat2,
          sign2: element.sign2,
          pTerm3Code: element.pTerm3Code,
          pTerm3Rate: element.pTerm3Rate,
          pTerm3Amount: element.pTerm3Amount,
          bTerm1: element.bTerm1,
          bTerm1Rate: element.bTerm1Rate,
          bTerm1Amount: element.bTerm1Amount,
          sign3: element.sign3,
          bSign1: element.bSign1,
          bTerm2: element.bTerm2,
          bTerm2Rate: element.bTerm2Rate,
          bTerm2Amount: element.bTerm2Amount,
          bSign2: element.bSign2,
          bTerm3: element.bTerm3,
          bTerm3Rate: element.bTerm3Rate,
          bTerm3Amount: element.bTerm3Amount,
          bSign3: element.bSign3,
          godownCode: element.godownCode,
          dbName: element.dbName,
          salesImage: element.salesImage,
          imagePath: element.imagePath,
          outletCode: element.outletCode,
          unit: element.unit,
         altUnit: element.altUnit,
          altQty: element.altQty,
         hsCode: element.hsCode,
         factor: element.factor,
        payAmount: element.payAmount,
          billNetAmt: element.billNetAmt,
          userCode: element.userCode,
          cashGlCode: element.cashGlCode,
          remarks: 're'
      ));
    }

   // double dis = 0.0;
   // double vat = 0.0;
    double other = 0.0;
    // String sign1 = "";
    // String sign2 = "";
    // String sign3 = "";
    String signOne= "";
    String SignTwo = "";
    String t = "";

    // for(var element in tempOrderList){
    //   dis += double.parse(element.pTerm1Amount);
    //   t = element.pTerm2Amount.isEmpty ? "0.0" : element.pTerm2Amount ;
    //   vat += double.parse(t);
    // }



    if(tempOrderList[0].bSign1 == "-"){
      bTermDis1 = bTermDisc1;
    }else if(tempOrderList[0].bSign1 == "+"){
      bTermVate2 = bTermDisc1;
    }
    if(tempOrderList[0].bSign2 == "-"){
      bTermDis1 = bTermVat2;
    }else if(tempOrderList[0].bSign2 == "+"){
      bTermVate2 = bTermVat2;
    }
    if(tempOrderList[0].bSign3 == "-"){
      bTermDis1 = bTermDisc1;
    }else if(tempOrderList[0].bSign3 == "+"){
      bTermVate2 = bTermVat2;
    }

    double grandTotal = totalAmount - bTermDis1 + bTermVate2;

    int totalAmountWord = int.parse(grandTotal.toString().split(".").first);

    Widget dataValue({required String title, required String value}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Row(children: [
          Flexible(
              child: Text(
            "$title ",
            style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
          )),
          Flexible(
              child: Text(
            " $value",
            style: const TextStyle(fontSize: 13.0),
          )),
        ]),
      );
    }

    // final iconImage =
    // (await rootBundle.load('images/app_icon.png')).buffer.asUint8List();

    final tableHeaders = [
      'Particular',
      'Qty',
      'Rate',
      'Amt',
      'Dis',
      'Vat',
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
                color:PdfColors.orangeAccent,
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
        // header: (context) =>
        footer: (context) => buildFooter(context),
        build: (context) {
          // ['Disc', 'Vat'];
          List<String> excludedHeaders= [];
          if(pTermVat.toString() == "0.0" && pTermDic.toString() == "0.0"){
            excludedHeaders = ['Disc','Vat'];
          }else if(pTermDic.toString() == "0.0"){
            excludedHeaders = ['Disc'];
          }else{
            excludedHeaders = ['Vat'];
          }



          final updatedTableHeaders = tableHeaders.where((header) => !excludedHeaders.contains(header)).toList(); // multiple header
          //final updatedTableHeaders = tableHeaders.where((header) => header != excludedHeader).toList(); single header
        //  Fluttertoast.showToast(msg: pTermDic.toString());
          return [
            buildHeader(
              companyPanNo: companyDetails.vatNo,
              address: companyDetails.companyAddress,
              companyName: companyDetails.companyName,
            ),
            SizedBox(height: 10.0),

            Divider(),
           Center(
             child: Text("Sales Invoice",style: TextStyle(color: PdfColors.orangeAccent,fontWeight: FontWeight.bold))
           ),
            Divider(),

            SizedBox(height: 5.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          text: 'Voucher No : ',
                          style: TextStyle(fontWeight: FontWeight.bold,color: PdfColors.orangeAccent),
                          children: [
                            TextSpan(text:  voucherNo, style: const TextStyle())
                          ])),
                ]
            ),

           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               RichText(
                   text: TextSpan(
                       text: 'Customer : ',
                       style: TextStyle(fontWeight: FontWeight.bold,color: PdfColors.orangeAccent),
                       children: [
                         TextSpan(text:  customerName, style: const TextStyle())
                       ])),
               RichText(
                   text: TextSpan(
                       text: 'Date : ',
                       style: TextStyle(fontWeight: FontWeight.bold),
                       children: [
                         TextSpan(
                             text:
                             " ${NepaliDateTime.now().format("yyyy/MM/dd").toUpperCase()}",
                             style: TextStyle(fontWeight: FontWeight.bold))
                       ])),
             ]
           ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  RichText(
                      text: TextSpan(
                          text: 'Payment Mode : ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text:
                                paymentMode,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ])),
                ]
            ),

            // if (address.isNotEmpty)
            //   dataValue(title: "Address:", value: address),
            // if (phone.isNotEmpty) dataValue(title: "Phone:", value: phone),
            // if (panNo.isNotEmpty) dataValue(title: "PAN No.:", value: panNo),

            SizedBox(height: 10.0),

            /// PDF Table Create
            TableHelper.fromTextArray(
                headers: ['S.No.'] + updatedTableHeaders,
                cellAlignment: Alignment.topCenter,
                headerAlignment: Alignment.center,
                data: List<List<String>>.generate(
                  tempOrderList.length,
                  (row) {
                    List<String> rowData = List<String>.generate(
                      updatedTableHeaders.length,
                      (col) => tempOrderList[row].getIndex(col,pTermDic.toString(),pTermVat.toString()),
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
                  0: const FlexColumnWidth(.8),
                  1: const FlexColumnWidth(2),
                  2: const FlexColumnWidth(.7),
                  3: const FlexColumnWidth(.7),
                  4: const FlexColumnWidth(1),
                  5: const FlexColumnWidth(1),
                  6: const FlexColumnWidth(1),
                  7: const FlexColumnWidth(1),
                },
                cellAlignments: {
                  0: Alignment.center,
                  1: Alignment.centerLeft,
                  2: Alignment.centerRight,
                  3: Alignment.centerRight,
                  4: Alignment.centerRight,
                  5: Alignment.centerRight,
                  6: Alignment.centerRight,
                  7: Alignment.centerRight,
                }),

            Container(
              padding: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                border: Border.all(color: PdfColor.fromHex("#000000")),
              ),
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
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
                    height: bTermDis1 == 0.0 ? 40 : bTermVate2 == 0.0 ? 40 : 60,
                    width: 1.0,
                    color: PdfColor.fromHex("#000000"),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 0.0),
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
                          bTermDis1 > 0 ? Row(children: [
                            Expanded(
                                child: Text(
                              'Dis : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            Text(bTermDis1.toStringAsFixed(2),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ]) : SizedBox(),
                          bTermVate2 > 0 ? Row(children: [
                            Expanded(
                                child: Text(
                              'Vat : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            Text(bTermVate2.toStringAsFixed(2),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ]): SizedBox(),
                          Row(children: [
                            Expanded(
                                child: Text(
                              'Net Total : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            Text(grandTotal.toStringAsFixed(2),
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
            // RichText(
            //     text: TextSpan(
            //         text: 'Your current Due(s) : ',
            //         style: const TextStyle(),
            //         children: [
            //       TextSpan(
            //           text: "kj", style: TextStyle(fontWeight: FontWeight.bold))
            //     ])),
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

    return FileHandleApiSalesProduct.saveDocument(
        name: 'my_invoice.pdf', pdf: pdf);
  }
}
