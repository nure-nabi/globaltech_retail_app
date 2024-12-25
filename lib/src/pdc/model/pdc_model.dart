class PDCReportModel {
  PDCReportModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  final String message;
  final int statusCode;
  final List<PDCReportDataModel> data;

  factory PDCReportModel.fromJson(Map<String, dynamic> json) {
    return PDCReportModel(
      message: json["MESSAGE"] ?? "",
      statusCode: json["STATUS_CODE"] ?? 0,
      data: json["data"] == null
          ? []
          : List<PDCReportDataModel>.from(
          json["data"]!.map((x) => PDCReportDataModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "MESSAGE": message,
    "STATUS_CODE": statusCode,
    "data": List<PDCReportDataModel>.from(data.map((x) => x.toJson())),
  };
}

class PDCReportDataModel {
  PDCReportDataModel({
    required this.vno,
    required this.vDate,
    required this.vMiti,
    required this.depositType,
    required this.bankName,
    required this.branchName,
    required this.chequeNo,
    required this.chDate,
    required this.chMiti,
    required this.amount,
    required this.glDesc,
  });

  final String vno;
  final String vDate;
  final String vMiti;
  final String depositType;
  final String bankName;
  final String branchName;
  final String chequeNo;
  final String chDate;
  final String chMiti;
  final String amount;
  final String glDesc;

  factory PDCReportDataModel.fromJson(Map<String, dynamic> json) {
    return PDCReportDataModel(
      vno: json["Vno"] ?? "",
      vDate: json["VDate"] ?? "",
      vMiti: json["VMiti"] ?? "",
      depositType: json["DepositType"] ?? "",
      bankName: json["BankName"] ?? "",
      branchName: json["BranchName"] ?? "",
      chequeNo: json["ChequeNo"] ?? "",
      chDate: json["ChDate"] ?? "",
      chMiti: json["ChMiti"] ?? "",
      amount: json["Amount"] == null
          ? "0.00"
          : double.parse(json["Amount"].toString()).toStringAsFixed(2),
      glDesc: json["GlDesc"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "Vno": vno,
    "VDate": vDate,
    "VMiti": vMiti,
    "DepositType": depositType,
    "BankName": bankName,
    "BranchName": branchName,
    "ChequeNo": chequeNo,
    "ChDate": chDate,
    "ChMiti": chMiti,
    "Amount": amount,
    "GlDesc": glDesc,
  };
}
