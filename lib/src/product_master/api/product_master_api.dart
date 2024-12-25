import 'package:retail_app/services/api/api_provider.dart';
import 'dart:convert';
import 'package:retail_app/src/product_master/model/product_master_model.dart';
import 'package:retail_app/src/products/model/product_model.dart';
import 'package:retail_app/utils/custom_log.dart';

import '../../../model/basic_model.dart';

class ProductCreate {
  static  createProduct({
    required ProductMasterModel productDetails,
  }) async {
    var body = jsonEncode({
      "objLedgerDetails": [productDetails.toJson()]
    });

    var jsonData = await APIProvider.postAPI(
      endPoint: "GeneralLedger/SaveProductRelated",
      body: body,
    );
    CustomLog.successLog(value: "RESPONSE Save Data => $jsonData");
    return BasicModel.fromJson(jsonData);
  }
}

class UnitList {
  static unitList({required String dbName}) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/ProductListCustomer?DbName=$dbName",
    );
    CustomLog.successLog(value: "RESPONSE => $jsonData");
    return ProductModel.fromJson(jsonData);
  }
}