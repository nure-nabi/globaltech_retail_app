import 'package:fluttertoast/fluttertoast.dart';

class LedgerPartyReportModel {
  LedgerPartyReportModel({
    required this.status_code,
    required this.status,
    required this.data,
  });

  final int status_code;
  final bool status;
  final List<LedgerPartyReportDataModel> data;

  factory LedgerPartyReportModel.fromJson(Map<String, dynamic> json) {
    return LedgerPartyReportModel(
      status_code: json["status_code"] ?? 0,
      status: json["status"] ?? false,
      data: json["data"] == null
          ? []
          : List<LedgerPartyReportDataModel>.from(
          json["data"].map((x) => LedgerPartyReportDataModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status_code": status_code,
    "status": status,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class LedgerPartyReportDataModel {
  LedgerPartyReportDataModel({
    required this.vno,
    required this.date,
    required this.miti,
    required this.source,
    required this.dr,
    required this.cr,
    required this.narration,
    required this.remarks,
  });

  final String vno;
  final String date;
  final String miti;
  final String source;
  final String dr;
  final String cr;
  final String narration;
  final String remarks;

  factory LedgerPartyReportDataModel.fromJson(Map<String, dynamic> json) {
    return LedgerPartyReportDataModel(
      vno: json["Vno"] ?? "",
      date: json["Date"] ?? "",
      miti: json["Miti"] ?? "",
      source: json["Source"] ?? "",
      // dr: json["Dr"] ??0,
      dr: json['Dr'] == null ? "0.00" : double.parse(json['Dr'].toString()).toStringAsFixed(2),
      cr: json['Cr'] == null ? "0.00" : double.parse(json['Cr'].toString()).toStringAsFixed(2),

     // totalAmount: json["totalAmount"] ?? 0,
      narration: json["Narration"] ?? "",
      remarks: json["Remarks"] ?? "",

    );
  }

  Map<String, dynamic> toJson() => {
    "Vno": vno,
    "Date": date,
    "Miti": miti,
    "Source": source,
    "Dr": dr,
    "Cr": cr,
    "Narration": narration,
    "Remarks": remarks,
  };

  //for pdf
  String getIndex(int index,List<LedgerPartyReportDataModel> salesLedgerReport) {

    switch (index) {
      case 0:
        return vno;
      case 1:
        return date;
      case 2:
        return miti;
      case 3:
        return dr;
      case 4:
        return cr;
      case 5:
        return dr;
    }
    return '';
  }
}

