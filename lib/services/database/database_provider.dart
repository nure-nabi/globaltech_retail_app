import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'create_table.dart';
import 'database_const.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initiateDatabase();
    return _database;
  }

  late String path;

  initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    path = join(directory.path, DatabaseDetails.databaseName);
    return openDatabase(
      path,
      version: DatabaseDetails.dbVersion,
      onCreate: onCreate,
    );
  }

  Future<void> onDropDatabase() async {
    Database? db = await instance.database;
    // await db!.delete(DatabaseDetails.clientListTable);


    await db!.delete(DatabaseDetails.tempOrderProductTable);
    await db.delete(DatabaseDetails.orderProductTable);
    await db.delete(DatabaseDetails.salesBillTermTable);
    await db.delete(DatabaseDetails.purchaseBillTermTable);
    await db.delete(DatabaseDetails.purchaseOrderProductTable);
    await db.delete(DatabaseDetails.tempPurchaseOrderProductTable);
    await db.delete(DatabaseDetails.accountGroupListTable);

  }

  Future<void> onCreate(Database db, int version) async {
    await CreateTable(db).companyListTable();
    await CreateTable(db).ledgerCreateTable();
    await CreateTable(db).productCreateTable();
    await CreateTable(db).ledgerReportTable();
    await CreateTable(db).tempOrderProductTable();
    await CreateTable(db).orderProductTable();
    await CreateTable(db).purchaseReportTable();
    await CreateTable(db).salesTermTable();
    await CreateTable(db).purchaseTermTable();
    await CreateTable(db).purchaseReportTable();
    await CreateTable(db).salesReportTable();
    await CreateTable(db).ledgerTable();
    await CreateTable(db).customerListTable();
    await CreateTable(db).vendorListTable();
    await CreateTable(db).purchaseOrderProductTable();
    await CreateTable(db).temppurchaseOrderProductTable();
    await CreateTable(db).salesBillReportListTable();
    await CreateTable(db).accountGroupListTable();
    await CreateTable(db).vendorBillReportTable();
    await CreateTable(db).orderListTable();
  }
}