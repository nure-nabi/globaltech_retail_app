import 'package:retail_app/src/login/model/login_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../../services/database/database.dart';
import '../../../utils/custom_log.dart';

class ClientListDBHelper {
  Database? db;

  ClientListDBHelper._privateConstructor();

  static final ClientListDBHelper instance =
      ClientListDBHelper._privateConstructor();

  Future<int> insertData(CompanyDetailsModel data) async {
    db = await DatabaseHelper.instance.database;

    CustomLog.actionLog(value: "Product Added => ${data.toJson()} ");
    return await db!.insert(
      DatabaseDetails.clientListTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<dynamic> deleteAllData() async {
    db = await DatabaseHelper.instance.database;
    return await db!.delete(DatabaseDetails.clientListTable);
  }

  Future<List<CompanyDetailsModel>> getDataList() async {
    db = await DatabaseHelper.instance.database;

    String myQuery = '''  SELECT * FROM ${DatabaseDetails.clientListTable} ''';
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);
    CustomLog.successLog(value: "MapData => $mapData");

    return List.generate(mapData.length, (i) {
      return CompanyDetailsModel.fromJson(mapData[i]);
    });
  }
}
// import 'package:oms_b2b/services/database/database.dart';
// import 'package:oms_b2b/utils/utils.dart';
// import 'package:sqflite/sqflite.dart';

// import '../model/company_model.dart';

// class ClientListDBHelper {
//   Database? db;

//   ClientListDBHelper._privateConstructor();

//   static final ClientListDBHelper instance =
//       ClientListDBHelper._privateConstructor();

//   Future<int> insertData(CompanyDetailsModel data) async {
//     db = await DatabaseHelper.instance.database;

//     CustomLog.actionLog(value: "Product Added => ${data.toJson()} ");
//     return await db!.insert(
//       DatabaseDetails.clientListTable,
//       data.toJson(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<dynamic> deleteAllData() async {
//     db = await DatabaseHelper.instance.database;
//     return await db!.delete(DatabaseDetails.clientListTable);
//   }

//   Future<List<CompanyDetailsModel>> getDataList() async {
//     db = await DatabaseHelper.instance.database;

//     String myQuery = '''  SELECT * FROM ${DatabaseDetails.clientListTable} ''';
//     final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);
//     CustomLog.successLog(value: "MapData => $mapData");

//     return List.generate(mapData.length, (i) {
//       return CompanyDetailsModel.fromJson(mapData[i]);
//     });
//   }
// }
