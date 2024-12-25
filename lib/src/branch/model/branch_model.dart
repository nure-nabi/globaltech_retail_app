class BranchDetailsModel {
  BranchDetailsModel({
    required this.unitCode,
    required this.unitDesc,
    required this.unitShortName,
  });

  final String unitCode;
  final String unitDesc;
  final String unitShortName;


  factory BranchDetailsModel.fromJson(Map<String, dynamic> json) {
    return BranchDetailsModel(
    unitCode: json["UnitCode"] ?? "",
unitDesc: json["UnitDesc"] ?? "",
unitShortName: json["UnitShortName"] ?? "",

    );
  }

  Map<String, dynamic> toJson() => {
    "UnitCode": unitCode,
    "UnitDesc": unitDesc,
    "UnitShortName": unitShortName,

  };
}

class BranchModel {
  BranchModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  final String message;
  final int statusCode;
  final List<BranchDetailsModel> data;

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      message: json["message"] ?? "",
      statusCode: json["status_code"] ?? 0,
      data: json["data"] == null
          ? []
          : List<BranchDetailsModel>.from(
          json["data"].map((x) => BranchDetailsModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data.map((x) => x.toJson()).toList(),
  };
}
