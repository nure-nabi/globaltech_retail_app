// http://myomsapi.globaltechsolution.com.np:802/api/MasterList/ListMobileRepLedgerDetailswithoutPDC?DbName=ERPDEMO101&GlCode=24
import 'package:retail_app/services/api/api_provider.dart';
import 'package:retail_app/src/ledger_report_party_bill/model/cash_Bank_Model.dart';
import 'package:retail_app/src/ledger_report_party_bill/model/ledger_report_party_model.dart';
import 'package:retail_app/utils/custom_log.dart';

class VendorReportPartyBillApi{
  static Future apiCall({
    required String databaseName,
    required String glCode,
  }) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/ListMobileRepLedgerDetailswithoutPDC?DbName=$databaseName&GlCode=$glCode",
    );

    CustomLog.successLog(value: "RESPONSE => $jsonData");

    return LedgerPartyReportModel.fromJson(jsonData);
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