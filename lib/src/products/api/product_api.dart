import 'package:retail_app/utils/custom_log.dart';
import '../../../services/api/api_provider.dart';
import '../model/product_model.dart';

class ProductAPI {
  static getProduct({required String dbName,required String unitCode}) async {

    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/ProductListCustomer?DbName=$dbName&BrCode=$unitCode",
    );
    CustomLog.successLog(value: "RESPONSE => $jsonData");
    return ProductModel.fromJson(jsonData);
  }
}

