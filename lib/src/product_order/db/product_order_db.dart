
import 'package:sqflite/sqlite_api.dart';

import '../../../services/database/database_const.dart';
import '../../../services/database/database_provider.dart';
import '../../../utils/custom_log.dart';
import '../model/product_order_model.dart';

class OrderProductDatabase {
  Database? db;

  OrderProductDatabase._privateConstructor();

  static final OrderProductDatabase instance =
  OrderProductDatabase._privateConstructor();

  Future<int> insertData(ProductOrderModel data) async {
    db = await DatabaseHelper.instance.database;

    CustomLog.actionLog(value: "Product Added => ${data.toJson()} ");
    return await db!.insert(
      DatabaseDetails.orderListTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future deleteData() async {
    db = await DatabaseHelper.instance.database;
    return await db!
        .rawQuery(''' DELETE FROM ${DatabaseDetails.orderListTable} ''');
  }

  Future deleteDataByID({required String productID,orderId}) async {
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(
        ''' DELETE FROM ${DatabaseDetails.orderListTable} WHERE ${DatabaseDetails.id} = "$productID" AND  ${DatabaseDetails.orderId} = "$orderId" ''');
  }

  Future increaseQuantityByID({required String productID,orderId}) async {
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(
        ''' UPDATE ${DatabaseDetails.orderListTable} SET ${DatabaseDetails.quantity} = ${DatabaseDetails.quantity} + 1  WHERE id = "$productID" AND  ${DatabaseDetails.orderId} = "$orderId" ''');
  }

  Future decreaseQuantityByID({required String productID,orderId}) async {
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(
        ''' UPDATE ${DatabaseDetails.orderListTable} SET ${DatabaseDetails.quantity} = ${DatabaseDetails.quantity} - 1  WHERE id = "$productID" AND  ${DatabaseDetails.orderId} = "$orderId" ''');
  }


  Future<List<ProductOrderModel>> getProductAlready(
      {required String pcode}) async {
    db = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> mapData = await db!.rawQuery('''SELECT * FROM ${DatabaseDetails.orderListTable} WHERE id =${pcode} ''');

    CustomLog.successLog(value: "MapData => $mapData");

    return List.generate(mapData.length, (i) {
      return ProductOrderModel.fromJson(mapData[i]);
    });
  }




  Future<List<ProductOrderModel>> editDataById(
      {required String productCode,
        required String rate,
        required String quantity,
        required String orderId}) async {
    db = await DatabaseHelper.instance.database;
    String totalAmount = (double.parse(rate) * double.parse(quantity)).toStringAsFixed(2);
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(
        ''' UPDATE ${DatabaseDetails.orderListTable} SET ${DatabaseDetails.rate} = "$rate", ${DatabaseDetails.quantity}  = "$quantity", ${DatabaseDetails.total} = "$totalAmount"  WHERE ${DatabaseDetails.productCode} = "$productCode"  AND  ${DatabaseDetails.orderId} = "$orderId" ''');

    CustomLog.successLog(value: "MapData => $mapData");

    return List.generate(mapData.length, (i) {
      return ProductOrderModel.fromJson(mapData[i]);
    });
  }

  Future<List<ProductOrderModel>> getAllProductList() async {
    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(
        ''' SELECT * FROM ${DatabaseDetails.orderListTable} ''');

    CustomLog.successLog(
      value: "QUERY =>  SELECT * FROM ${DatabaseDetails.orderListTable} ",
    );
    CustomLog.successLog(value: "MapData => $mapData");

    return List.generate(mapData.length, (i) {
      return ProductOrderModel.fromJson(mapData[i]);
    });
  }


}
