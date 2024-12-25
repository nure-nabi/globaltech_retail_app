import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/ledger_party_bill_details/ledger_party_bill_details_screen.dart';
import 'package:retail_app/src/ledger_report_party_bill/ledger_report_party_bill_state.dart';
import 'package:retail_app/src/ledger_report_party_bill/provider/report_provider.dart';

import '../../component/dialog/option_dialog.dart';
import '../../component/dialog/option_dialog_custom_option.dart';
import '../../themes/colors.dart';
import '../../widgets/alert/show_alert.dart';
import '../../widgets/container_decoration.dart';
import '../datepicker/date_picker_screen.dart';
import 'ledger_report_party_bill.dart';

class LedgerReportPartyBillScreen extends StatefulWidget {
  final String glCode;
  final String customerName;
  const LedgerReportPartyBillScreen({super.key, required this.glCode,required this.customerName});

  @override
  State<LedgerReportPartyBillScreen> createState() => _LedgerReportPartyBillScreenState();
}

class _LedgerReportPartyBillScreenState extends State<LedgerReportPartyBillScreen> {
  double drTotalAmount=0.00;
  double crTotalAmount=0.00;
  @override
  void initState() {
    super.initState();
    Provider.of<LedgerReportPartyBillState>(context, listen: false).getContext = context;
    Provider.of<LedgerReportPartyBillState>(context, listen: false).init(glCode: widget.glCode);
  }

