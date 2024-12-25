import 'package:retail_app/src/sales/model/temp_product_sales_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../services/services.dart';
import '../../../utils/utils.dart';
import '../model/purchase_temp_model.dart';


class TempPurchaseOrderDatabase {
  Database? db;

  TempPurchaseOrderDatabase._privateConstructor();

  static final TempPurchaseOrderDatabase instance =
  TempPurchaseOrderDatabase._privateConstructor();

  Future<int> insertData(TempPurchaseOrderModel data) async {
    db = await DatabaseHelper.instance.database;

    CustomLog.actionLog(value: "Product Added purchase order inserted  => ${data.toJson()} ");
    return await db!.insert(
      DatabaseDetails.tempPurchaseOrderProductTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future deleteData() async {
    db = await DatabaseHelper.instance.database;
    return await db!
        .rawQuery(''' DELETE FROM ${DatabaseDetails.tempPurchaseOrderProductTable} ''');
  }

  Future deleteDataByID(String id) async {
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(
        ''' DELETE FROM ${DatabaseDetails.tempPurchaseOrderProductTable} WHERE ${DatabaseDetails.pCode} = "$id" ''');
  }

  Future dublicateExit(String productId) async {
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(
        ''' DELETE  FROM ${DatabaseDetails.tempPurchaseOrderProductTable} WHERE Id = "$productId" ''');
  }

  Future<List<TempPurchaseOrderModel>> editDataById(
      {required String productID,
        required String rate,
        required String quantity}) async {
    db = await DatabaseHelper.instance.database;
    String totalAmount =
    (double.parse(rate) * double.parse(quantity)).toStringAsFixed(2);
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(
        ''' UPDATE ${DatabaseDetails.tempPurchaseOrderProductTable} SET ${DatabaseDetails.rate} = "$rate",
         ${DatabaseDetails.qty}  = "$quantity", ${DatabaseDetails.totalAmount} = "$totalAmount" 
          WHERE ${DatabaseDetails.pCode} = "$productID"  ''');

    CustomLog.successLog(value: "MapData => $mapData");

    return List.generate(mapData.length, (i) {
      return TempPurchaseOrderModel.fromJson(mapData[i]);
    });
  }

  Future<List<TempPurchaseOrderModel>> getAllProductList() async {
    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(
        ''' SELECT * FROM ${DatabaseDetails.tempPurchaseOrderProductTable} ''');

    CustomLog.successLog(
      value:
      "QUERY =>  SELECT * FROM ${DatabaseDetails.tempPurchaseOrderProductTable} ",
    );
    CustomLog.successLog(value: "MapData => $mapData");

    return List.generate(mapData.length, (i) {
      return TempPurchaseOrderModel.fromJson(mapData[i]);
    });
  }
}
