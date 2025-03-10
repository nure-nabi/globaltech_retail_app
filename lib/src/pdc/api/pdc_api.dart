import 'dart:convert';

import '../../../model/basic_model.dart';
import '../../../services/services.dart';
import '../model/bank_model.dart';
import '../model/pdc_model.dart';
import '../model/pdf_bounce_cheque_model.dart';
import '../model/pdf_print_model.dart';

class PDCReportAPI {
  static Future getBankList({required String databaseName}) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "MasterList/ListBank?DbName=$databaseName",
    );
    return BankModel.fromJson(jsonData);
  }

  static Future apiCall({
    required String databaseName,
    required String glCode,
    required String agentCode,
  }) async {
    var jsonData = await APIProvider.getAPI(
      endPoint:
      "MasterList/DuePdcList1?DbName=$databaseName&Glcode=$glCode&AgentCode=$agentCode",
    );

    return PDCReportModel.fromJson(jsonData);
  }
  static Future apiCallfromBounceList({
    required String databaseName,
    required String glCode,
    required String agentCode,
  }) async {
    var jsonData = await APIProvider.getAPI(
      endPoint:
      "MasterList/PdcBounce?DbName=$databaseName&Glcode=$glCode&AgentCode=$agentCode",
    );

    return PdcBounceModel.fromJson(jsonData);
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

  static Future pdcPostData({
    required String databaseName,
    required String branchCode,
    required String glCode,
    required String remarks,
    required String amount,
    required String chequeNo,
    required String bankName,
    required String image,
    required String timeStamp,
  }) async {
    var body = jsonEncode({
      "OutletStatusDModels": [
        {
          "DbName": databaseName,
          "BranchCode": branchCode,
          "Glcode": glCode,
          "Remarks": remarks,
          "Amount": amount,
          "ChequeNo": chequeNo,
          "BankName": bankName,
          "Timestamp": timeStamp,
          "OutletImage": image,
        }
      ]
    });

    //
    var jsonData = await APIProvider.postAPI(
      endPoint: "Order/SavePDC1",
      body: body,
    );
    return BasicModel.fromJson(jsonData);
  }
}
