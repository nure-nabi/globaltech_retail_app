class GroupModel {
  GroupModel({
    required this.statusCode,
    required this.status,
    required this.data,
  });

  final int statusCode;
  final bool status;
  final List<GroupDataModel> data;

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      statusCode: json["status_code"] ?? 0,
      status: json["status"] ?? false,
      data: json["data"] == null
          ? []
          : List<GroupDataModel>.from(
        json["data"].map((x) => GroupDataModel.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status": status,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class GroupDataModel {
  GroupDataModel({
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

  factory GroupDataModel.fromJson(Map<String, dynamic> json) {
    return GroupDataModel(
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
