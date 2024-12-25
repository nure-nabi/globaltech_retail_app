import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/bill_report/bill_report_state.dart';
import 'package:retail_app/themes/colors.dart';

import '../../constants/text_style.dart';

class PurchaseReportScreen extends StatefulWidget {
  final String vNo;
  final String glDesc;
  final String date;
  PurchaseReportScreen({Key? key, required this.vNo,required this.glDesc,required this.date});

  @override
  State<PurchaseReportScreen> createState() => _PurchaseReportScreenState();
}

class _PurchaseReportScreenState extends State<PurchaseReportScreen> {
  @override
  void initState() {
    Provider.of<BillReportState>(context, listen: false).init(vNo: widget.vNo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BillReportState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.glDesc,style: cardTextStyleHeader,),
            SizedBox(height: 5,),
            Text(widget.date,style: TextStyle(fontSize: 15),),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Consumer<BillReportState>(
        builder: (context, reportState, _) {
          if (reportState.isLoading) {
            return Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
                      .withOpacity(0.8), // Semi-transparent white background
                ),
                child: CircularProgressIndicator(
                  // Customize the appearance here
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
                  // Adjust color
                  strokeWidth: 5,
                  // Adjust thickness
                  backgroundColor:
                  Colors.teal.withOpacity(0.2), // Add a subtle background
                ),
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: reportState.dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Color bgColor =
                      index.isEven ? Colors.white : Colors.grey[200]!;
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
                                offset:
                                Offset(0, 4), // changes position of shadow
                              ),
                            ],
                          ),

                          child: Padding(
                            padding:
                            const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Item: ${reportState.dataList[index].dpDesc.toString()}',
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
                                        reportState.dataList[index].dQty.toString(),
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
                                        reportState.dataList[index].unitCode.toString(),
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
                                        reportState.dataList[index].dLocalRate.toString(),
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
                                        style: cardTextStyleProductHeader,
                                      ),
                                    ),
                                    Expanded(child: Text(":")),
                                    Expanded(
                                      flex:2,
                                      child: Text(
                                        reportState.dataList[index].dTermAMt.toString(),
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
                                        reportState.dataList[index].dNetAmt.toString(),
                                        maxLines: 1,
                                        style: cardTextStyleSalePurchase,
                                      ),
                                    ),
                                  ],
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30,bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                state.onPrint(name: widget.vNo);
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.print),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.green,
        child: Consumer<BillReportState>(

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
    );
  }
}