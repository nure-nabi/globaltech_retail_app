class ResponseModel {
  ResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  final String message;
  final int statusCode;
  final List<AccountGroupListDataModel> data;

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      message: json["message"] ?? "",
      statusCode: json["status_code"] ?? 0,
      data: json["data"] == null ? [] : List<AccountGroupListDataModel>.from(
        json["data"].map((x) => AccountGroupListDataModel.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class AccountGroupListDataModel {
  AccountGroupListDataModel({
    required this.grpCode,
    required this.grpDesc,
    required this.grpShortName,
    required this.grpSchedule,
    required this.primaryGrp,
  });

  final String grpCode;
  final String grpDesc;
  final String grpShortName;
  final String grpSchedule;
  final String primaryGrp;

  factory AccountGroupListDataModel.fromJson(Map<String, dynamic> json) {
    return AccountGroupListDataModel(
      grpCode: json["GrpCode"] ?? "",
      grpDesc: json["GrpDesc"] ?? "",
      grpShortName: json["GrpShortName"] ?? "",
      grpSchedule: json["GrpSchedule"] ?? "",
      primaryGrp: json["PrimaryGrp"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "GrpCode": grpCode,
    "GrpDesc": grpDesc,
    "GrpShortName": grpShortName,
    "GrpSchedule": grpSchedule,
    "PrimaryGrp": primaryGrp,
  };
}
