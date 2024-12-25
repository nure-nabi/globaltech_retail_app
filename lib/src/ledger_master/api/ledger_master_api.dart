// import 'package:http/http.dart' as http;
// import 'package:retail_app/src/ledger_master/model/ledger_master_model.dart';
// import 'dart:convert';
// import 'package:retail_app/utils/show_toast.dart';
//
// class LedgerMasterAPI {
//   static Future<void> saveMasterLedger({
//     required LedgerMasterModel ledgerMasterModel,
//   }) async {
//     const apiUrl =
//         "http://myomsapi.globaltechsolution.com.np:802/api/GeneralLedger/SaveOutlet";
//
//     try {
//       var response = await http.post(Uri.parse(apiUrl),
//           headers: {"Content-Type": "application/json; charset=UTF-8"},
//           body: jsonEncode({
//             "objLedgerDetails": [ledgerMasterModel.toJson()]
//           }));
//
//       if (response.statusCode == 200) {
//         return ShowToast.successToast(
//             msg:
//                 'Failed to create Ledger - Status Code: ${response.statusCode}');
//       } else {
//         throw Exception('Failed to create Ledger');
//       }
//     } catch (e) {
//       throw Exception('An error occurred: $e');
//     }
//   }
// }
//
//
// // class OrderProductAPI {
// //   static postOrder({required bodyData}) async {
// //     var body = jsonEncode(bodyData[0]);
// //
// //     var jsonData = await APIProvider.postAPI(
// //       endPoint: "Order/SaveSalesInvoice",
// //       body: body,
// //     );
// //     CustomLog.successLog(value: "RESPONSE Save Data => $jsonData");
// //     return BasicModel.fromJson(jsonData);
// //   }
// // }


import 'dart:convert';
import 'package:retail_app/services/api/api_provider.dart';
import 'package:retail_app/src/ledger_master/model/ledger_master_model.dart';
import 'package:retail_app/utils/custom_log.dart';

import '../../../model/basic_model.dart';

class LedgerMasterAPI {
  static  saveMasterLedger({
    required LedgerMasterModel ledgerMasterModel,
  }) async {
    var body = jsonEncode({
      "objLedgerDetails": [ledgerMasterModel.toJson()]
    });

    var jsonData = await APIProvider.postAPI(
      endPoint: "GeneralLedger/SaveOutlet",
      body: body,
    );

    CustomLog.successLog(value: "RESPONSE Save Ledger Customer => $jsonData");
    return BasicModel.fromJson(jsonData);
  }



}

