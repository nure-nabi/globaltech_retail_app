import '../../../services/services.dart';
import '../../../utils/utils.dart';
import '../bill_by_vno.dart';

class BillByVNoAPI {
  static Future billPrint({
    required String databaseName,
    required String vNo,
    required String apiMethodName,
  }) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/$apiMethodName?DbName=$databaseName&Vno=$vNo",
    );

    CustomLog.successLog(value: "RESPONSE => $jsonData");

    return ListBillModel.fromJson(jsonData);
  }
}
