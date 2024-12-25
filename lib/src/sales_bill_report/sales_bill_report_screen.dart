import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/constants/text_style.dart';
import 'package:retail_app/services/sharepref/get_all_pref.dart';
import 'package:retail_app/src/sales_bill_report/sales_bill_report.dart';
import 'package:retail_app/src/sales_bill_report/sales_bill_report_state.dart';
import 'package:retail_app/utils/show_toast.dart';

class SalesBillReportScreen extends StatefulWidget {
  final String billNo;
  final String glDesc;
  final String date;

  const SalesBillReportScreen(
      {Key? key, required this.billNo, required this.glDesc,required this.date});

  @override
  State<SalesBillReportScreen> createState() => _SalesBillReportScreenState();
}

class _SalesBillReportScreenState extends State<SalesBillReportScreen> {
  String va="";
  int i=0;
  double hTetmAmt = 0.0;
  double hNetAmt = 0.0;
  @override
  void initState() {
    super.initState();
    Provider.of<SalesBillReportState>(context, listen: false).init(billNo: widget.billNo);
    show();
  }

  show() async {
   va = await GetAllPref.unitCode();
  }
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SalesBillReportState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.glDesc}(${widget.billNo})',style: cardTextStyleHeader,),
            const SizedBox(height: 5,),
            Text('${widget.date}',style: const TextStyle(fontSize: 15,),),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Consumer<SalesBillReportState>(
        builder: (context, salesBillReportState, _) {
          if (salesBillReportState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: salesBillReportState.dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Color bgColor = index.isEven ? Colors.white : Colors.grey[200]!;

                      DateTime dateTime = DateFormat("yyyy-MM-dd").parse(salesBillReportState.dataList[index].hDate);
                      String formattedDate = DateFormat("dd-MM-yyyy").format(dateTime);
                      i++;

                      if(salesBillReportState.dataList.length == (index)) {
                     //   Fluttertoast.showToast(msg: index.toString());
                      }

                      //Fluttertoast.showToast(msg: salesBillReportState.dataList.length.toString());

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6.0)),
                           color: bgColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 4), // changes position of shadow
                              ),
                            ],
                          ),
                        //  height: 110.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                               Visibility(
                                 visible: index == 0 ? false : false,
                                 child: Container(
                                   color: Colors.black12,
                                     alignment: Alignment.topLeft,
                                   child: Column(
                                       crossAxisAlignment:
                                       CrossAxisAlignment.start,
                                     children:[
                                       Text(
                                         'Voucher No: ${salesBillReportState.dataList[index].hvno.toString()}',
                                         maxLines: 1,
                                         style: const TextStyle(
                                             fontSize: 16.0,
                                             color: Colors.green, fontWeight: FontWeight.bold),
                                       ),
                                       const SizedBox(
                                         height: 5.0,
                                       ),
                                       Text(
                                         'Date:$formattedDate',
                                         style: const TextStyle(
                                             color: Colors.green, fontSize: 16.0,fontWeight: FontWeight.bold
                                         ),
                                       ),
                                       const SizedBox(
                                         height: 5.0,
                                       ),
                                       Text(
                                         'Miti:${salesBillReportState.dataList[index].hMiti.toString()}',
                                         style: const TextStyle(
                                             color: Colors.green, fontSize: 16.0,fontWeight: FontWeight.bold
                                         ),
                                       ),
                                       const SizedBox(
                                         height: 5.0,
                                       ),
                                       Text(
                                         'Customer: ${salesBillReportState.dataList[index].hGlDesc.toString()}',
                                         style: const TextStyle(
                                             color: Colors.green,fontSize: 16.0,fontWeight: FontWeight.bold
                                         ),
                                       ),

                                       const SizedBox(
                                         height: 5.0,
                                       ),
                                       Text(
                                         'Mobile No: ${salesBillReportState.dataList[index].hMobileNo.toString()}',
                                         style: const TextStyle(
                                             color: Colors.green,fontSize: 16.0,fontWeight: FontWeight.bold
                                         ),
                                       ),
                                     ]
                                   )
                                 ),
                               ),
                                SizedBox(height: 0,),
                                Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        children:[
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                    'Item: ${salesBillReportState.dataList[index].dpDesc.toString()}',
                                                    maxLines: 1,
                                                    style: cardTextStyleHeaderCompany,
                                                  ),
                                              ),


                                            ],
                                          ),
                                          Row(
                                            children: [
                                               Expanded(
                                                child: Text(
                                                  'Qty',
                                                  maxLines: 1,
                                                  style: cardTextStyleProductHeader,
                                                ),
                                              ),
                                              Expanded(child: Text(":")),
                                              Expanded(
                                                flex:2,
                                                child: Text(
                                                  salesBillReportState.dataList[index].dQty.toString(),
                                                  maxLines: 1,
                                                  style: cardTextStyleSalePurchase,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                               Expanded(
                                                child: Text(
                                                  'Unit',
                                                  maxLines: 1,
                                                  style: cardTextStyleProductHeader,
                                                ),
                                              ),
                                              Expanded(child: Text(":")),
                                              Expanded(
                                                flex:2,
                                                child: Text(
                                                  salesBillReportState.dataList[index].unitCode.toString(),
                                                  maxLines: 1,
                                                  style: cardTextStyleSalePurchase,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                               Expanded(
                                                child: Text(
                                                  'Rate',
                                                  maxLines: 1,
                                                  style: cardTextStyleProductHeader,
                                                ),
                                              ),
                                              Expanded(child: Text(":")),
                                              Expanded(
                                                flex:2,
                                                child: Text(
                                                  salesBillReportState.dataList[index].dLocalRate.toString(),
                                                  maxLines: 1,
                                                  style: cardTextStyleSalePurchase,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                               Expanded(
                                                child: Text(
                                                  'Term Amt',
                                                  maxLines: 1,
                                                  style:cardTextStyleProductHeader,
                                                ),
                                              ),
                                              Expanded(child: Text(":")),
                                              Expanded(
                                                flex:2,
                                                child: Text(
                                                  salesBillReportState.dataList[index].dTermAMt.toString(),
                                                  maxLines: 1,
                                                  style: cardTextStyleSalePurchase,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                               Expanded(
                                                child: Text(
                                                  'Amount',
                                                  maxLines: 1,
                                                  style: cardTextStyleProductHeader,
                                                ),
                                              ),
                                              Expanded(child: Text(":")),
                                              Expanded(
                                                flex:2,
                                                child: Text(
                                                  salesBillReportState.dataList[index].dNetAmt.toString(),
                                                  maxLines: 1,
                                                  style: cardTextStyleSalePurchase,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                    )
                                ),


                              ],
                            ),
                          ),
                        ),
                      );


                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                        FloatingActionButton(
                          onPressed: () {
                            state.onPrint(name: widget.billNo);
                          },
                          backgroundColor: Colors.green,
                          child: const Icon(Icons.picture_as_pdf),
                        ),
                  SizedBox(width: 20,),
                  FloatingActionButton(
                    onPressed: () async{
                   await state.printReceipt(value:state.dataList);
                    },
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.print),
                  ),
                  // InkWell(
                  //   onTap: (){
                  //     state.onPrint(name: widget.billNo);
                  //   },
                  //   child: Container(
                  //     width: 200,
                  //     height: 40,
                  //     decoration: const BoxDecoration(
                  //         color: Colors.green,
                  //         borderRadius: BorderRadius.all(Radius.circular(10))
                  //     ),
                  //     child:  Center(
                  //       child: Text(
                  //         'Add New Item',
                  //         style: cardTextStyleHeader,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(left: 30,bottom: 30),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       FloatingActionButton(
      //         onPressed: () {
      //           state.onPrint(name: widget.billNo);
      //         },
      //         backgroundColor: Colors.green,
      //         child: const Icon(Icons.print),
      //       ),
      //     ],
      //   ),
      // ),
     // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Container(
       height: 80,
        color: Colors.green,
        child: Consumer<SalesBillReportState>(

          builder: (context, salesBillSate,_) {
            return Container(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       Expanded(
                        child: Text(
                          'Basic Amount',
                          style: cardTextStyleHeader,
                        ),
                      ),
                      const Expanded(child: Text(":",style: TextStyle(color: Colors.white),)),
                      Expanded(
                        child:   Text(
                          salesBillSate.hBasicAmount.toStringAsFixed(2),
                          style: cardTextStyleHeader,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       Expanded(
                        child: Text(
                          'Term Amount',
                          style: cardTextStyleHeader,
                        ),
                      ),
                      const Expanded(child: Text(":",style: TextStyle(color: Colors.white),)),
                      Expanded(
                        child:   Text(
                          salesBillSate.hTermAmount.toStringAsFixed(2),
                          style: cardTextStyleHeader,
                        ),
                      ),


                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                   // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Expanded(
                        child:  Text(
                          'Net Amount',
                          style: cardTextStyleHeader,
                        ),
                      ),
                      const Expanded(child: Text(":",style: TextStyle(color: Colors.white),)),
                      Expanded(
                        child:  Text(
                          salesBillSate.hNetAmount.toStringAsFixed(2),
                          style: cardTextStyleHeader,
                        ),
                      ),


                    ],
                  ),
                ],
              ),
            );
          }
        ),
      ),
      // Visibility(
      //   visible: true,
      //   child: Container(
      //     child: Column(
      //       children: [
      //         Text(
      //           'D Term Amt: ${state.dataList[0].dTermAMt.toString()}',
      //           style: const TextStyle(
      //               fontSize: 18.0,fontWeight: FontWeight.bold
      //           ),
      //         ),
      //         Text(
      //           'D Basic: ${state.dataList[0].dBasicAmt.toString()}',
      //           style: const TextStyle(
      //               fontSize: 18.0,fontWeight: FontWeight.bold
      //           ),
      //         ),
      //         Text(
      //           'H Term Amt: ${state.dataList[0].hTermAMt.toString()}',
      //           style: const TextStyle(
      //               fontSize: 18.0,fontWeight: FontWeight.bold
      //           ),
      //         ),
      //         Text(
      //           'H Net: ${state.dataList[0].hNetAmt.toString()}',
      //           style: const TextStyle(
      //               fontSize: 18.0,fontWeight: FontWeight.bold
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
