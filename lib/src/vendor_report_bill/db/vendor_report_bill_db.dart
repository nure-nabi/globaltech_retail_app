import 'package:flutter/material.dart';
import 'package:retail_app/src/ledger_report_party_bill/model/ledger_report_model.dart';
import 'package:retail_app/src/ledger_report_party_bill/model/ledger_report_party_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../services/services.dart';
import '../../../utils/custom_log.dart';


class VendorBillReportDatabase {
  Database? db;

  VendorBillReportDatabase._privateConstructor();

  static final VendorBillReportDatabase instance =
  VendorBillReportDatabase._privateConstructor();

  Future<int> insertData(LedgerReportModel data) async {
    db = await DatabaseHelper.instance.database;
    return await db!.insert(
      DatabaseDetails.vendorBillReportTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future deleteData() async {
    String myQuery = '''  DELETE FROM ${DatabaseDetails.vendorBillReportTable} ''';
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(myQuery);
  }

  Future<List<LedgerPartyReportDataModel>> getLedgerWiseReport() async {
    db = await DatabaseHelper.instance.database;
    String myQuery = ''' SELECT * FROM ${DatabaseDetails.vendorBillReportTable} ''';

    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);

    return List.generate(mapData.length, (i) {
      return LedgerPartyReportDataModel.fromJson(mapData[i]);
    });
  }

  Future<List<LedgerReportModel>> getDateWiseList({
    required String fromDate,
    required String toDate,
  }) async {
    String myQuery="";

    if(fromDate.isNotEmpty) {
      myQuery = '''SELECT * FROM ${DatabaseDetails.vendorBillReportTable}
        where
          substr(${DatabaseDetails.date}, 7) || '-' ||
          substr(${DatabaseDetails.date}, 4, 2) || '-' ||
          substr(${DatabaseDetails.date}, 1, 2)  >= DATE("$fromDate")
        AND
          substr(${DatabaseDetails.date}, 7) || '-' ||
          substr(${DatabaseDetails.date}, 4, 2) || '-' ||
          substr(${DatabaseDetails.date}, 1, 2) <= DATE("$toDate")

       ORDER BY
           substr(${DatabaseDetails.date}, 7) || '-' ||
           substr(${DatabaseDetails.date}, 4, 2) || '-' ||
           substr(${DatabaseDetails.date}, 1, 2) ASC ''';
    }else{
      myQuery = ''' SELECT * FROM ${DatabaseDetails.vendorBillReportTable} ''';
    }
    String s =
    ''' SELECT * FROM ${DatabaseDetails.vendorBillReportTable}  WHERE ${DatabaseDetails.date} BETWEEN "$fromDate" AND "$toDate" ''';

    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);

    CustomLog.successLog(value: "MY Query Ledger => $myQuery");
    CustomLog.successLog(value: "MapData Ledger => $mapData");

    return List.generate(mapData.length, (i) {
      return LedgerReportModel.fromJson(mapData[i]);
    });
  }

  Future<List<LedgerReportModel>> getDateWisePdfList({
    required String fromDate,
    required String toDate,
  }) async {
    String myQuery = '''SELECT * FROM ${DatabaseDetails.vendorBillReportTable}
        where
          substr(${DatabaseDetails.date}, 7) || '-' ||
          substr(${DatabaseDetails.date}, 4, 2) || '-' ||
          substr(${DatabaseDetails.date}, 1, 2)  >= DATE("$fromDate")
        AND
          substr(${DatabaseDetails.date}, 7) || '-' ||
          substr(${DatabaseDetails.date}, 4, 2) || '-' ||
          substr(${DatabaseDetails.date}, 1, 2) <= DATE("$toDate")

       ORDER BY
           substr(${DatabaseDetails.date}, 7) || '-' ||
           substr(${DatabaseDetails.date}, 4, 2) || '-' ||
           substr(${DatabaseDetails.date}, 1, 2) ASC ''';

    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);

    CustomLog.successLog(value: "MY Query Ledger => $myQuery");
    CustomLog.successLog(value: "MapData Ledger => $mapData");

    return List.generate(mapData.length, (i) {
      return LedgerReportModel.fromJson(mapData[i]);
    });
  }

  Future<dynamic> getOpeningBalance({
    required String glCode,
    required String fromDate,
  }) async {
    db = await DatabaseHelper.instance.database;

    String myQuery =
    '''   Select Sum (Dr-Cr) as Balance From ${DatabaseDetails.vendorBillReportTable}  Where
          substr(${DatabaseDetails.miti}, 7) || '-' ||
          substr(${DatabaseDetails.miti}, 4, 2) || '-' ||
          substr(${DatabaseDetails.miti}, 1, 2) < DATE("$fromDate")  ''';

    var result = await db!.rawQuery(myQuery);
    debugPrint("result => $result");

    String value = (result[0]["Balance"] == null)
        ? "0.00"
        : result[0]["Balance"].toString();

    return double.parse(value).toStringAsFixed(2);
  }

  Future<String> getTotalDebitAmount({required String glCode}) async {
    db = await DatabaseHelper.instance.database;
    var result = await db!.rawQuery(
        ''' SELECT SUM (Dr) FROM  ${DatabaseDetails.vendorBillReportTable} ''');
    debugPrint("result => $result");
    String value = (result[0]["SUM (Dr)"] == null)
        ? "0.00"
        : result[0]["SUM (Dr)"].toString();
    return double.parse(value).toStringAsFixed(2);
  }

  Future<String> getTotalCreditAmount({required String glCode}) async {
    db = await DatabaseHelper.instance.database;
    var result = await db!.rawQuery(
        ''' SELECT SUM (Cr) FROM  ${DatabaseDetails.vendorBillReportTable} ''');
    debugPrint("result => $result");
    String value = (result[0]["SUM (Cr)"] == null)
        ? "0.00"
        : result[0]["SUM (Cr)"].toString();
    return double.parse(value).toStringAsFixed(2);
  }
}