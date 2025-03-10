import 'package:fluttertoast/fluttertoast.dart';
import 'package:retail_app/src/salesreport/model/sales_report_model.dart';
import 'package:retail_app/utils/custom_log.dart';
import 'package:sqflite/sqflite.dart';
import '../../../services/services.dart';

class SalesReportDbDatabase {
  Database? db;

  SalesReportDbDatabase._privateConstructor();

  static final SalesReportDbDatabase instance =
  SalesReportDbDatabase._privateConstructor();



  Future<int> insertData(SalesDataModel data) async {
    db = await DatabaseHelper.instance.database;
    return await db!.insert(
      DatabaseDetails.salesReportTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SalesDataModel>> getAllSalesReportData() async {
    String myQuery =
    ''' SELECT  * from ${DatabaseDetails.salesReportTable} ;''';
    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);
    return List.generate(mapData.length, (i) {
      return SalesDataModel.fromJson(mapData[i]);
    });
  }

  Future<List<SalesDataModel>> getDateWiseList({
    required String fromDate,
    required String toDate,
  }) async {
    String myQuery="";
    if(fromDate != ""){
      myQuery =   '''SELECT * FROM ${DatabaseDetails.salesReportTable}
        where
          substr(${DatabaseDetails.billDate}, 7) || '-' ||
          substr(${DatabaseDetails.billDate}, 4, 2) || '-' ||
          substr(${DatabaseDetails.billDate}, 1, 2)  >= DATE("$fromDate")
        AND
          substr(${DatabaseDetails.billDate}, 7) || '-' ||
          substr(${DatabaseDetails.billDate}, 4, 2) || '-' ||
          substr(${DatabaseDetails.billDate}, 1, 2) <= DATE("$toDate")

       ORDER BY
           substr(${DatabaseDetails.billDate}, 7) || '-' ||
           substr(${DatabaseDetails.billDate}, 4, 2) || '-' ||
           substr(${DatabaseDetails.billDate}, 1, 2) DESC ''';
    }else{
      myQuery = ''' SELECT * FROM ${DatabaseDetails.salesReportTable}
      ORDER BY
           substr(${DatabaseDetails.billDate}, 7) || '-' ||
           substr(${DatabaseDetails.billDate}, 4, 2) || '-' ||
           substr(${DatabaseDetails.billDate}, 1, 2) DESC 
      ''';
    }

    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);

    CustomLog.successLog(value: "MY Query Ledger => $myQuery");
    CustomLog.successLog(value: "MapData Ledger => $mapData");

    return List.generate(mapData.length, (i) {
      return SalesDataModel.fromJson(mapData[i]);
    });
  }


  Future deleteData() async {
    String myQuery = ''' DELETE FROM ${DatabaseDetails.salesReportTable} ''';
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(myQuery);
  }



  Future<double> totalSalesSum() async {
    String myQuery = '''  SELECT SUM(NetAmount) AS NetAmount FROM ${DatabaseDetails.salesReportTable}     ''';
    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);

    CustomLog.successLog(value: "MapData => $mapData");

    if (mapData.isNotEmpty && mapData.first['NetAmount'] != null) {
      return mapData.first['NetAmount'] as double;
    } else {
      return 0.0;
    }
  }
}
