import 'package:retail_app/services/api/api_provider.dart';
import 'package:retail_app/src/sales_bill_report/model/sales_bill_report_model.dart';
import 'package:retail_app/utils/custom_log.dart';

class SalesBillReportApi{
  static Future apiCall({
    required String databaseName,
    required String unit,
    required String billNo,
  }) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/ListSalesBillPrint?DbName=$databaseName&Brcode=$unit&Vno=$billNo",
    );
//http://retailabapi.globaltechsolution.com.np:802/api/MasterList/ListSalesBillPrint?DbName=ABGRP08001&Brcode=Chandeshwori&Vno=3
    CustomLog.successLog(value: "RESPONSE => $jsonData");

    return SalesBillReportModel.fromJson(jsonData);
  }
}