import 'package:flutter/cupertino.dart';

class PurchaseModel {
  PurchaseModel({
    required this.statusCode,
    required this.status,
    required this.data,
  });

  final int statusCode;
  final bool status;
  final List<PurchaseDataModel> data;

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      statusCode: json["status_code"] ?? 0,
      status: json["status"] ?? false,
      data: json["data"] == null
          ? []
          : List<PurchaseDataModel>.from(json["data"].map(
            (x) => PurchaseDataModel.fromJson(x),
      )),
    );
  }

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status": status,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class PurchaseDataModel {
  PurchaseDataModel({
    required this.vNo,
    required this.vDate,
    required this.vMiti,
    required this.glDesc,
    required this.netAmt,
  });

  final String vNo;
  final String vDate;
  final String vMiti;
  final String glDesc;
  final double netAmt;

  factory PurchaseDataModel.fromJson(Map<String, dynamic> json) {
    double parsedNetAmt;
    try {
      parsedNetAmt = double.parse(json["NetAmt"] ?? "0.0");
    } catch (e) {
      parsedNetAmt = 0.0;
      debugPrint("Error parsing net amount: $e");
    }
    return PurchaseDataModel(
      vNo: json["VNo"] ?? "",
      vDate: json["VDate"] ?? "",
      vMiti: json["VMiti"] ?? "",
      glDesc: json["GlDesc"] ?? "",
      netAmt: parsedNetAmt,
    );
  }

  Map<String, dynamic> toJson() => {
    "VNo": vNo,
    "VDate": vDate,
    "VMiti": vMiti,
    "GlDesc": glDesc,
    "NetAmt": netAmt,
  };
  String getIndex(int index, bool showEnglishDate) {
    switch (index) {
      case 0:
        return vNo;
      case 1:
        return vDate;
      case 2:
        return vMiti;
      case 3:
        return glDesc;
      case 4:
        return netAmt.toString();
    }
    return '';
  }
}
