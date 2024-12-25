import 'dart:convert';
import 'package:retail_app/src/sales/model/post_sales_model.dart';
import 'package:retail_app/src/sales/model/product_sales_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../services/services.dart';
import '../../../utils/utils.dart';
import '../../sales/model/outlet_model.dart';
import '../model/account_group_model.dart';

class AccountGroupListDatabase {
  Database? db;

  AccountGroupListDatabase._privateConstructor();

  static final AccountGroupListDatabase instance =
  AccountGroupListDatabase._privateConstructor();

  Future<int> insertData(AccountGroupListDataModel data) async {
    db = await DatabaseHelper.instance.database;

    CustomLog.actionLog(value: "Account Group List Added => ${data.toJson()} ");
    return await db!.insert(
      DatabaseDetails.accountGroupListTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  Future deleteData() async {
    db = await DatabaseHelper.instance.database;
    return await db!
        .rawQuery(''' DELETE FROM ${DatabaseDetails.accountGroupListTable} ''');
  }

  Future<List<AccountGroupListDataModel>> getAccountGroupList() async {
    db = await DatabaseHelper.instance.database;

    String myQuery = '''  SELECT * From  ${DatabaseDetails.accountGroupListTable}''';
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);

    CustomLog.successLog(
      value:
      "QUERY =>  SELECT * FROM ${DatabaseDetails.ledgerTable} ",
    );
    CustomLog.successLog(value: "MapData => $mapData");

    return List.generate(mapData.length, (i) {
      return AccountGroupListDataModel.fromJson(mapData[i]);
    });
  }


}
