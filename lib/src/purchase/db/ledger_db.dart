import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../../../services/services.dart';
import '../../sales/model/outlet_model.dart';

class LedgerDatabase {
  Database? db;

  LedgerDatabase._privateConstructor();

  static final LedgerDatabase instance =
  LedgerDatabase._privateConstructor();

  Future<int> insertData(OutletDataModel data) async {
    db = await DatabaseHelper.instance.database;
    return await db!.insert(
      DatabaseDetails.ledgerTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  //9849366124
  Future deleteData() async {
    db = await DatabaseHelper.instance.database;
    return await db!.rawQuery(''' DELETE FROM ${DatabaseDetails.ledgerTable} ''');
  }

  Future<List<OutletDataModel>> getLedgerCatagoryList(String ledgerName) async {
    db = await DatabaseHelper.instance.database;
    String myQuery = '''  SELECT * From  ${DatabaseDetails.ledgerTable} Where LOWER(${DatabaseDetails.glCatagory}) = "$ledgerName" or LOWER(${DatabaseDetails.glCatagory}) ="customer/vendor"''';
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);
    return List.generate(mapData.length, (i) {
      return OutletDataModel.fromJson(mapData[i]);
    });
  }

  Future<List<OutletDataModel>> getLedgerCashBookList(String ledgerName) async {
    db = await DatabaseHelper.instance.database;
    String myQuery = '''  SELECT * From  ${DatabaseDetails.ledgerTable} Where LOWER(${DatabaseDetails.glCatagory}) = "$ledgerName"''';
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);
    debugPrint('Cash Book =>   ${myQuery}');
    return List.generate(mapData.length, (i) {
      return OutletDataModel.fromJson(mapData[i]);
    });
  }

}
