import 'dart:convert';

import '../../../model/basic_model.dart';
import '../../../services/api/api_provider.dart';
import '../../../utils/custom_log.dart';
import '../model/account_group_model.dart';
import '../model/account_sub_group_model.dart';

class PurchaseOrderProductAPI {
  static postOrder({required bodyData}) async {
    var body = jsonEncode(bodyData[0]);

    var jsonData = await APIProvider.postAPI(
      endPoint: "Order/SavePurchaseInvoiceNew",
      body: body,
    );
    CustomLog.successLog(value: "RESPONSE Save purchase Data => $jsonData");
    return BasicModel.fromJson(jsonData);
  }

}

class ListAccountGroup {
  static accountGroupList({required String dbName}) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/ListAccountGroup?dbname=$dbName&GrpCode =null",
    );
    CustomLog.successLog(value: "RESPONSE => $jsonData");
    return ResponseModel.fromJson(jsonData);
  }
}
class ListAccountSubGroup {
  static accountSubGroupList({required String dbName}) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/ListAccountSubgroup?dbname=$dbName",
    );
    CustomLog.successLog(value: "RESPONSE => $jsonData");
    return AccountSubGroupModel.fromJson(jsonData);
  }
}
// String apiUrl =
//         "$baseUrl${ApiURL.masterList}ListAccountSubgroup?DbName=$databaseName";