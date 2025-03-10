
class AllOrderDetailsModel {
  AllOrderDetailsModel({
    required this.dbName,
    required this.glCode,
    required this.userCode,
    required this.pcode,
    required this.rate,
    required this.qty,
    required this.totalAmt,
    required this.comment,
  });

  final String dbName;
  final String glCode;
  final String userCode;
  final String pcode;
  final String rate;
  final String qty;
  final String totalAmt;
  final String comment;

  factory AllOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return AllOrderDetailsModel(
      dbName: json["DbName"] ?? "",
      glCode: json["GlCode"] ?? "",
      userCode: json["UserCode"] ?? "",
      pcode: json["Pcode"] ?? "",
      qty: json["Qty"] ?? "",
      rate: json["Rate"] ?? "",
      totalAmt: json["TotalAmt"] ?? "",
      comment: json["Comment"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "DbName": dbName,
        "GlCode": glCode,
        "UserCode": userCode,
        "Pcode": pcode,
        "Qty": qty,
        "Rate": rate,
        "TotalAmt": totalAmt,
        "Comment": comment,
      };
}
