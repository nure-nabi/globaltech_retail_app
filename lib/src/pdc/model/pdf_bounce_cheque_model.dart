class PdcBounceModel {
  PdcBounceModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  final String message;
  final int statusCode;
  final List<PdcBounceDataModel> data;

  factory PdcBounceModel.fromJson(Map<String, dynamic> json) {
    return PdcBounceModel(
      message: json["MESSAGE"] ?? "",
      statusCode: json["STATUS_CODE"] ?? 0,
      data: json["data"] == null
          ? []
          : List<PdcBounceDataModel>.from(
              json["data"]!.map((x) => PdcBounceDataModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "MESSAGE": message,
        "STATUS_CODE": statusCode,
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class PdcBounceDataModel {
  PdcBounceDataModel({
    required this.vno,
    required this.pdcdate,
    required this.depositType,
    required this.bankName,
    required this.branchName,
    required this.chequeNo,
    required this.chdate,
    required this.chMiti,
    required this.drawOn,
    required this.amount,
    required this.glDesc,
    required this.remarks,
    required this.bounceDate,
    required this.bounceMiti,
    required this.bounceRemarks,
  });

  final String vno;
  final String pdcdate;
  final String depositType;
  final String bankName;
  final String branchName;
  final String chequeNo;
  final String chdate;
  final String chMiti;
  final String drawOn;
  final double amount;
  final String glDesc;
  final String remarks;
  final String bounceDate;
  final String bounceMiti;
  final String bounceRemarks;

  factory PdcBounceDataModel.fromJson(Map<String, dynamic> json) {
    return PdcBounceDataModel(
      vno: json["Vno"] ?? "",
      pdcdate: json["Pdcdate"] ?? "",
      depositType: json["DepositType"] ?? "",
      bankName: json["BankName"] ?? "",
      branchName: json["BranchName"] ?? "",
      chequeNo: json["ChequeNo"] ?? "",
      chdate: json["Chdate"] ?? "",
      chMiti: json["ChMiti"] ?? "",
      drawOn: json["DrawOn"] ?? "",
      amount: json["Amount"] ?? 0.00,
      glDesc: json["GlDesc"] ?? "",
      remarks: json["Remarks"] ?? "",
      bounceDate: json["BounceDate"] ?? "",
      bounceMiti: json["BounceMiti"] ?? "",
      bounceRemarks: json["BounceRemarks"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "Vno": vno,
        "Pdcdate": pdcdate,
        "DepositType": depositType,
        "BankName": bankName,
        "BranchName": branchName,
        "ChequeNo": chequeNo,
        "Chdate": chdate,
        "ChMiti": chMiti,
        "DrawOn": drawOn,
        "Amount": amount,
        "GlDesc": glDesc,
        "Remarks": remarks,
        "BounceDate": bounceDate,
        "BounceMiti": bounceMiti,
        "BounceRemarks": bounceRemarks,
      };
}

/*
{
	"MESSAGE": "Succesfully",
	"STATUS_CODE": 200,
	"data": [
		{
			"Vno": "36",
			"Pdcdate": "2024",
			"DepositType": "Deposit",
			"BankName": "Himalayan",
			"BranchName": "",
			"ChequeNo": "123456",
			"Chdate": "2024:00",
			"ChMiti": "20/1080",
			"DrawOn": "Self",
			"Amount": 2000,
			"GlDesc": "",
			"Remarks": "ok",
			"BounceDate": "2024-000:00",
			"BounceMiti": "20/180",
			"BounceRemarks": "Insuficiant balance"
		},
		{
			"Vno": "36",
			"Pdcdate": "2024-04-02T16:57:47.473",
			"DepositType": "Deposit",
			"BankName": "Himalayan",
			"BranchName": "",
			"ChequeNo": "123456",
			"Chdate": "2024-04-02T00:00:00",
			"ChMiti": "20/12/2080",
			"DrawOn": "Self",
			"Amount": 2000,
			"GlDesc": "",
			"Remarks": "ok",
			"BounceDate": "2024-04-01T00:00:00",
			"BounceMiti": "20/12/2080",
			"BounceRemarks": "Insuficiant balance again"
		}
	]
}*/