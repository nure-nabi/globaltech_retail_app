
import 'package:retail_app/services/api/api_provider.dart';
import 'package:retail_app/src/purchase_report/model/purchase_report_model.dart';
import 'package:retail_app/utils/custom_log.dart';

class PurchaseReportAPI {
  static Future<PurchaseModel> apiCall({required String databaseName,required String? unitCode}) async {
    var jsonData = await APIProvider.getAPI(
      endPoint:
      "MasterList/MobileLastThirtyDaysPurchaseReport?DbName=$databaseName&Brcode=$unitCode",
    );

    CustomLog.successLog(value: "RESPONSE => $jsonData");

    return PurchaseModel.fromJson(jsonData);
  }
}