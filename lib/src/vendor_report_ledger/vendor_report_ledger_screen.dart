import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/vendor_report_bill/vendor_report_bill_screen.dart';
import 'package:retail_app/src/vendor_report_ledger/vendor_report_ledger_state.dart';
import 'package:retail_app/themes/themes.dart';
import 'package:retail_app/widgets/widgets.dart';

import '../../constants/text_style.dart';


class VendorReportLedgerScreen extends StatefulWidget {
  VendorReportLedgerScreen({super.key});

  @override
  State<VendorReportLedgerScreen> createState() => _VendorReportLedgerScreenState();
}

class _VendorReportLedgerScreenState extends State<VendorReportLedgerScreen> {

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Provider.of<VendorReportLedgerState>(context, listen: false).getContext = context;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<VendorReportLedgerState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title:  Text('Vendor',style: cardTextStyleHeader,),
        backgroundColor: primaryColor,
      ),
      body: Consumer<VendorReportLedgerState>(
        builder: (context, vendorState, _) {
          if (vendorState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8,right: 8,bottom: 5,top: 5),
                  child: TextFormField(
                    onChanged: (value) {
                      vendorState.filterVendorList = value;
                      setState(() {});
                    },
                    decoration: TextFormDecoration.decoration(
                      hintText: "Search List",
                      hintStyle: hintTextStyle,
                      prefixIcon: Icons.search,
                    ),
                  ),
                ),
                Expanded(
                  child:vendorState.filterVendorList.isNotEmpty
                      ? ListView.builder(
                    itemCount: vendorState.filterVendorList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Color bgColor = index.isEven ? Colors.white : Colors
                          .grey[200]!;
                      var indexData = vendorState.filterVendorList[index];
                      return InkWell(
                        onTap: () {
                          // stateLedger.getDataMappingData = "noDateWise";
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VendorReportBillScreen(glCode: vendorState.filterVendorList[index].glCode,vendorName: vendorState.filterVendorList[index].glDesc),
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
                                              'Vendor: ${indexData.glDesc}',
                                              style: cardTextStyleHeaderCompany,
                                            ),
                                            Text(
                                              'Address: ${vendorState.filterVendorList[index].glCode}',
                                              style: const TextStyle(
                                                fontSize: 14.0,),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Pan No: ${vendorState.filterVendorList[index].panNo}',
                                              style: const TextStyle(
                                                  fontSize: 14.0),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Mobile no: ${vendorState.filterVendorList[index].mobileNo}',
                                              style: const TextStyle(
                                                  fontSize: 14.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Center(
                                            child: Text(vendorState.filterVendorList[index].amount,style: cardTextStyleSalePurchase,),
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
        child: Consumer<VendorReportLedgerState>(
          builder: (context,state, _){
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //  crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Total",style:cardTextStyleHeader,),
                Text(state.totalVendorAmount.toStringAsFixed(2),style:  cardTextStyleHeader,),
              ],
            );
          },
        ),
      ),
    );
  }
}