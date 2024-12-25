import 'package:fluttertoast/fluttertoast.dart';
import 'package:retail_app/src/purchase_report/model/purchase_report_model.dart';
import 'package:retail_app/utils/custom_log.dart';
import 'package:sqflite/sqflite.dart';
import '../../../services/services.dart';

class PurchaseReportDbDatabase {
  Database? db;

  PurchaseReportDbDatabase._privateConstructor();

  static final PurchaseReportDbDatabase instance =
  PurchaseReportDbDatabase._privateConstructor();



  Future<int> insertData(PurchaseDataModel data) async {
    db = await DatabaseHelper.instance.database;
    return await db!.insert(
      DatabaseDetails.purchaseReportTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PurchaseDataModel>> getDateWiseList({
    required String fromDate,
    required String toDate,
  }) async {
    String myQuery="";

    if(fromDate != ""){
      myQuery =   '''SELECT * FROM ${DatabaseDetails.purchaseReportTable}
        where
          substr(${DatabaseDetails.vDate}, 7) || '-' ||
          substr(${DatabaseDetails.vDate}, 4, 2) || '-' ||
          substr(${DatabaseDetails.vDate}, 1, 2)  >= DATE("$fromDate")
        AND
          substr(${DatabaseDetails.vDate}, 7) || '-' ||
          substr(${DatabaseDetails.vDate}, 4, 2) || '-' ||
          substr(${DatabaseDetails.vDate}, 1, 2) <= DATE("$toDate")

       ORDER BY
           substr(${DatabaseDetails.vDate}, 7) || '-' ||
           substr(${DatabaseDetails.vDate}, 4, 2) || '-' ||
           substr(${DatabaseDetails.vDate}, 1, 2) ASC ''';
    }else{
      myQuery = ''' select * from PurchaseReportTable ''';
    }





    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);

    CustomLog.successLog(value: "MY Query Ledger => $myQuery");
    CustomLog.successLog(value: "MapData Ledger => $mapData");

    return List.generate(mapData.length, (i) {
      return PurchaseDataModel.fromJson(mapData[i]);
    });
  }


  Future deleteData() async {
    String myQuery = ''' DELETE FROM ${DatabaseDetails.purchaseReportTable} ''';
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(myQuery);
  }

  Future<double> totalPurchaseSum() async {
    String myQuery = '''SELECT SUM(NetAmt) AS NetAmt FROM ${DatabaseDetails.purchaseReportTable}''';
    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);

    CustomLog.successLog(value: "MapData => $mapData");

    if (mapData.isNotEmpty && mapData.first['NetAmt'] != null) {
      return mapData.first['NetAmt'] as double;
    } else {
      return 0.0;
    }
  }


}