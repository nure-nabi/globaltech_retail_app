class AccountSubGroupModel {
  AccountSubGroupModel({
    required this.statusCode,
    required this.status,
    required this.data,
  });

  final int statusCode;
  final bool status;
  final List<AccountSubGroupDataModel> data;

  factory AccountSubGroupModel.fromJson(Map<String, dynamic> json) {
    return AccountSubGroupModel(
      statusCode: json["status_code"] ?? 0,
      status: json["status"] ?? false,
      data: json["data"] == null
          ? []
          : List<AccountSubGroupDataModel>.from(
              json["data"]!.map((x) => AccountSubGroupDataModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status": status,
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class AccountSubGroupDataModel {
  AccountSubGroupDataModel({
    required this.aCcountSubGroupCode,
    required this.aCcountSubGroupDesc,
    required this.aCcountSubGroupShortName,
    required this.accountGroupDesc,
  });

  final String aCcountSubGroupCode;
  final String aCcountSubGroupDesc;
  final String aCcountSubGroupShortName;
  final String accountGroupDesc;

  factory AccountSubGroupDataModel.fromJson(Map<String, dynamic> json) {
    return AccountSubGroupDataModel(
      aCcountSubGroupCode: json["ACcountSubGroupCode"] ?? "",
      aCcountSubGroupDesc: json["ACcountSubGroupDesc"] ?? "",
      aCcountSubGroupShortName: json["ACcountSubGroupShortName"] ?? "",
      accountGroupDesc: json["AccountGroupDesc"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "ACcountSubGroupCode": aCcountSubGroupCode,
        "ACcountSubGroupDesc": aCcountSubGroupDesc,
        "ACcountSubGroupShortName": aCcountSubGroupShortName,
        "AccountGroupDesc": accountGroupDesc,
      };
}

/*
{
	"status_code": 200,
	"status": true,
	"data": [
		{
			"ACcountSubGroupCode": "1",
			"ACcountSubGroupDesc": "TEST Sub Group",
			"ACcountSubGroupShortName": "TE00001",
			"AccountGroupDesc": "Administrative Expenses"
		}
	]
}*/
