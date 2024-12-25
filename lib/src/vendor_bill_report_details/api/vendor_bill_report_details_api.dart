import 'package:retail_app/services/api/api_provider.dart';
import 'package:retail_app/src/ledger_report_party_bill/model/cash_Bank_Model.dart';
import 'package:retail_app/utils/custom_log.dart';

import '../../sales_bill_report/sales_bill_report.dart';

class VendorPartyBillDetailsApi {
  static Future apiCall({
    required String databaseName,
    required String vNo,
    required String unit,
  }) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/ListPurchaseBillPrint?DbName=$databaseName&Brcode=$unit&Vno=$vNo",
    );

    CustomLog.successLog(value: "RESPONSE => $jsonData");

    return SalesBillReportModel.fromJson(jsonData);
  }

  static Future cashBankPrint(
      {required String databaseName, required String vNo}) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/ListCashbankPrint?dbname=$databaseName&vno=$vNo",
    );

    CustomLog.successLog(value: "RESPONSE => $jsonData");

    return CashBankPrintModel.fromJson(jsonData);
  }
}