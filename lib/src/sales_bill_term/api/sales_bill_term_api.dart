import 'package:retail_app/services/api/api_provider.dart';
import 'package:retail_app/src/sales_bill_report/model/sales_bill_report_model.dart';
import 'package:retail_app/utils/custom_log.dart';

import '../model/sales_bill_term_model.dart';

class SalesBillTermApi {
  static getTerm({required String dbName}) async {

    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/SalesBillTermList?DbName=$dbName",
    );
    CustomLog.successLog(value: "RESPONSE => $jsonData");
    return SalesBillTermModel.fromJson(jsonData);
  }
  static getPurchaseTerm({required String dbName}) async {

    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/PurchaseBillTermList?DbName=$dbName",
    );
    CustomLog.successLog(value: "RESPONSE Purchase Bill terl => $jsonData");
    return SalesBillTermModel.fromJson(jsonData);
  }
}

