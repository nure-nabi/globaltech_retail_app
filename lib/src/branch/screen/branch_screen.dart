import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/services/services.dart';
import 'package:retail_app/services/sharepref/set_all_pref.dart';
import 'package:retail_app/src/branch/branch_state.dart';
import 'package:retail_app/src/branch/model/branch_model.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/themes/themes.dart';
import 'package:retail_app/widgets/no_data_widget.dart';

import '../../../constants/text_style.dart';
import '../../../services/router/router_name.dart';
import '../../index/index.dart';
import '../../ledger_report_party_bill/db/ledger_report_party_bill_db.dart';
import '../../provider/dashboard_provider.dart';
import '../../purchase/db/ledger_db.dart';
import '../../purchase/db/purchase_product_order_db.dart';
import '../../purchase/db/temp_purchase_order_db.dart';
import '../../sales/db/product_sales_db.dart';
import '../../sales/db/temp_product_sales_db.dart';
import '../../sales_bill_term/db/sales_bill_term_db.dart';
import '../../salesreport/db/sales_report_db.dart';

class BranchListScreen extends StatefulWidget {
  final bool automaticallyImplyLeading;
  const BranchListScreen({super.key,required this.automaticallyImplyLeading});

  @override
  State<BranchListScreen> createState() => _BranchListScreen();
}

class _BranchListScreen extends State<BranchListScreen> {
  late final NavigatorState navigator = Navigator.of(context);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<BranchState>(context, listen: false).getContext = context;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BranchState>();
    return Scaffold(
      appBar: AppBar(
        title:  Text("Unit List",style: cardTextStyleHeader,),
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: state.branchList.isNotEmpty
          ? ListView.builder(
              itemCount: state.branchList.length,
              itemBuilder: (context, index) {
                BranchDetailsModel branchDetail = state.branchList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  elevation: 4, // Add elevation for a card-like appearance
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: () async {
                      await SetAllPref.unitCode(value: branchDetail.unitCode);
                      state.getUnitCode = branchDetail.unitCode;
                   //  clareData(stateIndex);
                      navigator.pushReplacementNamed(indexPath);
                      //  await onListClicked(context, detailsModel: companyDetail);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Desc: ${branchDetail.unitDesc}',
                            style: cardTextStyleHeaderCompany,
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Text(
                                'Unit: ${branchDetail.unitCode}',
                                style: cardTextStyleSalePurchase,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const NoDataWidget(),
    );
  }

  void clareData(IndexState state) {
    SalesReportDbDatabase.instance.deleteData();
   // state.clearSharePref(context);
    TempProductOrderDatabase.instance.deleteData();
    TempPurchaseOrderDatabase.instance.deleteData();
    ProductOrderDatabase.instance.deleteData();
    PurchaseProductOrderDatabase.instance.deleteData();
    LedgerDatabase.instance.deleteData();
    SalesTermDatabase.instance.deleteData();
    SalesReportDbDatabase.instance.deleteData();
    LedgerReportDatabase.instance.deleteData();
  }
}
