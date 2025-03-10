import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/services/services.dart';
import 'package:retail_app/services/sharepref/get_all_pref.dart';
import 'package:retail_app/src/bill_report/bill_report_screen.dart';
import 'package:retail_app/src/datepicker/date_picker_screen.dart';
import 'package:retail_app/src/purchase_report/purchase_report_state.dart';
import 'package:retail_app/src/purchase_report/test.dart';
import 'package:retail_app/widgets/alert/show_alert.dart';

import '../../constants/text_style.dart';
import '../../themes/fonts_style.dart';
import '../../widgets/no_data_widget.dart';
import '../../widgets/text_field_decoration.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({Key? key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  bool showAmount = false;

  @override
  void initState() {
    super.initState();
    Provider.of<PurchaseReportState>(context, listen: false).getContext = context;
   // Provider.of<PurchaseReportState>(context, listen: false).getPurchaseTotalFromDB();
  }

  @override
  Widget build(BuildContext context) {
    final purchaseState =  Provider.of<PurchaseReportState>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title:  Text('Purchase Report',style: cardTextStyleHeader,),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              ShowAlert(context).alert(
                child: DatePickerWidget(
                  onConfirm: () async {
                    await purchaseState.onDatePickerConfirm();
                    purchaseState.init();
                  },
                ),
              );
            },
            icon: const Icon(Icons.calendar_month),
          ),
          const SizedBox(
            width: 3.0,
          ),
          // IconButton(
          //     onPressed: () {
          //       purchaseState.shareLedger();
          //     },
          //     icon: const Icon(Icons.share)),
          const SizedBox(
            width: 3.0,
          ),
          IconButton(onPressed: () async {
            purchaseState.init();
            String currentTime = DateFormat('dd/MM/yyyy hh:mm:ss a').format(DateTime.now());
            await SetAllPref.setTimeCurrent(value: currentTime);
          }, icon: const Icon(Icons.refresh)),
          const SizedBox(
            width: 5.0,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8,right: 8,bottom: 5,top: 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: TextFormField(
                    onChanged: (value) {
                      purchaseState.filterCustomerListScreen = value;
                      setState(() {});
                    },
                    decoration: TextFormDecoration.decoration(
                      hintText: "Search Customer",
                      hintStyle: hintTextStyle,
                      prefixIcon: Icons.search,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //  Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: SizedBox(
          //     height: 30.0,
          //     child: Column(
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             const Text(
          //               'Last sync:',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.red,
          //               ),
          //             ),
          //
          //             Expanded(
          //
          //               child: FutureBuilder<dynamic>(
          //                   future: GetAllPref.getTimeCurrent(),
          //                   builder: (context,snapshot){
          //                    String date = snapshot.data!;
          //                     return Text(
          //                      date,
          //                       style: const TextStyle(
          //                         fontWeight: FontWeight.bold,
          //                         color: Colors.red,
          //                       ),
          //                     );
          //                   }
          //               ),
          //             ),
          //
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // const Divider(
          //   color: Colors.grey,
          //   thickness: 1.5,
          // ),
          Expanded(
            child: purchaseState.filterCustomerList.isNotEmpty ? ListView.builder(
              itemCount: purchaseState.filterCustomerList.length,
              itemBuilder: (BuildContext context, int index) {
                Color bgColor = index.isEven ? Colors.white : Colors.grey[200]!;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PurchaseReportScreen(vNo: purchaseState.filterCustomerList[index].vNo,glDesc: purchaseState.filterCustomerList[index].glDesc, date: purchaseState.filterCustomerList[index].vDate,),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                    const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 3.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(12.0)),
                        color: bgColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      height: 90.0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15.0,0.0, 15.0, 0.0),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    purchaseState
                                        .filterCustomerList[index].glDesc,
                                    style: cardTextStyleHeaderCompany,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Voucher No: ${purchaseState.filterCustomerList[index].vNo}',
                                    style: cardTextStyleProductHeader,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Date: ${purchaseState.filterCustomerList[index].vDate}',
                                    style: const TextStyle(
                                        fontSize: 12.0),
                                  ),


                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Amount",
                                    style: cardTextStyleSalePurchase,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                      purchaseState
                                          .filterCustomerList[index].netAmt
                                          .toString(),
                                      style:
                                      cardTextStyleSalePurchase
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ) :const NoDataWidget(),
          ),

        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        height: 50.0,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(
                16.0),
          ),
          color:Colors.green,
        ),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total",style: cardTextStyleHeader,),
            Text(purchaseState.totalAmount.toStringAsFixed(2),style: cardTextStyleHeader,)
          ],
        ),
      ),
    );
  }
}