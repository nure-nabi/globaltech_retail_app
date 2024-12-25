import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/config/app_detail.dart';
import 'package:retail_app/constants/text_style.dart';
import 'package:retail_app/services/sharepref/sharepref.dart';
import 'package:retail_app/src/branch/screen/branch_screen.dart';
import 'package:retail_app/src/index/greeting.dart';
import 'package:retail_app/src/index/index_state.dart';
import 'package:retail_app/src/purchase_report/purchase_report_state.dart';
import 'package:retail_app/src/salesreport/model/sales_report_model.dart';
import 'package:retail_app/src/salesreport/sales_report_state.dart';
import 'package:retail_app/themes/themes.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import '../../services/router/router_name.dart';
import '../branch/branch_state.dart';
import '../purchase_report/model/purchase_report_model.dart';
import 'components/drawer.dart';
import 'components/grid_section.dart';
import 'model/customer_vendor_total_amount_model.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  bool showAmount = false;

  String unitCode = "";
  late Duration difference;
  @override
  void initState() {
    super.initState();
    // Initialize states
    Provider.of<IndexState>(context, listen: false).getContext = context;
    Provider.of<PurchaseReportState>(context, listen: false).getContext =
        context;
    Provider.of<SalesReportState>(context, listen: false).getContext = context;
    Provider.of<SalesReportState>(context, listen: false).getSaleTotalFromDB();
    Provider.of<BranchState>(context, listen: false).getContext = context;

    showUnitCode();
    showDateExpiryCompany();
    /// PRINTER BIND
    _bindingPrinter().then((bool? isBind) async {
      if (isBind!) {
        _getPrinterStatus();
      }
    });
  }

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  /// you can get printer status
  Future<void> _getPrinterStatus() async {
    /* final PrinterStatus result =  */ await SunmiPrinter.getPrinterStatus();
    setState(() {});
  }
  Future<void> onBack() async {
    await SystemNavigator.pop();
  }

  showUnitCode() async {
    unitCode = await GetAllPref.unitCode();
  }

  showDateExpiryCompany() async {


    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('MM/dd/yyyy');
    String formattedDate = formatter.format(now);

    String dateString1 = formattedDate;
    String dateString2 = await GetAllPref.getEndDate();
    DateTime date1 = DateFormat('MM/dd/yyyy').parse(dateString1);
    DateTime date2 = DateFormat('MM/dd/yyyy').parse(dateString2);
     difference = date2.difference(date1);
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final state = context.watch<BranchState>();
    final stateAuth =Provider.of<IndexState>(context, listen: false);
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        // return PopSys;
      },
      child: Consumer4<IndexState, PurchaseReportState, SalesReportState,
          BranchState>(
        builder: (context, indexState, purchaseState, saleState, branchState,
            child) {
          return Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(AppDetails.appName),
                //   Text(state.companyDetail.companyName,maxLines: 1,style: cardTextStyleHeader,),
                //   const SizedBox(height: 3,),
                //   Text('Licence will be expire in ${difference.inDays} days',maxLines: 1,style: const TextStyle(fontSize: 16,color: Colors.red,overflow: TextOverflow.ellipsis),),
                ],
              ),
              backgroundColor: primaryColor,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () async => stateAuth.logOut(context),
                    child: const Icon(Icons.logout, color: Colors.red),
                  ),
                ),
              ],
            ),
            drawer: const DrawerSection(),
            body: ListView(
              shrinkWrap: true,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        height: 120,
                      ),
                    ),
                    Positioned(
                      top: 26,
                      left: 32,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const GreetingText(),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            'Company: ${indexState.companyDetail.companyName}',
                            style: cardTextStyleHeader,
                          ),
                          const SizedBox(
                            height: 14.0,
                          ),
                          Row(
                            children: [
                              Text(
                                'Unit: ${unitCode != "" ? unitCode : "Main"}',
                                style: cardTextStyleHeader,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              unitCode != ""
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: const BranchListScreen(
                                              automaticallyImplyLeading: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Text(
                                          'Switch Unit',
                                          style: cardTextStyleHeader,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: Text("Total", style: cardTextStyleTitle),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: Row(
                    children: [
                      Expanded(
                          child: FutureBuilder<List<SalesDataModel>>(
                        future: saleState.getSalesFromAPI(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List<SalesDataModel> salesList = snapshot.data!;
                            double amtTotalSale = 0;
                            for (int i = 0; i < salesList.length; i++) {
                              amtTotalSale += salesList[i].netAmount;
                            }
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, salesReportPath,
                                    arguments: {"Customer"});
                              },
                              child: Card(
                                elevation: 4,
                                // Set elevation for the card
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Set border radius for the card
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      // Image.asset("assets/images/sales.png",height: 30,width: 30,),
                                      Text(
                                          "Sales: ${amtTotalSale.toStringAsFixed(2)}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: cardTextStyleSalePurchase),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return Shimmer.fromColors(
                            baseColor: Colors.black.withOpacity(0.10),
                            highlightColor: Colors.white.withOpacity(0.6),
                            period: const Duration(seconds: 2),
                            child: Container(
                              margin: const EdgeInsets.only(right: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(0.9)),
                              //   elevation: 4,
                              // Set elevation for the card
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(10),
                              //  // color: Colors.grey.withOpacity(0.9)
                              //   // Set border radius for the card
                              // ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Text("",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: cardTextStyleSalePurchase),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                      //const SizedBox(width: 3,),
                      Expanded(
                          child: FutureBuilder<List<PurchaseDataModel>>(
                        future: purchaseState.getPurchaseAmountFromAPI(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List<PurchaseDataModel> purchaseList =
                                snapshot.data!;
                            double amtTotalPurchase = 0;
                            for (int i = 0; i < purchaseList.length; i++) {
                              amtTotalPurchase += purchaseList[i].netAmt;
                            }
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, purchaseReportPath,
                                    arguments: {"Customer/Vendor"});
                              },
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                      "Purchase: ${amtTotalPurchase.toStringAsFixed(2)}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: cardTextStyleSalePurchase),
                                ),
                              ),
                            );
                          }
                          return Shimmer.fromColors(
                            baseColor: Colors.black.withOpacity(0.10),
                            highlightColor: Colors.white.withOpacity(0.6),
                            period: const Duration(seconds: 2),
                            child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(0.9)),
                              //   elevation: 4,
                              // Set elevation for the card
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(10),
                              //  // color: Colors.grey.withOpacity(0.9)
                              //   // Set border radius for the card
                              // ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Text("",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: cardTextStyleSalePurchase),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                FutureBuilder<List<CustomerVendorAmountDataModel>>(
                    future: indexState.getCustomerVendorAmountFromAPI(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        List<CustomerVendorAmountDataModel> CustomerList =
                            snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, ledgerReportPath);
                                    },
                                    child: Card(
                                      elevation: 4,
                                      // Set elevation for the card
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Set border radius for the card
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                            "Customer: ${CustomerList.length == 0 ? "0.0" : CustomerList[2].amount}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: cardTextStyleSalePurchase),
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, vendorReportLedger);
                                    },
                                    child: Card(
                                      elevation: 4,
                                      // Set elevation for the card
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Set border radius for the card
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                            "Vendor: ${CustomerList.length == 0 ? "0.0" : CustomerList[3].amount}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: cardTextStyleSalePurchase),
                                      ),
                                    ),
                                  ))
                                ],
                              )
                            ],
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Shimmer.fromColors(
                                  baseColor: Colors.black.withOpacity(0.10),
                                  highlightColor: Colors.white.withOpacity(0.6),
                                  period: const Duration(seconds: 2),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(0.9)),
                                    //   elevation: 4,
                                    // Set elevation for the card
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //  // color: Colors.grey.withOpacity(0.9)
                                    //   // Set border radius for the card
                                    // ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Text("",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: cardTextStyleSalePurchase),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                    child: Shimmer.fromColors(
                                  baseColor: Colors.black.withOpacity(0.10),
                                  highlightColor: Colors.white.withOpacity(0.6),
                                  period: const Duration(seconds: 2),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(0.9)),
                                    //   elevation: 4,
                                    // Set elevation for the card
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //  // color: Colors.grey.withOpacity(0.9)
                                    //   // Set border radius for the card
                                    // ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Text("",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: cardTextStyleSalePurchase),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                              ],
                            )
                          ],
                        ),
                      );
                    }),

                const SizedBox(
                  height: 5,
                ),
                //Dashboard
                const Padding(
                  padding: EdgeInsets.only(left: 14, right: 14, bottom: 10),
                  child: HomeGridSection(),
                ),
                // Center(
                //   child: SizedBox(
                //     width: width < 400 ? width * 0.90 : width / 1.5,
                //     child: const HomeGridSection(),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
