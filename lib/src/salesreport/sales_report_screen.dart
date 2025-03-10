
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/sales_bill_report/sales_bill_report_screen.dart';

import 'package:retail_app/src/salesreport/sales_report_state.dart';
import 'package:retail_app/src/salesreport/test_screen.dart';
import 'package:retail_app/themes/colors.dart';
import 'package:retail_app/themes/themes.dart';
import 'package:retail_app/utils/loading_indicator.dart';

import '../../constants/text_style.dart';
import '../../services/sharepref/set_all_pref.dart';
import '../../widgets/alert/show_alert.dart';
import '../../widgets/container_decoration.dart';
import '../../widgets/no_data_widget.dart';
import '../../widgets/text_field_decoration.dart';
import '../datepicker/date_picker_screen.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({Key? key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {


  List<String> items = List.generate(20, (index) => 'Item $index');
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      items = List.generate(20, (index) => 'Refreshed Item $index');
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<SalesReportState>(context, listen: false).getContext = context;
   // Provider.of<SalesReportState>(context, listen: false).getSaleTotalFromDB();

  }

  @override
  Widget build(BuildContext context) {
  final salesReportState =  Provider.of<SalesReportState>(context, listen: true);
  return Stack(
    children: [
      Scaffold(
        appBar: AppBar(
          title:  Text('Sales Report',style: cardTextStyleHeader,),
          backgroundColor: Colors.green,
          actions: [
            // IconButton(onPressed: (){}, icon: Icon(Icons.calendar_month)),
            const SizedBox(width: 3.0,),
            IconButton(onPressed: () async {
              ShowAlert(context).alert(
                child: DatePickerWidget(
                  onConfirm: () async {
                    await salesReportState.onDatePickerConfirm();
                    salesReportState.init();
                    setState(() {});
                  },
                ),
              );
            }, icon: const Icon(Icons.calendar_month)),
            const SizedBox(width: 10,),
            // IconButton(onPressed: (){
            //   salesReportState.shareLedger();
            // },
            //     icon: const Icon(Icons.share)),
            const SizedBox(width:3.0,),
            IconButton(onPressed: () async {
              salesReportState.clean();
              salesReportState.init();
              // await salesReportState.getSalesReportFromAPI();
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
                            padding:  EdgeInsets.fromLTRB(15.0,0.0, 15.0, 0.0),
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
  }
}