  @override
  Widget build(BuildContext context) {
    final state =  Provider.of<LedgerReportPartyBillState>(context, listen: false);
    Provider.of<ReportProvider>(context, listen: false);
    // if(state.dateMapping == "DateWise"){
    // }else{
    //   Provider.of<LedgerReportPartyBillState>(context, listen: false).init(glCode: widget.glCode);
    // }

    // Fluttertoast.showToast(msg: "build");
    return Consumer<LedgerReportPartyBillState>(
      builder: ( context, ledgerReportPartyBillState, _)
      {return Scaffold(
        appBar: AppBar(
          title: Text(widget.customerName,style: const TextStyle(overflow: TextOverflow.ellipsis),),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  ShowAlert(context).alert(
                    child: DatePickerWidget(
                      onConfirm: () async {
                        //  state.getDataMappingData = "DateWise";
                        await state.onDatePickerConfirm();
                      },
                    ),
                  );
                  // await showInformationDialog(
                  //   context,
                  //   OptionDialogCustomOption(
                  //     optionDialogGroup: OptionDialogGroup.allLedger,
                  //     optionDialogSubGroup: OptionDialogSubGroup.invoice,
                  //   ),
                  //   'Ledger Report',
                  // );
                },
                child: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  state.shareLedger();
                },
                icon: const Icon(Icons.share)),
            IconButton(onPressed: () {
              state.init(glCode: widget.glCode);
            }, icon: Icon(Icons.refresh)),

          ],
        ),
        body: Consumer<LedgerReportPartyBillState>(
          builder: (context, ledgerReportPartyBillState, _) {
            if (ledgerReportPartyBillState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (ledgerReportPartyBillState.LedgerWiseList.isEmpty) {
                return const Center(child: Text('No data available'));
              } else {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(flex: 1,child: Container(padding:const EdgeInsets.all(10),color:Colors.green,child: const Text("Details",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white),))),
                          const SizedBox(width: 5,),
                          Expanded(flex: 1,child: Container(padding:const EdgeInsets.all(10),color:Colors.green,child: const Text("Dr",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white),))),
                          const SizedBox(width: 5,),
                          Expanded(flex: 1,child: Container(padding:const EdgeInsets.all(10),color:Colors.green,child: const Text("Cr",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white),))),
                          const SizedBox(width: 5,),
                          Expanded(flex: 1,child: Container(padding:const EdgeInsets.all(10),color:Colors.green,child: const Text("Amount",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white),))),
                          const SizedBox(width: 5,),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: ledgerReportPartyBillState.LedgerWiseList.length,
                        itemBuilder: (BuildContext context, int index) {
                          // LedgerPartyReportDataModel indexData = ledgerReportPartyBillState.dataList[index];
                          var indexData = ledgerReportPartyBillState.LedgerWiseList[index];
                          String mySource = indexData.source.toUpperCase();

                          bool checkVoucherType = (mySource == "SALES");
                          bool checkCashBank = (mySource == "CASH BANK");
                          Color bgColor = index.isEven ? Colors.white : Colors.grey[200]!;
                          double drAmt = 0.00;
                          double crAmt = 0.00;
                          for (int i = 0; i <= index; i++) {
                            drAmt += double.parse(ledgerReportPartyBillState.LedgerWiseList[i].dr);
                            crAmt += double.parse(ledgerReportPartyBillState.LedgerWiseList[i].cr);
                          }
                          double finalAmount = drAmt - crAmt;
                          return InkWell(
                            onTap: (){
                              checkVoucherType
                                  ?  Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LedgerPartyBillDetailsScreen(vNo: ledgerReportPartyBillState.LedgerWiseList[index].vno,billNo: ledgerReportPartyBillState.LedgerWiseList[index].vno,),
                                ),
                              ): checkCashBank
                                  ? state.getCashBankPrintFromAPI(
                                vno: indexData.vno,
                              ) : null;
                            },
                            child: Card(
                              child: Container(
                                height: 80,
                                decoration:  BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0)),
                                  color: bgColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset:  const Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(ledgerReportPartyBillState.LedgerWiseList[index].date,style: const TextStyle(fontWeight: FontWeight.w700),),
                                            const SizedBox(height: 5,),
                                            Text(ledgerReportPartyBillState.LedgerWiseList[index].vno,style: TextStyle(color: primaryColor),),
                                            const SizedBox(height: 5,),
                                            Text(ledgerReportPartyBillState.LedgerWiseList[index].source,style: TextStyle(color: primaryColor)),
                                          ],
                                        )
                                    ),
                                    const SizedBox(width: 5,),
                                    Expanded(child: Container(
                                        alignment: Alignment.topRight,
                                        child: Text(ledgerReportPartyBillState.LedgerWiseList[index].dr,style: const TextStyle(fontWeight: FontWeight.w700)))
                                    ),
                                    const SizedBox(width: 5,),
                                    Expanded(child: Container(
                                        alignment: Alignment.topRight,
                                        child: Text(ledgerReportPartyBillState.LedgerWiseList[index].cr,style: const TextStyle(fontWeight: FontWeight.w700)))),
                                    const SizedBox(width: 5,),
                                    Expanded(child: Container(
                                        alignment: Alignment.topRight,
                                        child: Text(finalAmount.toStringAsFixed(2),style: const TextStyle(fontWeight: FontWeight.w700)))),
                                    const SizedBox(width: 5,),
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
            }
          },
        ),

        // bottomNavigationBar: Container(
        //   height: 50,
        //   padding: const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 5),
        //   decoration: ContainerDecoration.decoration(
        //     // color: borderColor, bColor: borderColor
        //     borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
        //     color: Colors.green,
        //   ),
        //   child: Consumer<CustomerState>(
        //     builder: (context,state, _){
        //       return Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         //  crossAxisAlignment: CrossAxisAlignment.end,
        //         children: [
        //           Text("Total",style:cardTextStyleHeader,),
        //           Text(state.totalCustomerAmount.toStringAsFixed(2),style:  cardTextStyleHeader,),
        //         ],
        //       );
        //     },
        //   ),
        // ),
        bottomNavigationBar: Container(
          height: 50,
          padding: const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 5),
          decoration: ContainerDecoration.decoration(
            // color: borderColor, bColor: borderColor
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
            color: Colors.green,
          ),
          child:
          FutureBuilder<List<LedgerPartyReportDataModel>>(
            future: state.getLedgerReportTotalApi(glCode: widget.glCode),
            builder: (BuildContext context, snapshot)
            {  if (snapshot.connectionState == ConnectionState.waiting) {
              //   Fluttertoast.showToast(msg: "ys");
              return const Center(child: Text(""));
            }
            else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if(snapshot.hasData){
              List<LedgerPartyReportDataModel> LedgerAmountList = snapshot.data!;
              double drAmt = 0;
              double crAmt = 0;
              for(int i=0; i<state.LedgerWiseList.length ; i++){
                drAmt += double.parse(state.LedgerWiseList[i].dr);
                crAmt += double.parse(state.LedgerWiseList[i].cr);
              }
              return Row(

                children: [
                  Expanded(child: const Text("Total",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,overflow: TextOverflow.ellipsis,color: Colors.white),)),
                  Expanded(child: Text(drAmt.toStringAsFixed(2),textAlign:TextAlign.end,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,overflow: TextOverflow.ellipsis,color: Colors.white))),
                  Expanded(child: Text(crAmt.toStringAsFixed(2),textAlign:TextAlign.end,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,overflow: TextOverflow.ellipsis,color: Colors.white))),
                  Expanded(child: Text((drAmt - crAmt).toStringAsFixed(2),textAlign:TextAlign.end,style: const TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 18,color: Colors.white))),
                ],
              );
            }
            return const SizedBox();
            },

          ),
        ),

      );},
    );
  }
}