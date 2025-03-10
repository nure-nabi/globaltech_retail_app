import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/ledger_report_party/ledger_report_party_state.dart';
import 'package:retail_app/src/ledger_report_party_bill/ledger_report_party_bill_screen.dart';
import 'package:retail_app/themes/themes.dart';
import 'package:retail_app/widgets/text_field_decoration.dart';
import 'package:retail_app/widgets/widgets.dart';

import '../../constants/text_style.dart';
import '../ledger_report_party_bill/ledger_report_party_bill.dart';


class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key,});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Provider.of<CustomerState>(context, listen: false).getContext = context;
  }

  @override
  Widget build(BuildContext context) {
    final stateLedger =  Provider.of<LedgerReportPartyBillState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title:  Text('Customer',style: cardTextStyleHeader,),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Consumer<CustomerState>(
        builder: (context, customerState, _) {
          if (customerState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8,right: 8,bottom: 5,top: 5),
                  child: TextFormField(
                    onChanged: (value) {
                      customerState.filterCustomerListScreen = value;
                      setState(() {});
                    },
                    decoration: TextFormDecoration.decoration(
                      hintText: "Search Customer",
                      hintStyle: hintTextStyle,
                      prefixIcon: Icons.search,
                    ),
                  ),
                ),
                Expanded(
                  child:customerState.filterCustomerList.isNotEmpty
                      ? ListView.builder(
                    itemCount: customerState.filterCustomerList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Color bgColor = index.isEven ? Colors.white : Colors
                          .grey[200]!;
                      var indexData = customerState.filterCustomerList[index];
                      return InkWell(
                        onTap: () {
                         // stateLedger.getDataMappingData = "noDateWise";
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LedgerReportPartyBillScreen(glCode: customerState.filterCustomerList[index].glCode,customerName: customerState.filterCustomerList[index].glDesc),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 3.0),
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
                                    offset: const Offset(0,
                                        3), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: 100.0,
                              width: double.infinity,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Expanded(

                                        flex:3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            Text(
                                              'Customer: ${customerState.filterCustomerList[index].glDesc}',
                                              style: cardTextStyleHeaderCompany,
                                            ),
                                            Text(
                                              'Address: ${customerState.filterCustomerList[index].glCode}',
                                              style: const TextStyle(
                                                fontSize: 14.0,),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Pan No: ${customerState.filterCustomerList[index].panNo}',
                                              style: const TextStyle(
                                                  fontSize: 14.0),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Mobile no: ${customerState.filterCustomerList[index].mobileNo}',
                                              style: const TextStyle(
                                                  fontSize: 14.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Center(
                                            child: Text(customerState.filterCustomerList[index].amount,style: cardTextStyleSalePurchase,),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      );
                    },
                  )   : const NoDataWidget(),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        height: 50,
          padding: const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 5),
          decoration: ContainerDecoration.decoration(
            // color: borderColor, bColor: borderColor
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
            color: Colors.green,
          ),
        child: Consumer<CustomerState>(
          builder: (context,state, _){
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //  crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                 Text("Total",style:cardTextStyleHeader,),
                 Text(state.totalCustomerAmount.toStringAsFixed(2),style:  cardTextStyleHeader,),
              ],
            );
          },
        ),
      ),
    );
  }
}