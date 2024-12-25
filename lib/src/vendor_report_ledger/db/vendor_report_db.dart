import 'package:retail_app/src/ledger_report_party/model/ledger_report_party_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../../services/database/database_const.dart';
import '../../../services/database/database_provider.dart';

class VendorDatabase {
  Database? db;

  VendorDatabase._privateConstructor();

  static final VendorDatabase instance =
  VendorDatabase._privateConstructor();

  Future<int> insertData(CustomerDataModel data) async {
    db = await DatabaseHelper.instance.database;
    return await db!.insert(
      DatabaseDetails.vendorListTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future deleteData() async {
    String myQuery = '''  DELETE FROM ${DatabaseDetails.vendorListTable} ''';
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(myQuery);
  }

  Future<List<CustomerDataModel>> getGlDescData() async {
    String myQuery =
    ''' SELECT  ${DatabaseDetails.glDesc},${DatabaseDetails.glCode},${DatabaseDetails.amount} from ${DatabaseDetails.vendorListTable} ;''';
    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);
    return List.generate(mapData.length, (i) {
      return CustomerDataModel.fromJson(mapData[i],DatabaseDetails.category);
    });
  }

}