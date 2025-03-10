import 'package:retail_app/src/ledger_report_party/model/ledger_report_party_model.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

class CustomerApi {
  static Future apiCall({
    required String databaseName,
    required String category,
    required String unitcode,
  }) async {
    var jsonData = await APIProvider.getAPI(
      endPoint:
      //"MasterList/ListMobileRepLedgerSummary?DbName=$databaseName&Catagory=$category",
      "MasterList/ListMobileRepLedgerSummary?DbName=$databaseName&Catagory=$category&unitcode=$unitcode",
    );

    CustomLog.successLog(value: "RESPONSE => $jsonData");

    return CustomerModel.fromJson(jsonData, category);
  }
}