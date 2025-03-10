
import 'dart:convert';

import 'package:flutter/material.dart';

class BToBOrderModel {
  BToBOrderModel({
    required this.dbName,
    required this.userCode,
    required this.remarks,
    required this.glCode,
    required this.lat,
    required this.lng,
    required this.btoBorderDetails,
  });

  final String dbName;
  final String userCode;
  final String remarks;
  final String glCode;
  final String lat;
  final String lng;
  final List<BToBOrderDetail> btoBorderDetails;

  factory BToBOrderModel.fromJson({
    required Map<String, dynamic> json,
    required String lat,
    required String long,
  }) {
    List<dynamic> detailsList = [];
    if (json["BToBorderDetails"] is String) {
      try {
        detailsList = jsonDecode(json["BToBorderDetails"]);
      } catch (e) {
        debugPrint("Error parsing BToBorderDetails: $e");
        detailsList = [];
      }
    } else if (json["BToBorderDetails"] is List) {
      detailsList = json["BToBorderDetails"];
    }

    return BToBOrderModel(
      dbName: json["DbName"] ?? "",
      userCode: json["UserCode"] ?? "",
      remarks: json["Remarks"] ?? "",
      glCode: json["GLCode"]?.toString() ?? "",
      lat: lat,
      lng: long,
      btoBorderDetails: detailsList
          .map((x) => BToBOrderDetail.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "DbName": dbName,
    "UserCode": userCode,
    "Remarks": remarks,
    "GLCode": glCode,
    "Lat": lat,
    "Lng": lng,
    "BToBorderDetails": btoBorderDetails.map((x) => x.toJson()).toList(),
  };
}

class BToBOrderDetail {
  BToBOrderDetail({
    required this.pcode,
    required this.qty,
    required this.rate,
    required this.totalAmt,
  });

  final String pcode;
  final String qty;
  final String rate;
  final String totalAmt;

  factory BToBOrderDetail.fromJson(Map<String, dynamic> json) {
    return BToBOrderDetail(
      pcode: json["Pcode"] ?? "",
      qty: json["Qty"] ?? "",
      rate: json["Rate"] ?? "",
      totalAmt: json["TotalAmt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "Pcode": pcode,  // Changed keys to match incoming JSON
    "Qty": qty,
    "Rate": rate,
    "TotalAmt": totalAmt,
  };
}