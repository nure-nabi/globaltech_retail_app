import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/salesreport/sales_report.dart';

import '../../component/dialog/widget/option_dialog.dart';
import '../../component/dialog/option_dialog_custom_option.dart';
import '../../constants/text_style.dart';
import '../../services/sharepref/set_all_pref.dart';
import '../../themes/fonts_style.dart';
import '../../utils/loading_indicator.dart';
import '../../widgets/alert/show_alert.dart';
import '../../widgets/container_decoration.dart';
import '../../widgets/no_data_widget.dart';
import '../../widgets/text_field_decoration.dart';
import '../datepicker/date_picker_screen.dart';
import '../ledger_report_party_bill/provider/report_provider.dart';
import '../sales_bill_report/sales_bill_report.dart';

class DailyReport extends StatefulWidget {
  const DailyReport({super.key});

  @override
  State<DailyReport> createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {

  @override
  void initState() {
    super.initState();
    Provider.of<SalesReportState>(context, listen: false).getContext = context;
  //  Provider.of<SalesReportState>(context, listen: false).dailyReport();

  }
  @override
  Widget build(BuildContext context) {
    //final salesReportState =  Provider.of<SalesReportState>(context, listen: true);
   // final reportProvider = Provider.of<ReportProvider>(context, listen: true);
   // salesReportState.dailyReport();
    return Consumer<SalesReportState>(builder: (BuildContext context, salesReportState, Widget? child) {
     // salesReportState.dailyReport();
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title:  Text('Daily Report',style: cardTextStyleHeader,),
              backgroundColor: Colors.green,
              actions: [
                // IconButton(onPressed: (){}, icon: Icon(Icons.calendar_month)),
                const SizedBox(width: 3.0,),
                IconButton(onPressed: () async {
                  bool value =  await showInformationDialog(
                    context,
                    OptionDialogCustomOption(
                      optionDialogGroup: OptionDialogGroup.daily,
                      optionDialogSubGroup: OptionDialogSubGroup.daily,
                    ),
                    'Daily Report',
                    // ).then((v) => v == true ? Text("yes") : '');
                  );
                  if(value){
                    await  salesReportState.dailyReport();
                    await salesReportState.getLedgerDateWiseFromDB(salesReportState.fromDate,salesReportState.toDate);
                    setState(() {});
                  }
                }, icon: const Icon(Icons.calendar_month)),
                const SizedBox(width: 10,),
                // IconButton(onPressed: (){
                //   salesReportState.shareLedger();
                // },
                //     icon: const Icon(Icons.share)),
                const SizedBox(width:3.0,),
                IconButton(onPressed: () async {
                  await salesReportState.clean();
                  await salesReportState.getSalesReportFromAPI();
                  setState(() {});
                  String _currentTime = DateFormat('dd/MM/yyyy hh:mm:ss a').format(DateTime.now());
                  await SetAllPref.setTimeCurrent(value: _currentTime);
                }, icon: const Icon(Icons.refresh)),

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
                        padding: EdgeInsets.all(0.0),
                        child: TextFormField(
                          onChanged: (value) {
                            salesReportState.filterCustomerListScreen = value;
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

                Expanded(
                  child: ListView.builder(
                    itemCount: salesReportState.filterCustomerList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Color bgColor = index.isEven ? Colors.white : Colors.grey[200]!;
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  SalesBillReportScreen(billNo: salesReportState.filterCustomerList[index].billNo,glDesc: salesReportState.filterCustomerList[index].glDesc, date: salesReportState.filterCustomerList[index].billDate,),
                            ),
                             );
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 3.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                              color:bgColor,
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
                              padding:  const EdgeInsets.fromLTRB(15.0,0.0, 15.0, 0.0),
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
                                        Text(
                                          salesReportState.filterCustomerList[index].glDesc,
                                          style: cardTextStyleHeaderCompany,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Bill No: ${salesReportState.filterCustomerList[index].billNo} ',
                                          style: cardTextStyleProductHeader,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Date: ${salesReportState.filterCustomerList[index].billDate}',
                                          style: const TextStyle(fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Amount",
                                          style: cardTextStyleSalePurchase,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          salesReportState.filterCustomerList[index].netAmount.toString(),
                                          style:cardTextStyleSalePurchase,
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
                  )
                ),
              ],

            ),
            bottomNavigationBar: Container(
              height: 50,
              padding: const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 5),
              decoration: ContainerDecoration.decoration(
                // color: borderColor, bColor: borderColor
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                color: Colors.green,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",style: cardTextStyleHeader,),
                  Text(salesReportState.totalAmount.toStringAsFixed(2),style: cardTextStyleHeader,),
                ],
              ),
            ),
          ),
          if (salesReportState.isLoading) Center(child: LoadingScreen.loadingScreen())
        ],
      );
    },);
  }
}
