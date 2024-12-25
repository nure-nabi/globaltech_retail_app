class CashBankPrintModel {
  CashBankPrintModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  final String message;
  final int statusCode;
  final List<CashBankPrintDataModel> data;

  factory CashBankPrintModel.fromJson(Map<String, dynamic> json) {
    return CashBankPrintModel(
      message: json["MESSAGE"] ?? "",
      statusCode: json["STATUS_CODE"] ?? 0,
      data: json["data"] == null
          ? []
          : List<CashBankPrintDataModel>.from(
          json["data"]!.map((x) => CashBankPrintDataModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "MESSAGE": message,
    "STATUS_CODE": statusCode,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class CashBankPrintDataModel {
  CashBankPrintDataModel({
    required this.vNo,
    required this.vdate,
    required this.vmiti,
    required this.masterLedger,
    required this.masterledgerCode,
    required this.usercode,
    required this.provisionalNo,
    required this.provisionaldate,
    required this.provisionalMiti,
    required this.pdcNo,
    required this.pdcDate,
    required this.pdcMiti,
    required this.cashIndentNo,
    required this.cashindentdate,
    required this.cashIndentMiti,
    required this.sno,
    required this.detailsLedger,
    required this.detailsLedgerCode,
    required this.reclocalAmt,
    required this.payLocalAmt,
    required this.narration,
    required this.remarks,
    required this.voucherType,
    required this.agent,
    required this.subledger,
  });

  final String vNo;
  final String vdate;
  final String vmiti;
  final String masterLedger;
  final String masterledgerCode;
  final String usercode;
  final String provisionalNo;
  final String provisionaldate;
  final String provisionalMiti;
  final String pdcNo;
  final String pdcDate;
  final String pdcMiti;
  final String cashIndentNo;
  final String cashindentdate;
  final String cashIndentMiti;
  final int sno;
  final String detailsLedger;
  final String detailsLedgerCode;
  final double reclocalAmt;
  final double payLocalAmt;
  final String narration;
  final String remarks;
  final String voucherType;
  final String agent;
  final String subledger;

  factory CashBankPrintDataModel.fromJson(Map<String, dynamic> json) {
    return CashBankPrintDataModel(
      vNo: json["VNo"] ?? "",
      vdate: json["Vdate"] ?? "",
      vmiti: json["Vmiti"] ?? "",
      masterLedger: json["MasterLedger"] ?? "",
      masterledgerCode: json["MasterledgerCode"] ?? "",
      usercode: json["Usercode"] ?? "",
      provisionalNo: json["ProvisionalNo"] ?? "",
      provisionaldate: json["Provisionaldate"] ?? "",
      provisionalMiti: json["ProvisionalMiti"] ?? "",
      pdcNo: json["PDCNo"] ?? "",
      pdcDate: json["PdcDate"] ?? "",
      pdcMiti: json["PdcMiti"] ?? "",
      cashIndentNo: json["CashIndentNo"] ?? "",
      cashindentdate: json["Cashindentdate"] ?? "",
      cashIndentMiti: json["CashIndentMiti"] ?? "",
      sno: json["Sno"] ?? 0,
      detailsLedger: json["DetailsLedger"] ?? "",
      detailsLedgerCode: json["DetailsLedgerCode"] ?? "",
      reclocalAmt: json["ReclocalAmt"] ?? 0.00,
      payLocalAmt: json["PayLocalAmt"] ?? 0.00,
      narration: json["Narration"] ?? "",
      remarks: json["Remarks"] ?? "",
      voucherType: json["VoucherType"] ?? "",
      agent: json["Agent"] ?? "",
      subledger: json["Subledger"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "VNo": vNo,
    "Vdate": vdate,
    "Vmiti": vmiti,
    "MasterLedger": masterLedger,
    "MasterledgerCode": masterledgerCode,
    "Usercode": usercode,
    "ProvisionalNo": provisionalNo,
    "Provisionaldate": provisionaldate,
    "ProvisionalMiti": provisionalMiti,
    "PDCNo": pdcNo,
    "PdcDate": pdcDate,
    "PdcMiti": pdcMiti,
    "CashIndentNo": cashIndentNo,
    "Cashindentdate": cashindentdate,
    "CashIndentMiti": cashIndentMiti,
    "Sno": sno,
    "DetailsLedger": detailsLedger,
    "DetailsLedgerCode": detailsLedgerCode,
    "ReclocalAmt": reclocalAmt,
    "PayLocalAmt": payLocalAmt,
    "Narration": narration,
    "Remarks": remarks,
    "VoucherType": voucherType,
    "Agent": agent,
    "Subledger": subledger,
  };
}

/*
{
	"MESSAGE": "Succesfully",
	"STATUS_CODE": 200,
	"data": [
		{
			"VNo": "CB-0022",
			"Vdate": "2023",
			"Vmiti": "13",
			"MasterLedger": "Cash In Hand",
			"MasterledgerCode": "Y000000001",
			"Usercode": "OMS",
			"ProvisionalNo": "",
			"Provisionaldate": "",
			"ProvisionalMiti": "",
			"PDCNo": "17",
			"PdcDate": "2023",
			"PdcMiti": "13",
			"CashIndentNo": "",
			"Cashindentdate": "",
			"CashIndentMiti": "",
			"Sno": 1,
			"DetailsLedger": "New uma store1",
			"DetailsLedgerCode": "62",
			"ReclocalAmt": 0,
			"PayLocalAmt": 25,
			"Narration": "Draw On Self",
			"Remarks": "",
			"VoucherType": "Payment",
			"Agent": "",
			"Subledger": ""
		}
	]
}*/