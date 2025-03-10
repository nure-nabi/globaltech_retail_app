import 'package:retail_app/services/api/api_provider.dart';
import 'package:retail_app/src/sales_bill_report/model/sales_bill_report_model.dart';
import 'package:retail_app/utils/custom_log.dart';

import '../../../model/basic_model.dart';

class SalesBillReportApi{
  static Future apiCall({
    required String databaseName,
    required String unit,
    required String billNo,
  }) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/ListSalesBillPrint?DbName=$databaseName&Brcode=$unit&Vno=$billNo",
    );
    CustomLog.successLog(value: "RESPONSE => $jsonData");

    return SalesBillReportModel.fromJson(jsonData);
  }

  static Future salesBillUpdateApiCall({
    required String databaseName,
    required String billNo,
  }) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/UpdateSalesBillPrintCopy?DbName=$databaseName&Vno=$billNo",
    );
    CustomLog.successLog(value: "RESPONSE => $jsonData");

    return BasicUpdatePrintModel.fromJson(jsonData);
  }
}