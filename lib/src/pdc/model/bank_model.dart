class BankModel {
  BankModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  final String message;
  final int statusCode;
  final List<BankListModel> data;

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      message: json["MESSAGE"] ?? "",
      statusCode: json["STATUS_CODE"] ?? 0,
      data: json["data"] == null
          ? []
          : List<BankListModel>.from(
          json["data"]!.map((x) => BankListModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "MESSAGE": message,
    "STATUS_CODE": statusCode,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class BankListModel {
  BankListModel({required this.bankName});

  final String bankName;

  factory BankListModel.fromJson(Map<String, dynamic> json) {
    return BankListModel(
      bankName: json["BankName"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "BankName": bankName,
  };
}

/*
{
	"MESSAGE": "Succesfully",
	"STATUS_CODE": 200,
	"data": [
		{
			"BankName": "BOK"
		},
		{
			"BankName": "Himalayan"
		},
		{
			"BankName": "NIC"
		}
	]
}*/