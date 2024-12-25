import 'dart:ui';


import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/component/dialog/widget/option_selection.dart';

import '../../constants/values.dart';
import '../../services/router/router_name.dart';
import '../../src/branch/model/branch_model.dart';
import '../../src/ledger_report_party_bill/ledger_report_party_bill.dart';
import '../../src/ledger_report_party_bill/provider/data_provider.dart';
import '../../src/ledger_report_party_bill/provider/report_provider.dart';
import '../../storage/hive_storage.dart';
import 'option_dialog_custom_option.dart';

 showInformationDialog(
  BuildContext parentContext,
  OptionDialogCustomOption optionDialogCustomOption,
  String modalTitle,
) async {
  return await showDialog(
    context: parentContext,
    barrierDismissible: false,
    builder: (context) {
      final previousReport = Provider.of<ReportProvider>(context, listen: true);
      final reportLedger = Provider.of<LedgerReportPartyBillState>(context, listen: true);
      final dataProvider = Provider.of<DataProvider>(context, listen: false);

      bool isAltQty = previousReport.isAltQty;
      NepaliDateTime fromDateNep = previousReport.fromDateNep;
      NepaliDateTime toDateNep = previousReport.toDateNep;
      DateTime fromDateEng = previousReport.fromDateEng;
      DateTime toDateEng = previousReport.toDateEng;
      AccountingPeriod chosenDate = previousReport.chosenDate;
      NepaliDateTime selectedFromDateNep = previousReport.selectedFromDateNep;
      NepaliDateTime selectedToDateNep = previousReport.selectedToDateNep;
      bool isDetails = previousReport.isDetails;
      bool isOnlyZero = previousReport.isOnlyZero;
      bool isDateType = previousReport.isDateType;
      bool isHorizontal = previousReport.isHorizontal;
      bool isDisabledCheckDetails = previousReport.isDisabledCheckDetails;
      String ledgerId = previousReport.ledgerId;
      String ledgerName = previousReport.ledgerName;
      bool isZeroBalance = previousReport.isZeroBalance;
      bool isSummary = previousReport.isSummary;
      bool isNarration = previousReport.isNarration;
      bool isNarrationInColumn = previousReport.isNarrationInColumn;
      bool isProductDetails = previousReport.isProductDetails;
      bool isSelectAll = previousReport.isSelectAll;
      bool isRemarks = previousReport.isRemarks;
      bool isSubLedger = previousReport.isSubLedger;
      bool isMergeSales = previousReport.isMergeSales;
      bool mergeCustomerVendor = previousReport.mergeCustomerVendor;
      String? voucherNumbers = previousReport.voucherNumbers;
      String reportTypeForCashBook = previousReport.reportTypeForCashBook;
      String reportTypeForBankBook = previousReport.reportTypeForBankBook;
      String reportTypeForCashFlow = previousReport.reportTypeForCashFlow;
      String reportTypeForBankFlow = previousReport.reportTypeForBankFlow;
      String reportTypeForBalanceSheet = previousReport.reportTypeForBalanceSheet;
      String chosenStatus = previousReport.chosenStatus;
      String depositType = previousReport.depositType;
      bool includeLedger = previousReport.includeLedger;
      bool includeSubLedger = previousReport.includeSubLedger;
      bool isDepartment = previousReport.isDepartment;
      bool isMergeCustomerVendor = previousReport.isMergeCustomerVendor;
      bool isLedger = previousReport.isLedger;
      bool isSortDrCr = previousReport.isSortDrCr;
      bool isOpeningOnly = previousReport.isOpeningOnly;
      bool isIncludeClosingStock = previousReport.isIncludeClosingStock;
      bool isDisableCheckedOpeningOnly = previousReport.isDisableCheckedOpeningOnly;
      bool isRepostValue = previousReport.isRepostValue;
      String groupByForSales = previousReport.groupByForSales;
      String groupByForPurchase = previousReport.groupByForPurchase;
      String groupByForCashBook = previousReport.groupByForCashBook;
      String groupByForBankBook = previousReport.groupByForBankBook;
      String groupByForLedgers = previousReport.groupByForLedgers;
      String groupByForStock = previousReport.groupByForStock;
      String groupByForProfitLoss = previousReport.groupByForProfitLoss;
      String groupByForTrialBalance = previousReport.groupByForTrialBalance;
      String groupByForBalanceSheet = previousReport.groupByForBalanceSheet;
      String groupWiseByRestaurantLog = previousReport.groupWiseByRestaurantLog;
      List<BranchModel> branchList = previousReport.branchList;
      int branchId = previousReport.branchId;

      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          title: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.green),
                  const SizedBox(width: 10),
                  Text(
                    modalTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Visibility(
                visible: false,
                child: Row(
                  children: [
                    Text(
                      'Branch',
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // SizedBox(
                    //     width: 150,
                    //     child: FutureBuilder<BranchListResponseModel>(
                    //       future: BranchListService().getBranchList(BranchListRequestModel(
                    //         dbName: HiveStorage.get(UserKey.databaseName.name),
                    //       )),
                    //       builder: (context, snapshot) {
                    //         final data = snapshot.data;
                    //         final error = snapshot.error;
                    //
                    //         if (data != null) {
                    //           return Consumer<ReportProvider>(builder: (_, reportProvider, __) {
                    //             reportProvider.branchList = data.branchList;
                    //             return DropdownButtonHideUnderline(
                    //               child: DropdownButton2<BranchModel>(
                    //                 isExpanded: true,
                    //                 hint: const Text('Select Branch'),
                    //                 value: reportProvider.branchList.where((branch) => branch.branchId == reportProvider.branchId).isEmpty ? null : reportProvider.branchList.where((branch) => branch.branchId == reportProvider.branchId).first,
                    //                 onChanged: (branch) {
                    //                   if (branch != null) {
                    //                     reportProvider.branchId = branch.branchId;
                    //                     HiveStorage.add(UserKey.branchId.name, branch.branchId.toString());
                    //                     HiveStorage.add(UserKey.branchDescription.name, branch.branchName.toString());
                    //                   }
                    //                 },
                    //                 items: reportProvider.branchList.map((BranchModel branchModel) {
                    //                   return DropdownMenuItem<BranchModel>(
                    //                     value: branchModel,
                    //                     child: Text(branchModel.branchName, overflow: TextOverflow.ellipsis),
                    //                   );
                    //                 }).toList(),
                    //
                    //                 buttonStyleData: ButtonStyleData(
                    //                   height: 35,
                    //                   width: 160,
                    //                   padding: const EdgeInsets.only(left: 14, right: 14),
                    //                   decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(14),
                    //                     border: Border.all(color: Colors.grey),
                    //                   ),
                    //                   elevation: 0,
                    //                 ),
                    //                 iconStyleData: const IconStyleData(
                    //                   icon: Icon(Icons.arrow_forward_ios_outlined),
                    //                   iconSize: 14,
                    //                 ),
                    //                 menuItemStyleData: const MenuItemStyleData(
                    //                   height: 35,
                    //                   padding: EdgeInsets.only(left: 14, right: 14),
                    //                 ),
                    //                 dropdownStyleData: DropdownStyleData(
                    //                   maxHeight: 300,
                    //                   width: 180,
                    //                   padding: EdgeInsets.zero,
                    //                   decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(14),
                    //                   ),
                    //                   elevation: 1,
                    //                   scrollbarTheme: ScrollbarThemeData(
                    //                     radius: const Radius.circular(40),
                    //                     thickness: MaterialStateProperty.all(1),
                    //                     thumbVisibility: MaterialStateProperty.all(true),
                    //                   ),
                    //                 ),
                    //
                    //                 // offset: const Offset(-20, 0),
                    //               ),
                    //             );
                    //           });
                    //         }
                    //         if (error != null) {
                    //           print(error);
                    //         }
                    //         return const SizedBox();
                    //       },
                    //     ))
                  ],
                ),
              )
            ],
          ),
          content: OptionSelection(optionDialogCustomOption, parentContext),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                previousReport.fromDateNep = fromDateNep;
                previousReport.toDateNep = toDateNep;
                 previousReport.fromDateEng = fromDateEng;
                previousReport.toDateEng = toDateEng;
                previousReport.chosenDate = chosenDate;
                previousReport.selectedFromDateNep = selectedFromDateNep;
                previousReport.selectedToDateNep = selectedToDateNep;
             //   appRouter.pop(false);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text(
                'Okay',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () async {
                reportLedger.getDataMappingData = "DateWise";
                previousReport.fromDateEng = fromDateEng;
                previousReport.toDateEng = toDateEng;
               // final routePath = appRouter.current.path.toString();
              //  appRouter.pop(true);
              //  appRouter.pushNamed(routePath);
                String fromDateEng1 = DateFormat('yyyy-MM-dd').format(previousReport.fromDateEng);
                String toDateEng1 = DateFormat('yyyy-MM-dd').format(previousReport.toDateEng);
                reportLedger.getLedgerDateWiseFromDB(fromDateEng1,toDateEng1);
                Navigator.pop(context);
               // Navigator.pushNamed(context, ledgerReportPartyBillScreen);

              },
            ),
          ],
        ),
      );
    },
  );
}

