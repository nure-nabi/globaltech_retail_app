class OrderPostModel {
  OrderPostModel({
    required this.dbName,
    required this.salesImage,
    required this.imagePath,
    required this.orderDetails,
  });

  final String dbName;
  final String salesImage;
  final String imagePath;
  final List<OrderDetail> orderDetails;

  factory OrderPostModel.fromJson(Map<String, dynamic> json) {
    return OrderPostModel(
      dbName: json["DbName"] ?? "",
      salesImage: json["SalesImage"] ?? "",
      imagePath: json["ImagePath"] ?? "",
      orderDetails: json["OrderDetails"] == null
          ? []
          : List<OrderDetail>.from(
          json["OrderDetails"].map((x) => OrderDetail.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "DbName": dbName,
    "SalesImage": salesImage,
    "ImagePath": imagePath,
    "OrderDetails": List<dynamic>.from(orderDetails.map((x) => x.toJson())),
  };
}

class OrderDetail {
  OrderDetail({
    required this.outletCode,
    required this.unit,
    required this.bTerm1,
    required this.bTerm1Rate,
    required this.bTerm1Amount,
    required this.bTerm2,
    required this.bTerm2Rate,
    required this.bTerm2Amount,
    required this.bTerm3,
    required this.bTerm3Rate,
    required this.bTerm3Amount,
    required this.itemDetails,
  });

  final String outletCode;
  final String unit;
  final String bTerm1;
  final String bTerm1Rate;
  final String bTerm1Amount;
  final String bTerm2;
  final String bTerm2Rate;
  final String bTerm2Amount;
  final String bTerm3;
  final String bTerm3Rate;
  final String bTerm3Amount;
  final List<OrderPostItemDetailModel> itemDetails;

  //


  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      outletCode: json["OutletCode"] ?? "",
      unit: json["Unit"] ?? "",
      bTerm1: json["BTerm1"] ?? "",
      bTerm1Rate: json["BTerm1Rate"] ?? "",
      bTerm1Amount: json["BTerm1Amount"] ?? "",
      bTerm2: json["BTerm2"] ?? "",
      bTerm2Rate: json["BTerm2Rate"] ?? "",
      bTerm2Amount: json["BTerm2Amount"] ?? "",
      bTerm3: json["BTerm3"] ?? "",
      bTerm3Rate: json["BTerm3Rate"] ?? "",
      bTerm3Amount: json["BTerm3Amount"] ?? "",
      itemDetails: json["ItemDetails"] == null
          ? []
          : List<OrderPostItemDetailModel>.from(
          json["ItemDetails"].map((x) => OrderPostItemDetailModel.fromJson(x))),
    );
  }
// "OutletCode": "17",
  // "Unit": "HETAUDA_BROILER",
  // "BTerm1": "",
  // "BTerm1Rate": "0.0",
  // "BTerm1Amount": "0.0",
  // "BTerm2": "",
  // "BTerm2Rate": "0.0",
  // "BTerm2Amount": "0.0",
  // "BTerm3": "",
  // "BTerm3Rate": "0.0",
  // "BTerm3Amount": "0.0",
  Map<String, dynamic> toJson() => {
    "OutletCode": outletCode,
    "Unit": unit,
    "BTerm1": bTerm1,
    "BTerm1Rate": bTerm1Rate,
    "BTerm1Amount": bTerm1Amount,
    "BTerm2": bTerm2,
    "BTerm2Rate": bTerm2Rate,
    "BTerm2Amount": bTerm2Amount,
    "BTerm3": bTerm3,
    "BTerm3Rate": bTerm3Rate,
    "BTerm3Amount": bTerm3Amount,
    "ItemDetails": List<dynamic>.from(itemDetails.map((x) => x.toJson())),
  };
}




class OrderPostItemDetailModel {
  OrderPostItemDetailModel({
    required this.itemCode,
    required this.qty,
    required this.rate,
    required this.totalAmt,

    required this.pTerm1Code,
    required this.pTerm1Rate,
    required this.pTerm1Amount,
    required this.pTerm2Code,
    required this.pTerm2Rate,
    required this.pTerm2Amount,
    required this.pTerm3Code,
    required this.pTerm3Rate,
    required this.pTerm3Amount,
    required this.godownCode,

  });

  final String itemCode;
  final String qty;
  final String rate;
  final String totalAmt;
  final String pTerm1Code;
  final String pTerm1Rate;
  final String pTerm1Amount;
  final String pTerm2Code;
  final String pTerm2Rate;
  final String pTerm2Amount;
  final String pTerm3Code;
  final String pTerm3Rate;
  final String pTerm3Amount;
  final String godownCode;


  factory OrderPostItemDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderPostItemDetailModel(
      itemCode: json["itemCode"] ?? "",
      qty: json["qty"] ?? "",
      rate: json["rate"] ?? "",
      totalAmt: json["totalAmt"] ?? "",
      pTerm1Code: json["PTerm1Code"] ?? "",
      pTerm1Rate: json["PTerm1Rate"] ?? "",
      pTerm1Amount: json["PTerm1Amount"] ?? "",
      pTerm2Code: json["PTerm2Code"] ?? "",
      pTerm2Rate: json["PTerm2Rate"] ?? "",
      pTerm2Amount: json["PTerm2Amount"] ?? "",
      pTerm3Code: json["PTerm3Code"] ?? "",
      pTerm3Rate: json["PTerm3Rate"] ?? "",
      pTerm3Amount: json["PTerm3Amount"] ?? "",

      godownCode: json["godownCode"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "itemCode": itemCode,
    "qty": qty,
    "rate": rate,
    "totalAmt": totalAmt,
    "PTerm1Code": pTerm1Code,
    "PTerm1Rate": pTerm1Rate,
    "PTerm1Amount": pTerm1Amount,
    "PTerm2Code": pTerm2Code,
    "PTerm2Rate": pTerm2Rate,
    "PTerm2Amount": pTerm2Amount,
    "PTerm3Code": pTerm3Code,
    "PTerm3Rate": pTerm3Rate,
    "PTerm3Amount": pTerm3Amount,

    "godownCode":godownCode,
  };
}

