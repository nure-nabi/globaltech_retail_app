import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/ledger_party_bill_details/ledger_party_bill_details_state.dart';

import '../../constants/text_style.dart';

class LedgerPartyBillDetailsScreen extends StatefulWidget {
  final String vNo;
  final String billNo;

  const LedgerPartyBillDetailsScreen({Key? key, required this.vNo,required this.billNo});

  @override
  State<LedgerPartyBillDetailsScreen> createState() => _LedgerPartyBillDetailsScreenState();
}

class _LedgerPartyBillDetailsScreenState extends State<LedgerPartyBillDetailsScreen> {
  @override
  void initState() {
    Provider.of<LedgerPartyBillDetailsState>(context, listen: false).init(vNo: widget.vNo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<LedgerPartyBillDetailsState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title:  Text('Bill No : ${widget.billNo}',style: cardTextStyleHeader,),

        backgroundColor: Colors.green,
      ),
      body: Consumer<LedgerPartyBillDetailsState>(
        builder: (context, ledgerPartyBillDetails, _) {
          if (ledgerPartyBillDetails.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: ledgerPartyBillDetails.dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      debugPrint("${ledgerPartyBillDetails.dataList.length}");
                      debugPrint("${ledgerPartyBillDetails.dataList.length}");
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
                                offset: const Offset(
                                    0, 4), // changes position of shadow
                              ),
                            ],
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Item: ${ledgerPartyBillDetails.dataList[index].dpDesc.toString()}',
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
                                              ledgerPartyBillDetails.dataList[index].dQty.toString(),
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
                                              ledgerPartyBillDetails.dataList[index].unitCode.toString(),
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
                                              ledgerPartyBillDetails.dataList[index].dLocalRate.toString(),
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
                                              ledgerPartyBillDetails.dataList[index].dTermAMt.toString(),
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
                                              ledgerPartyBillDetails.dataList[index].dNetAmt.toString(),
                                              maxLines: 1,
                                              style: cardTextStyleSalePurchase,
                                            ),
                                          ),
                                        ],
                                      ),


                                    ],
                                  ),
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
                state.onPrint(name: widget.billNo);
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
        child: Consumer<LedgerPartyBillDetailsState>(

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