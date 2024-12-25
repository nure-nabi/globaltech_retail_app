import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:retail_app/services/api/api_provider.dart';

import 'dart:convert';

import 'package:retail_app/utils/custom_log.dart';

import '../master.dart';

class LedgerAPI {
  static Future<void> saveLedger({
    required LedgerDetails ledgerDetails,
  }) async {
    const apiUrl =
        "http://api.globaltech.com.np:802/api/GeneralLedger/SaveLedgerRelated";

    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json; charset=UTF-8"},
          body: jsonEncode({
            "objLedgerDetails": [ledgerDetails.toJson()]
          }));

      if (response.statusCode == 200) {
        return;
      } else {
        debugPrint(
            'Failed to create Ledger - Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
        throw Exception('Failed to create Ledger');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}

class LedgerList {
  static getLedgerList({required String dbName,required String unitCode}) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "masterlist/ListAccountGroup?dbname=$dbName&BrCode=$unitCode",
    );
    CustomLog.successLog(value: "RESPONSE => $jsonData");
    return GroupModel.fromJson(jsonData);
  }
}
