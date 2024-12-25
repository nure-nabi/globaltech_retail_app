import '../../../services/services.dart';
import '../model/bank_model.dart';
import '../model/pdc_model.dart';
import '../model/pdf_print_model.dart';

class PDCReportAPI {
  static Future getBankList({required String databaseName}) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/ListBank?DbName=$databaseName",
    );
    return BankModel.fromJson(jsonData);
  }

  static Future apiCall(
      {required String databaseName, required String glCode}) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/DuePdcList1?DbName=$databaseName&Glcode=$glCode",
    );

    return PDCReportModel.fromJson(jsonData);
  }

  static Future pdcPrint({
    required String databaseName,
    required String vNo,
  }) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/ListPDCPrint?DbName=$databaseName&Vno=$vNo",
    );

    return PdcPrintModel.fromJson(jsonData);
  }
}
