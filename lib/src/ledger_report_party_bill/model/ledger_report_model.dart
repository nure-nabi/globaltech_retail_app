import 'package:fluttertoast/fluttertoast.dart';

import '../ledger_report_party_bill.dart';

class LedgerReportModel {
  LedgerReportModel({
    required this.vno,
    required this.date,
    required this.miti,
    required this.source,
    required this.dr,
    required this.cr,
    required this.totalAmount,
    required this.narration,
    required this.remarks,

  });

  final String vno;
  final String date;
  final String miti;
  final String source;
  final String dr;
  final String cr;
  final String totalAmount;
  final String narration;
  final String remarks;



  factory LedgerReportModel.fromJson(Map<String, dynamic> json) {
    return LedgerReportModel(
      vno: json["Vno"] ?? "",
      date: json["Date"] ?? "",
      miti: json["Miti"] ?? "",
      source: json["Source"] ?? "",
      // dr: json["Dr"] ??0,
      dr: json['Dr'] == null ? "0.00" : double.parse(json['Dr'].toString()).toStringAsFixed(2),
      cr: json['Cr'] == null ? "0.00" : double.parse(json['Cr'].toString()).toStringAsFixed(2),
      totalAmount: json["netTotalAmount"] ?? "",
      //totalAmount: json["totalAmount"] ?? 0,
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
    "netTotalAmount": totalAmount,
    "Narration": narration,
    "Remarks": remarks,
  };

  /// For PDF
  //for pdf
  String getIndex(int index,List<LedgerReportModel> salesLedgerReport) {

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
        return totalAmount;
    }
    return '';
  }
}
