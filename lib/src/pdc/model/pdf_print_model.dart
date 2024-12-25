class PdcPrintModel {
  PdcPrintModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  final String message;
  final int statusCode;
  final List<PDCPrintDataModel> data;

  factory PdcPrintModel.fromJson(Map<String, dynamic> json) {
    return PdcPrintModel(
      message: json["MESSAGE"] ?? "",
      statusCode: json["STATUS_CODE"] ?? 0,
      data: json["data"] == null
          ? []
          : List<PDCPrintDataModel>.from(
          json["data"]!.map((x) => PDCPrintDataModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "MESSAGE": message,
    "STATUS_CODE": statusCode,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class PDCPrintDataModel {
  PDCPrintDataModel({
    required this.vno,
    required this.vDate,
    required this.vMiti,
    required this.depositType,
    required this.bankName,
    required this.branchName,
    required this.chequeNo,
    required this.chDate,
    required this.chMiti,
    required this.drawOn,
    required this.amount,
    required this.glcode,
    required this.glshortName,
    required this.gldesc,
    required this.slCode,
    required this.slshortname,
    required this.sldesc,
    required this.agentCode,
    required this.agentShortName,
    required this.agentDesc,
    required this.remarks,
    required this.createdBy,
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
  final String drawOn;
  final double amount;
  final String glcode;
  final String glshortName;
  final String gldesc;
  final String slCode;
  final String slshortname;
  final String sldesc;
  final String agentCode;
  final String agentShortName;
  final String agentDesc;
  final String remarks;
  final String createdBy;

  factory PDCPrintDataModel.fromJson(Map<String, dynamic> json) {
    return PDCPrintDataModel(
      vno: json["Vno"] ?? "",
      vDate: json["VDate"] ?? "",
      vMiti: json["VMiti"] ?? "",
      depositType: json["DepositType"] ?? "",
      bankName: json["BankName"] ?? "",
      branchName: json["BranchName"] ?? "",
      chequeNo: json["ChequeNo"] ?? "",
      chDate: json["ChDate"] ?? "",
      chMiti: json["ChMiti"] ?? "",
      drawOn: json["DrawOn"] ?? "",
      amount: json["Amount"] ?? 0.00,
      glcode: json["Glcode"] ?? "",
      glshortName: json["GlshortName"] ?? "",
      gldesc: json["Gldesc"] ?? "",
      slCode: json["SLCode"] ?? "",
      slshortname: json["Slshortname"] ?? "",
      sldesc: json["Sldesc"] ?? "",
      agentCode: json["AgentCode"] ?? "",
      agentShortName: json["AgentShortName"] ?? "",
      agentDesc: json["AgentDesc"] ?? "",
      remarks: json["Remarks"] ?? "",
      createdBy: json["CreatedBy"] ?? "",
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
    "DrawOn": drawOn,
    "Amount": amount,
    "Glcode": glcode,
    "GlshortName": glshortName,
    "Gldesc": gldesc,
    "SLCode": slCode,
    "Slshortname": slshortname,
    "Sldesc": sldesc,
    "AgentCode": agentCode,
    "AgentShortName": agentShortName,
    "AgentDesc": agentDesc,
    "Remarks": remarks,
    "CreatedBy": createdBy,
  };
}

/*
{
	"MESSAGE": "Succesfully",
	"STATUS_CODE": 200,
	"data": [
		{
			"Vno": "PDC-0001",
			"VDate": "0",
			"VMiti": "2",
			"DepositType": "Receipt",
			"BankName": "nic",
			"BranchName": "ktm",
			"ChequeNo": "sa1213",
			"ChDate": "",
			"ChMiti": "",
			"DrawOn": "sanjay",
			"Amount": 1000,
			"Glcode": "17",
			"GlshortName": "17",
			"Gldesc": "Banepa Trading",
			"SLCode": "",
			"Slshortname": "",
			"Sldesc": "",
			"AgentCode": "",
			"AgentShortName": "",
			"AgentDesc": "",
			"Remarks": "",
			"CreatedBy": "OMS"
		}
	]
}*/