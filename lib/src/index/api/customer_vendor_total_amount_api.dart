

import '../../../services/services.dart';
import '../../../utils/utils.dart';
import '../model/customer_vendor_total_amount_model.dart';

class CustomerAndVendorAmountApi {
  static Future<CustomerVendorAmountModel> getCustomerAndVendorAmountHomePage({
    required String databaseName,
  }) async {
    var endPoint = "masterlist/ListMobileRepHomePage?Dbname=$databaseName";

    var jsonData = await APIProvider.getAPI(endPoint: endPoint);

    CustomLog.successLog(value: "RESPONSE => $jsonData");

    return CustomerVendorAmountModel.fromJson(jsonData);
  }
}