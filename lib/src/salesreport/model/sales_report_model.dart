import 'package:flutter/cupertino.dart';

class SalesModel {
  SalesModel({
    required this.statusCode,
    required this.status,
    required this.data,
  });

  final int statusCode;
  final bool status;
  final List<SalesDataModel> data;

  factory SalesModel.fromJson(Map<String, dynamic> json) {
    return SalesModel(
      statusCode: json["status_code"] ?? 0,
      status: json["status"] ?? false,
      data: json["data"] == null
          ? []
          : List<SalesDataModel>.from(json["data"].map(
            (x) => SalesDataModel.fromJson(x),
      )),
    );
  }

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status": status,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class SalesDataModel {
  SalesDataModel({
    required this.billDate,
    required this.billNo,
    required this.glDesc,
    required this.salesType,
    required this.netAmount,
  });

  final String billDate;
  final String billNo;
  final String glDesc;
  final String salesType;
  final double netAmount;

  factory SalesDataModel.fromJson(Map<String, dynamic> json) {
    double parsedNetAmt;
    try {
      parsedNetAmt = double.parse(json["NetAmount"] ?? "0.0");
    } catch (e) {
      parsedNetAmt = 0.0;
      debugPrint("Error parsing net amount: $e");
    }
    return SalesDataModel(
      billDate: json["BillDate"] ?? "",
      billNo: json["BillNo"] ?? "",
      glDesc: json["GlDesc"] ?? "",
      salesType: json["SalesType"] ?? "",
      netAmount: parsedNetAmt,
    );
  }

  Map<String, dynamic> toJson() => {
    "BillDate": billDate,
    "BillNo": billNo,
    "GlDesc": glDesc,
    "SalesType": salesType,
    "NetAmount": netAmount,
  };
  String getIndex(int index, bool showEnglishDate) {
    switch (index) {
      case 0:
        return billDate;
      case 1:
        return billNo;
      case 2:
        return glDesc;
      case 3:
        return salesType;
      case 4:
        return netAmount.toString();
    }
    return '';
  }
}