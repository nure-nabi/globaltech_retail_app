import 'package:retail_app/services/api/api_provider.dart';
import 'package:retail_app/src/ledger_report_party/model/ledger_report_party_model.dart';
import 'package:retail_app/utils/custom_log.dart';

class VendorReportLedgerApi{
  static Future apiCall({
    required String databaseName,
    required String category,
    required String unitcode,
  }) async {
    var jsonData = await APIProvider.getAPI(
      endPoint:
      //"MasterList/ListMobileRepLedgerSummary?DbName=$databaseName&Catagory=$category",
      "MasterList/ListMobileRepLedgerSummary?DbName=$databaseName&Catagory=$category&unitcode=$unitcode",

    );

    //http://kkmapi.omsird.com:802/api/MasterList/ListMobileRepLedgerSummary?DbName=kkmpl08101&Catagory=customer&unitcode=headoffice
    CustomLog.successLog(value: "RESPONSE => $jsonData");

    return CustomerModel.fromJson(jsonData, category);
  }
}