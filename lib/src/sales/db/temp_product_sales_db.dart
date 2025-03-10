import 'package:retail_app/src/sales/model/temp_product_sales_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../services/services.dart';
import '../../../utils/utils.dart';


class TempProductOrderDatabase {
  Database? db;

  TempProductOrderDatabase._privateConstructor();

  static final TempProductOrderDatabase instance =
  TempProductOrderDatabase._privateConstructor();

  Future<int> insertData(TempProductOrderModel data) async {
    db = await DatabaseHelper.instance.database;

    CustomLog.actionLog(value: "Product Added => ${data.toJson()} ");
    return await db!.insert(
      DatabaseDetails.tempOrderProductTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future deleteData() async {
    db = await DatabaseHelper.instance.database;
    return await db!
        .rawQuery(''' DELETE FROM ${DatabaseDetails.tempOrderProductTable} ''');
  }

  Future deleteDataByID(String id) async {
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(
        ''' DELETE FROM ${DatabaseDetails.tempOrderProductTable} WHERE ${DatabaseDetails.pCode} = "$id" ''');
  }

  Future dublicateExit(String productId) async {
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(
        ''' DELETE  FROM ${DatabaseDetails.tempOrderProductTable} WHERE Id = "$productId" ''');
  }

  Future<List<TempProductOrderModel>> editDataById(
      {required String productID,
        required String rate,
        required String quantity}) async {
    db = await DatabaseHelper.instance.database;
    String totalAmount =
    (double.parse(rate) * double.parse(quantity)).toStringAsFixed(2);
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(
        ''' UPDATE ${DatabaseDetails.tempOrderProductTable} SET ${DatabaseDetails.rate} = "$rate",
         ${DatabaseDetails.qty}  = "$quantity", ${DatabaseDetails.totalAmount} = "$totalAmount" 
          WHERE ${DatabaseDetails.pCode} = "$productID"  ''');

    CustomLog.successLog(value: "MapData => $mapData");

    return List.generate(mapData.length, (i) {
      return TempProductOrderModel.fromJson(mapData[i]);
    });
  }

  Future<List<TempProductOrderModel>> getAllProductList() async {
    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(
        ''' SELECT * FROM ${DatabaseDetails.tempOrderProductTable} ''');

    CustomLog.successLog(
      value:
      "QUERY =>  SELECT * FROM ${DatabaseDetails.tempOrderProductTable} ",
    );
    CustomLog.successLog(value: "MapData => $mapData");

    return List.generate(mapData.length, (i) {
      return TempProductOrderModel.fromJson(mapData[i]);
    });
  }

  Future<List<TempProductOrderModel>> getProductAlready(
      {required String pcode}) async {
    db = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> mapData = await db!.rawQuery('''SELECT * FROM ${DatabaseDetails.tempOrderProductTable} WHERE PShortName ='${pcode}' ''');

    CustomLog.successLog(value: "MapData => $mapData");

    return List.generate(mapData.length, (i) {
      return TempProductOrderModel.fromJson(mapData[i]);
    });
  }
}
