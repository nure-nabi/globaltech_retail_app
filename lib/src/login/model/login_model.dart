class CompanyDetailsModel {
  CompanyDetailsModel({
    required this.dbName,
    required this.companyName,
    required this.ledgerCode,
    required this.auth,
    required this.post,
    required this.initial,
    required this.startDate,
    required this.endDate,
    required this.companyAddress,
    required this.phoneNo,
    required this.vatNo,
    required this.email,
    required this.aliasName,
  });

  final String dbName;
  final String companyName;
  final String ledgerCode;
  final String auth;
  final String post;
  final String initial;
  final String startDate;
  final String endDate;
  final String companyAddress;
  final String phoneNo;
  final String vatNo;
  final String email;
  final String aliasName;

  factory CompanyDetailsModel.fromJson(Map<String, dynamic> json) {
    return CompanyDetailsModel(
      dbName: json["DbName"] ?? "",
      companyName: json["CompanyName"] ?? "",
      ledgerCode: json["LedgerCode"] ?? "",
      auth: json["Auth"] ?? "",
      post: json["Post"] ?? "",
      initial: json["Initial"] ?? "",
      startDate: json["StartDate"] ?? "",
      endDate: json["EndDate"] ?? "",
      companyAddress: json["CompanyAddress"] ?? "",
      phoneNo: json["PhoneNo"] ?? "",
      vatNo: json["VatNo"] ?? "",
      email: json["Email"] ?? "",
      aliasName: json["AliasName"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "DbName": dbName,
        "CompanyName": companyName,
         "LedgerCode": ledgerCode,
        "Auth": auth,
        "Post": post,
        "Initial": initial,
        "StartDate": startDate,
        "EndDate": endDate,
        "CompanyAddress": companyAddress,
        "PhoneNo": phoneNo,
        "VatNo": vatNo,
        "Email": email,
        "AliasName": aliasName,
      };
}

class CompanyModel {
  CompanyModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  final String message;
  final int statusCode;
  final List<CompanyDetailsModel> data;

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      message: json["message"] ?? "",
      statusCode: json["status_code"] ?? 0,
      data: json["data"] == null
          ? []
          : List<CompanyDetailsModel>.from(
              json["data"].map((x) => CompanyDetailsModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": data.map((x) => x.toJson()).toList(),
      };
}
