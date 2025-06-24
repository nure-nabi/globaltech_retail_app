import 'dart:convert';
import 'package:retail_app/src/sales/model/outlet_model.dart';
import '../../../model/model.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';
import '../model/godown_model.dart';
import '../model/sale_payment_mode.dart';

class OrderProductAPI {
  static postOrder({required bodyData}) async {
    var body = jsonEncode(bodyData[0]);

    var jsonData = await APIProvider.postAPI(
      endPoint: "Order/SaveSalesInvoiceNew1",
     // endPoint: "Order/SaveSalesInvoiceNew",
      body: body,
    );
    CustomLog.successLog(value: "RESPONSE Save Data => $jsonData");
    return BasicModel.fromJson(jsonData);
  }
}

class SalesBillPrintAPI {
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
  static partyList({required  dbName,required unitCode}) async {
    var jsonData = await APIProvider.getAPI(
      //endPoint: "generalledger/LedgerList?dbname=$dbName",
      endPoint: "generalledger/LedgerList?dbname=$dbName&unitCode=$unitCode",
    );
    CustomLog.successLog(value: "RESPONSE => $jsonData");
    return OutletModel.fromJson(jsonData);
  }

}
class SalePaymentMode {
  static paymentMode({required  dbName}) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/SalesPaymentMode?DbName=$dbName",
    );
    CustomLog.successLog(value: "SalePaymentResMode => $jsonData");
    return SalePaymentResModel.fromJson(jsonData);
  }

}

class GodownList {

  static godown({required  dbName}) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/GodownList?DbName=$dbName",
    );
    CustomLog.successLog(value: "GodownList => $jsonData");
    return GodownResModel.fromJson(jsonData);
  }

}
