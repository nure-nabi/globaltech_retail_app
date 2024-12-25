class PurchaseReportModel {
  PurchaseReportModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  final String message;
  final int statusCode;
  final List<PurchaseReportDataModel> data;

  factory PurchaseReportModel.fromJson(Map<String, dynamic> json) {
    return PurchaseReportModel(
      message: json["MESSAGE"] ?? "",
      statusCode: json["STATUS_CODE"] ?? 0,
      data: json["data"] == null
          ? []
          : List<PurchaseReportDataModel>.from(
          json["data"].map((x) => PurchaseReportDataModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "MESSAGE": message,
    "STATUS_CODE": statusCode,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class PurchaseReportDataModel {
  PurchaseReportDataModel({
    required this.hvno,
    required this.hDate,
    required this.hMiti,
    required this.hGlDesc,
    required this.hGlCode,
    required this.hPanNo,
    required this.hMobileNo,
    required this.hAgent,
    required this.dsno,
    required this.dpDesc,
    required this.dQty,
    required this.dAltQty,
    required this.unitCode,
    required this.altUnitCode,
    required this.address,
    required this.dLocalRate,
    required this.dBasicAmt,
    required this.dTermAMt,
    required this.dNetAmt,
    required this.hTermAMt,
    required this.hBasicAMt,
    required this.hNetAmt,
    required this.voucherNumber,
    required this.vat,
    required this.importDuty,
    required this.importVat,
    required this.transport,
    required this.otherExpenses,
    required this.balanceAmt,
  });

  final String hvno;
  final String hDate;
  final String hMiti;
  final String hGlDesc;
  final String hGlCode;
  final String hPanNo;
  final String hMobileNo;
  final String hAgent;
  final String dsno;
  final String dpDesc;
  final String dQty;
  final String dAltQty;
  final String unitCode;
  final String altUnitCode;
  final String address;
  final String dLocalRate;
  final String dBasicAmt;
  final String dTermAMt;
  final String dNetAmt;
  final String hTermAMt;
  final String hBasicAMt;
  final String hNetAmt;
  final String voucherNumber;
  final String vat;
  final String importDuty;
  final String importVat;
  final String transport;
  final String otherExpenses;
  final String balanceAmt;

  factory PurchaseReportDataModel.fromJson(Map<String, dynamic> json) {
    return PurchaseReportDataModel(
      hvno: json["HVno"] ?? "",
      hDate: json["HDate"] ?? "",
      hMiti: json["HMiti"] ?? "",
      hGlDesc: json["HGlDesc"] ?? "",
      hGlCode: json["HGlCode"] ?? "",
      hPanNo: json["HPanNo"] ?? "",
      hMobileNo: json["HMobileNo"] ?? "",
      hAgent: json["HAgent"] ?? "",
      dsno: json['DSno'] == null
          ? "0"
          : int.parse(json['DSno'].toString()).toString(),
      dpDesc: json["DPDesc"] ?? "",
      dQty:  json['DQty'] == null
          ? "0.00"
          : double.parse(json['DQty'].toString()).toStringAsFixed(2),
      //dAltQty: json["DAltQty"] ?? "0.00",
      dAltQty: json["DAltQty"] == null
          ? "0.00"
          : double.parse(json['DAltQty'].toString()).toStringAsFixed(2),
      unitCode: json["UnitCode"] ?? "",
      altUnitCode: json["AltUnitCode"] ?? "",
      address: json["Address"] ?? "",
      dLocalRate: json['DLocalRate'] == null
          ? "0.00"
          : double.parse(json['DLocalRate'].toString()).toStringAsFixed(2),
      dBasicAmt:json['DBasicAmt'] == null
          ? "0.00"
          : double.parse(json['DBasicAmt'].toString()).toStringAsFixed(2),
      dTermAMt:  json['DTermAMt'] == null
          ? "0.00"
          : double.parse(json['DTermAMt'].toString()).toStringAsFixed(2),
      dNetAmt:  json['DNetAmt'] == null
          ? "0.00"
          : double.parse(json['DNetAmt'].toString()).toStringAsFixed(2),
      hTermAMt: json['HTermAMt'] == null ? "0.00" : double.parse(json['HTermAMt'].toString()).toStringAsFixed(2),
      hBasicAMt: json['HBasicAMt'] == null ? "0.00" : double.parse(json['HBasicAMt'].toString()).toStringAsFixed(2),
      hNetAmt: json['HNetAmt'] == null
          ? "0.00"
          : double.parse(json['HNetAmt'].toString()).toStringAsFixed(2),
      voucherNumber: json["Voucher Number"] ?? "",
      vat: json["VAT"]==null ? "0.00"
          : double.parse(json['VAT'].toString()).toStringAsFixed(2),
      importDuty: json["IMPORT DUTY"] ?? "",
      importVat: json["IMPORT VAT"] ?? "",
      transport: json["TRANSPORT"] ?? "",
      otherExpenses: json["OTHER EXPENSES"] ?? "",
      balanceAmt:  json['BalanceAmt'] == null
          ? "0.00"
          : double.parse(json['BalanceAmt'].toString()).toStringAsFixed(2),
    );
  }

  Map<String, dynamic> toJson() => {
    "HVno": hvno,
    "HDate": hDate,
    "HMiti": hMiti,
    "HGlDesc": hGlDesc,
    "HGlCode": hGlCode,
    "HPanNo": hPanNo,
    "HMobileNo": hMobileNo,
    "HAgent": hAgent,
    "DSno": dsno,
    "DPDesc": dpDesc,
    "DQty": dQty,
    "DAltQty": dAltQty,
    "UnitCode": unitCode,
    "AltUnitCode": altUnitCode,
    "Address": address,
    "DLocalRate": dLocalRate,
    "DBasicAmt": dBasicAmt,
    "DTermAMt": dTermAMt,
    "DNetAmt": dNetAmt,
    "HTermAMt": hTermAMt,
    "HBasicAMt": hBasicAMt,
    "HNetAmt": hNetAmt,
    "Voucher Number": voucherNumber,
    "VAT": vat,
    "IMPORT DUTY": importDuty,
    "IMPORT VAT": importVat,
    "TRANSPORT": transport,
    "OTHER EXPENSES": otherExpenses,
    "BalanceAmt": balanceAmt,
  };

  /// For PDF
  String getIndex(int index) {
    switch (index) {
      case 0:
        return dpDesc;
      case 1:
        return unitCode;
      case 2:
        return dQty;
      case 3:
        return dLocalRate;
      case 4:
        return dTermAMt;
      case 6:
        return dTermAMt;
      case 5:
        return dNetAmt;
    }
    return '';
  }
}