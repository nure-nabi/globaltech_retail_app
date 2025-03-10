import 'package:retail_app/services/api/api_provider.dart';
import 'package:retail_app/src/salesreport/model/sales_report_model.dart';
import 'package:retail_app/utils/custom_log.dart';

class SalesReportApi{
  static Future<SalesModel> apiCall({required String databaseName,required String unitCode}) async{
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/MobileLastThirtyDaysSalesReport?DbName=$databaseName&Brcode=$unitCode");
    CustomLog.successLog(value: "RESPONSE Sales Report Unit => $jsonData");
    return SalesModel.fromJson(jsonData);
  }
}

// 1 change initila
// 2 change initila// 2 change initila master