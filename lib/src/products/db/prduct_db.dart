import 'package:sqflite/sqflite.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';
import '../model/product_model.dart';

class ProductDatabase {
  Database? db;

  ProductDatabase._privateConstructor();

  static final ProductDatabase instance =
  ProductDatabase._privateConstructor();

  Future<int> insertData(ProductDataModel data) async {
    db = await DatabaseHelper.instance.database;
    return await db!.insert(
      DatabaseDetails.productCreateTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future deleteData() async {
    String myQuery = ''' DELETE FROM ${DatabaseDetails.productCreateTable} ''';
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(myQuery);
  }

  Future<List<ProductDataModel>> getProductGroupData() async {
    String myQuery =
    ''' SELECT DISTINCT ${DatabaseDetails.grpName} FROM ${DatabaseDetails.productCreateTable} ''';
    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);
    return List.generate(mapData.length, (i) {
      return ProductDataModel.fromJson(mapData[i]);
    });
  }

  Future<List<ProductDataModel>> getProductList(
      {required String groupName}) async {
    db = await DatabaseHelper.instance.database;

    String myQuery = '''  SELECT * From  ${DatabaseDetails.productCreateTable} Where ${DatabaseDetails.grpName} = "$groupName" ''';
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);

    CustomLog.successLog(value: "MY Query => $myQuery");
    CustomLog.successLog(value: "MapData => $mapData");

    return List.generate(mapData.length, (i) {
      return ProductDataModel.fromJson(mapData[i]);
    });
  }
}


