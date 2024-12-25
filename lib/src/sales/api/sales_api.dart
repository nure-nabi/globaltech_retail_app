import 'dart:convert';
import 'package:retail_app/src/sales/model/outlet_model.dart';
import '../../../model/model.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

class OrderProductAPI {
  static postOrder({required bodyData}) async {
    var body = jsonEncode(bodyData[0]);

    var jsonData = await APIProvider.postAPI(
      endPoint: "Order/SaveSalesInvoiceNew",
      body: body,
    );
    CustomLog.successLog(value: "RESPONSE Save Data => $jsonData");
    return BasicModel.fromJson(jsonData);
  }
}

class OutletList {
  static partyList({required String dbName}) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "generalledger/LedgerList?dbname=$dbName",
    );
    CustomLog.successLog(value: "RESPONSE => $jsonData");
    return OutletModel.fromJson(jsonData);
  }
}
