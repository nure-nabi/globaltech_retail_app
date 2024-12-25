import 'package:retail_app/services/api/api_provider.dart';
import 'package:retail_app/src/bill_report/model/bill_report_model.dart';
import 'package:retail_app/utils/custom_log.dart';

class PurchaseReportApi{
  static Future apiCall({
    required String databaseName,
    required String vNo,
    required String unit,
  }) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/ListPurchaseBillPrint?DbName=$databaseName&Brcode=$unit&Vno=$vNo",
    );

    CustomLog.successLog(value: "RESPONSE => $jsonData");

    return PurchaseReportModel.fromJson(jsonData);
  }
}