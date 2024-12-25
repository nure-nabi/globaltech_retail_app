import 'package:retail_app/src/salesreport/model/sales_report_model.dart';
import 'package:retail_app/utils/custom_log.dart';
import 'package:sqflite/sqflite.dart';
import '../../../services/services.dart';
import '../model/sales_bill_report_model.dart';

class SalesBillReportDbDatabase {
  Database? db;

  SalesBillReportDbDatabase._privateConstructor();

  static final SalesBillReportDbDatabase instance =
  SalesBillReportDbDatabase._privateConstructor();



  Future<int> insertData(SalesBillReportDataModel data) async {
    db = await DatabaseHelper.instance.database;
    return await db!.insert(
      DatabaseDetails.salesBillReportListTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SalesBillReportDataModel>> getAllSalesReportData() async {



     String myQuery =
     ''' SELECT* from SalesBillReportListTable ''';
    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);
    CustomLog.successLog(value: "MapData bill report=> $mapData");
    return List.generate(mapData.length, (i) {
      return SalesBillReportDataModel.fromJson(mapData[i]);
    });
  }


  Future deleteData() async {
    String myQuery = ''' DELETE FROM ${DatabaseDetails.salesBillReportListTable} ''';
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(myQuery);
  }



}
