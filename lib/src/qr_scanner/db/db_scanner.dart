import 'package:sqflite/sqflite.dart';
import '../../../services/database/database_const.dart';
import '../../../services/database/database_provider.dart';
import '../model/qr_scanner_model.dart';

class QRScanDatabase {
  Database? db;

  QRScanDatabase._privateConstructor();

  static final QRScanDatabase instance = QRScanDatabase._privateConstructor();

  Future<int> insertData(QRDataModel data) async {
    db = await DatabaseHelper.instance.database;
    return await db!.insert(
      DatabaseDetails.qRDatabaseTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future deleteData() async {
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(''' DELETE FROM ${DatabaseDetails.qRDatabaseTable} ''');
  }

  Future<List<QRDataModel>> getAllData() async {
    db = await DatabaseHelper.instance.database;
    final data = await db!.rawQuery('SELECT * FROM ${DatabaseDetails.qRDatabaseTable}');
    return data.map((json) => QRDataModel.fromJson(json)).toList();
  }
}
