import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retail_app/src/sales/model/post_sales_model.dart';
import 'package:retail_app/src/sales/model/product_sales_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../services/services.dart';
import '../../../utils/utils.dart';

class ProductOrderDatabase {
  Database? db;

  ProductOrderDatabase._privateConstructor();

  static final ProductOrderDatabase instance =
      ProductOrderDatabase._privateConstructor();

  Future<int> insertData(ProductOrderModel data) async {
    db = await DatabaseHelper.instance.database;

    CustomLog.actionLog(value: "Product Added => ${data.toJson()} ");
    return await db!.insert(
      DatabaseDetails.orderProductTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  Future deleteData() async {
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(''' DELETE FROM ${DatabaseDetails.orderProductTable} ''');
  }

  Future<List<ProductOrderModel>> getAllProductAndBillWiseList() async {
    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(
        ''' SELECT * FROM ${DatabaseDetails.orderProductTable} ''');

    CustomLog.successLog(
      value:
      "QUERY =>  SELECT * FROM ${DatabaseDetails.orderProductTable} ",
    );
    CustomLog.successLog(value: "MapData => $mapData");

    return List.generate(mapData.length, (i) {
      return ProductOrderModel.fromJson(mapData[i]);
    });
  }

  Future<List<ProductOrderModel>> getProductAlready(
      {required String pcode}) async {
    db = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> mapData = await db!.rawQuery('''SELECT * FROM ${DatabaseDetails.orderProductTable} WHERE id =${pcode} ''');

    CustomLog.successLog(value: "MapData => $mapData");

    return List.generate(mapData.length, (i) {
      return ProductOrderModel.fromJson(mapData[i]);
    });
  }

  Future<List<ProductOrderModel>> getQRProduct({
    required String qrCode,
  }) async {
    String myQuery =
    '''  SELECT * FROM ${DatabaseDetails.orderProductTable} WHERE ${DatabaseDetails.itemCode} = "$qrCode" ''';
    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);
    CustomLog.errorLog(value: "MapData => $mapData");
    return List.generate(mapData.length, (i) {
      return ProductOrderModel.fromJson(mapData[i]);
    });
  }

    Future<List<OrderPostModel>> getPostDataASFormatNeeded({
    required String dbName,
    required String unitCode,
    required String salesImage,
    required String  imagePath,
    required String  companyInitial,
  }) async {
    String myQuery = ''' 
      SELECT  
        '[' || GROUP_CONCAT('{
                        "OutletCode":"' || OutletCode || '",
                        "Unit":"' || Unit || '",
                        "BTerm1":"' || BTerm1 || '",
                        "PayAmount":"' || PayAmount || '",
                        "BTerm1Rate":"' || BTerm1Rate || '",
                        "BTerm1Amount":"' || BTerm1Amount || '",
                        "BTerm2":"' || BTerm2 || '",
                        "BTerm2Rate":"' || BTerm2Rate || '",
                        "BTerm2Amount":"' || BTerm2Amount || '",
                        "BTerm3":"' || BTerm3 || '",
                        "BTerm3Rate":"' || BTerm3Rate || '",
                        "BTerm3Amount":"' || BTerm3Amount || '",
                        "BillNetAmt":"' || BillNetAmt || '",
                        "UserCode":"' || UserCode || '",
                        "CashGlCode":"' || CashGlCode || '",
                        "Comment":"' || Remarks || '",
                        "ItemDetails":' || ItemDetails ||
             '}') || ']' AS OrderDetails
      FROM   
    (SELECT ${DatabaseDetails.outletCode} AS OutletCode,
     ${DatabaseDetails.unit} AS Unit,
     ${DatabaseDetails.bTerm1} AS BTerm1,
     ${DatabaseDetails.payAmount} AS PayAmount,
     ${DatabaseDetails.bTerm1Rate} AS BTerm1Rate,
     ${DatabaseDetails.bTerm1Amount} AS BTerm1Amount,
     ${DatabaseDetails.bTerm2} AS BTerm2,
     ${DatabaseDetails.bTerm2Rate} AS BTerm2Rate,
     ${DatabaseDetails.bTerm2Amount} AS BTerm2Amount,
     ${DatabaseDetails.bTerm3} AS BTerm3,
     ${DatabaseDetails.bTerm3Rate} AS BTerm3Rate,
     ${DatabaseDetails.bTerm3Amount} AS BTerm3Amount,
     SUM(BillNetAmt) AS BillNetAmt,
     ${DatabaseDetails.userCode} AS UserCode,
     ${DatabaseDetails.remark} AS Remarks,
     ${DatabaseDetails.paymentMode} AS CashGlCode,
     
              '[' || GROUP_CONCAT('{
                             "itemCode":"'|| itemCode ||'",
                             "qty":"' || Qty || '",
                             "rate":"' || rate || '",
                             "totalAmt":"' || totalAmt || '",
                             "AltUnit":"' || AltUnit || '",
                             "AltQty":"' || AltQty || '",
                             "PTerm1Code":"' || PTerm1Code || '",
                             "PTerm1Rate":"' || PTerm1Rate || '",
                             "PTerm1Amount":"' || PTerm1Amount || '",
                             "PTerm2Code":"' || PTerm2Code || '",
                             "PTerm2Rate":"' || PTerm2Rate || '",
                             "PTerm2Amount":"' || PTerm2Amount || '",
                             "PTerm3Code":"' || PTerm3Code || '",
                             "PTerm3Rate":"' || PTerm3Rate || '",
                             "PTerm3Amount":"' || PTerm3Amount || '",
                             "godownCode":"' || godownCode || '"
                           }') || ']' AS ItemDetails
    FROM OrderProductInfo
) 
  ''';


    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);

    if (mapData.isEmpty) {
      return [];
    }

    return List.generate(mapData.length, (i) {
      CustomLog.successLog(value: "MapData1 SALES ORDER => ${mapData[0]}");
      debugPrint( mapData[0].toString());
      return OrderPostModel.fromJson({
        "DbName": dbName,
        "SalesImage": salesImage,
       // "ImagePath": imagePath+"attachments/"+ companyInitial+"/",
        "ImagePath": imagePath,
        "OrderDetails":jsonDecode( mapData[i]['OrderDetails']),
      });
    });

  }
}
