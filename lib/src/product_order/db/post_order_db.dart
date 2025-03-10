import 'package:sqflite/sqflite.dart';
import '../../../services/database/database_const.dart';
import '../../../services/database/database_provider.dart';
import '../../../utils/custom_log.dart';
import '../model/all_order_details.dart';
import '../model/order_post_model.dart';

class OrderPostDatabase {
  Database? db;

  OrderPostDatabase._privateConstructor();

  static final OrderPostDatabase instance =
      OrderPostDatabase._privateConstructor();

  //Inserting the remote data to the local storage sql lite
  Future<int> insertData(AllOrderDetailsModel data) async {
    db = await DatabaseHelper.instance.database;
    CustomLog.actionLog(value: "Product Added => ${data.toJson()} ");
    return await db!.insert(
      DatabaseDetails.orderPostTable,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



  Future deleteData() async {
    db = await DatabaseHelper.instance.database;
    return await db!
        .rawQuery(''' DELETE FROM ${DatabaseDetails.orderPostTable} ''');
  }

  // Get formatted POST data AS API for the post order
  Future<List<BToBOrderModel>> getFormatPOSTDATA() async {
    String myQuery = ''' SELECT 
                    ${DatabaseDetails.dbName} AS DbName,
                    ${DatabaseDetails.userCode} AS UserCode,
                    ${DatabaseDetails.comment} AS Remarks,
                    ${DatabaseDetails.glCode} AS GLCode,
                    '[' || GROUP_CONCAT('{
                      "TotalAmt":"'|| TotalAmt ||'",
                      "Qty":"' || Qty || '",
                      "Rate":"' || Rate || '",
                      "Pcode":"' || Pcode || '"
                    }') || ']' AS BToBorderDetails
                FROM ${DatabaseDetails.orderPostTable}
    ''';

    db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> mapData = await db!.rawQuery(myQuery);


    CustomLog.actionLog(value: "QUERY => $myQuery");
    CustomLog.successLog(value: "MapData => $mapData");
    return List.generate(mapData.length, (i) {
      return BToBOrderModel.fromJson(
        json: mapData[i],
        long: "0",
        lat: "0",
      );
    });


  }
}
