import 'package:retail_app/src/sales_bill_term/model/sales_bill_term_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';


class SalesTermDatabase {
  Database? db;

  SalesTermDatabase._privateConstructor();

  static final SalesTermDatabase instance =
  SalesTermDatabase._privateConstructor();

  Future<int> insertData(SalesBillTermDataModel data) async {
    db = await DatabaseHelper.instance.database;
    return await db!.insert(
      DatabaseDetails.salesBillTermTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future deleteData() async {
    String myQuery = ''' DELETE FROM ${DatabaseDetails.salesBillTermTable} ''';
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(myQuery);
  }

  Future<List<SalesBillTermDataModel>> getTermList(
      {required String termType}) async {
    db = await DatabaseHelper.instance.database;

    String myQuery =
    '''  SELECT * From  ${DatabaseDetails.salesBillTermTable} Where ${DatabaseDetails.type} = "$termType" ''';
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);

    CustomLog.successLog(value: "MY Term Query => $myQuery");
    CustomLog.successLog(value: "Term MapData => $mapData");

    return List.generate(mapData.length, (i) {
      return SalesBillTermDataModel.fromJson(mapData[i]);
    });
  }
}


