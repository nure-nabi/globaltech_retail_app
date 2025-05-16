import 'package:fluttertoast/fluttertoast.dart';

class ProductOrderModel {
  ProductOrderModel({
    required this.itemCode,
    required this.pName,
    required this.qty,
    required this.rate,
    required this.totalAmt,
    required this.netTotalAmt,
    required this.pTerm1Code,
    required this.pTerm1Rate,
    required this.pTerm1Amount,
    required this.sign1,

    required this.pTerm2Code,
    required this.pTerm2Rate,
    required this.pTerm2Amount,
    required this.sign2,

    required this.pTerm3Code,
    required this.pTerm3Rate,
    required this.pTerm3Amount,

    required this.bTerm1,
    required this.bTerm1Rate,
    required this.bTerm1Amount,
    required this.sign3,
    required this.bSign1,

    required this.bTerm2,
    required this.bTerm2Rate,
    required this.bTerm2Amount,
    required this.bSign2,

    required this.bTerm3,
    required this.bTerm3Rate,
    required this.bTerm3Amount,
    required this.bSign3,

    required this.godownCode,
    required this.dbName,
    required this.salesImage,
    required this.imagePath,
    required this.outletCode,
    required this.unit,
    required this.altUnit,
    required this.altQty,
    required this.hsCode,
    required this.factor,
    required this.payAmount,
    required this.billNetAmt,
    required this.userCode,
    required this.cashGlCode,




  });


  final String itemCode;
  final String pName;
  final String qty;
  final String rate;
  final String totalAmt;
  final String netTotalAmt;
  final String pTerm1Code;
  final String pTerm1Rate;
  final String pTerm1Amount;
  final String pTerm2Code;
  final String pTerm2Rate;
  final String pTerm2Amount;

  final String pTerm3Code;
  final String pTerm3Rate;
  final String pTerm3Amount;
  final String sign1;

  final String bTerm1;
  final String bTerm1Rate;
  final String bTerm1Amount;
  final String sign2;
  final String bSign1;

  final String bTerm2;
  final String bTerm2Rate;
  final String bTerm2Amount;
  final String sign3;
  final String bSign2;

  final String bTerm3;
  final String bTerm3Rate;
  final String bTerm3Amount;
  final String bSign3;


  final String godownCode;


  final String dbName;
  final String salesImage;
  final String imagePath;
  final String outletCode;
  final String unit;
  final String altUnit;
  final String altQty;
  final String hsCode;
  final String factor;
  final String payAmount;
  final String billNetAmt;
  final String userCode;
  final String cashGlCode;


  factory ProductOrderModel.fromJson(Map<String, dynamic> json) {
    return ProductOrderModel(
      itemCode: json["itemCode"] ?? "",
      pName: json["PName"] ?? "",
      qty: json["Qty"] ?? "",
      rate: json["Rate"] ?? "",
      totalAmt: json["TotalAmt"] ?? "",
      netTotalAmt: json["netTotalAmt"] ?? "",
      pTerm1Code: json["PTerm1Code"] ?? "",
      pTerm1Rate: json["PTerm1Rate"] ?? "",
      pTerm1Amount: json["PTerm1Amount"] ?? "",
      sign1: json["Sign1"] ?? "",
      pTerm2Code: json["PTerm2Code"] ?? "",
      pTerm2Rate: json["PTerm2Rate"] ?? "",
      pTerm2Amount: json["PTerm2Amount"] ?? "",
      sign2: json["Sign2"] ?? "",
      pTerm3Code: json["PTerm3Code"] ?? "",
      pTerm3Rate: json["PTerm3Rate"] ?? "",
      pTerm3Amount: json["PTerm3Amount"] ?? "",
      sign3: json["Sign3"] ?? "",

      bTerm1: json["BTerm1"] ?? "",
      bTerm1Rate: json["BTerm1Rate"] ?? "",
      bTerm1Amount: json["BTerm1Amount"] ?? "",
      bSign1: json["BSign1"] ?? "",
      bTerm2: json["BTerm2"] ?? "",
      bTerm2Rate: json["BTerm2Rate"] ?? "",
      bTerm2Amount: json["BTerm2Amount"] ?? "",
      bSign2: json["BSign2"] ?? "",

      bTerm3: json["BTerm3"] ?? "",
      bTerm3Rate: json["BTerm3Rate"] ?? "",
      bTerm3Amount: json["BTerm3Amount"] ?? "",
      bSign3: json["bSign3"] ?? "",
      godownCode: json["godownCode"] ?? "",

      dbName: json["DbName"] ?? "",
      salesImage: json["SalesImage"] ?? "",
      imagePath: json["ImagePath"] ?? "",
      outletCode: json["OutletCode"] ?? "",
      unit: json["Unit"] ?? "",
      altUnit: json["AltUnit"] ?? "",
      altQty: json["AltQty"] == null ? "" : "${json["AltQty"]}",
      hsCode: json["HsCode"] ?? "",
      factor: json["Factor"] == null ? "" : "${json["Factor"]}",
      payAmount: json["PayAmount"] == null ? "" : "${json["PayAmount"]}",
      userCode: json["UserCode"] ?? "",
      billNetAmt: json["BillNetAmt"] == null ? "" : "${json["BillNetAmt"]}",
      cashGlCode: json["CashGlCode"] ?? "",


      // static String bTerm1 =  "BTerm1";
      // static String bTerm1Rate =  "BTerm1Rate";
      // static String bTerm1Amount =  "BTerm1Amount";

    );
  }

  Map<String, dynamic> toJson() => {
    "itemCode": itemCode,
    "PName": pName,
    "Qty": qty,
    "Rate": rate,
    "TotalAmt": totalAmt,
    "netTotalAmt": netTotalAmt,
    "PTerm1Code": pTerm1Code,
    "PTerm1Rate": pTerm1Rate,
    "PTerm1Amount": pTerm1Amount,
    "Sign1": sign1,
    "PTerm2Code": pTerm2Code,
    "PTerm2Rate": pTerm2Rate,
    "PTerm2Amount": pTerm2Amount,
    "Sign2": sign2,
    "PTerm3Code": pTerm3Code,
    "PTerm3Rate": pTerm3Rate,
    "PTerm3Amount": pTerm3Amount,
    "BTerm1": bTerm1,
    "BTerm1Rate": bTerm1Rate,
    "BTerm1Amount": bTerm1Amount,
    "BSign1": bSign1,
    "Sign3": sign3,
    "BTerm2": bTerm2,
    "BTerm2Rate": bTerm2Rate,
    "BTerm2Amount": bTerm2Amount,
    "BSign2": bSign2,
    "BTerm3": bTerm3,
    "BTerm3Rate": bTerm3Rate,
    "BTerm3Amount": bTerm3Amount,
    "BSign3": bSign3,
    "godownCode": godownCode,

    "DbName": dbName,
    "SalesImage": salesImage,
    "ImagePath": imagePath,
    "OutletCode": outletCode,
    "Unit": unit,
    "AltUnit": altUnit,
    "AltQty": altQty,
    "HsCode": hsCode,
    "Factor": factor,
    "PayAmount": payAmount,
    "UserCode": userCode,
    "BillNetAmt": billNetAmt,
    "CashGlCode": cashGlCode,

  };

  /// For PDF
  String getIndex(int index,String disc,String vat) {
    switch (index) {
      case 0:
        return pName;
      case 1:
        return qty;
      case 2:
        return rate;
      case 3:
        return netTotalAmt;
      case 4:
        if(disc == "0.0"){
          return totalAmt;
        }else{
          return pTerm1Amount;
        }
      case 5:
        if(vat == "0.0"){
          return totalAmt;
        }else{
          return pTerm2Amount;
        }
      case 6:
        return totalAmt;
    }
    return '';
  }
}

class ProductOrderPdfShowModel {
  ProductOrderPdfShowModel({
     this.pName,
     this.qty,
     this.rate,
     this.totalAmt,
     this.netTotalAmt,

     this.pTerm1Code,
     this.pTerm1Rate,
     this.pTerm1Amount,

     this.pTerm2Code,
     this.pTerm2Rate,
     this.pTerm2Amount,

     this.pTerm3Code,
     this.pTerm3Rate,
     this.pTerm3Amount,

     this.bTerm1,
     this.bTerm1Rate,
     this.bTerm1Amount,

     this.bTerm2,
     this.bTerm2Rate,
     this.bTerm2Amount,

     this.bTerm3,
     this.bTerm3Rate,
     this.bTerm3Amount,

  });



    String? pName;
  final String? qty;
  final String? rate;
  final String? totalAmt;
  final String? netTotalAmt;
  final String? pTerm1Code;
  final String? pTerm1Rate;
  final String? pTerm1Amount;
  final String? pTerm2Code;
  final String? pTerm2Rate;
  final String? pTerm2Amount;

  final String? pTerm3Code;
  final String? pTerm3Rate;
  final String? pTerm3Amount;


  final String? bTerm1;
  final String? bTerm1Rate;
  final String? bTerm1Amount;


  final String? bTerm2;
  final String? bTerm2Rate;
  final String? bTerm2Amount;


  final String? bTerm3;
  final String? bTerm3Rate;
  final String? bTerm3Amount;






  factory ProductOrderPdfShowModel.fromJson(Map<String, dynamic> json) {
    return ProductOrderPdfShowModel(
      pName: json["PName"] ?? "",
      qty: json["Qty"] ?? "",
      rate: json["Rate"] ?? "",
      totalAmt: json["totalAmt"] ?? "",
      netTotalAmt: json["netTotalAmt"] ?? "",
      pTerm1Code: json["PTerm1Code"] ?? "",
      pTerm1Rate: json["PTerm1Rate"] ?? "",
      pTerm1Amount: json["PTerm1Amount"] ?? "",

      pTerm2Code: json["PTerm2Code"] ?? "",
      pTerm2Rate: json["PTerm2Rate"] ?? "",
      pTerm2Amount: json["PTerm2Amount"] ?? "",

      pTerm3Code: json["PTerm3Code"] ?? "",
      pTerm3Rate: json["PTerm3Rate"] ?? "",
      pTerm3Amount: json["PTerm3Amount"] ?? "",


      bTerm1: json["BTerm1"] ?? "",
      bTerm1Rate: json["BTerm1Rate"] ?? "",
      bTerm1Amount: json["BTerm1Amount"] ?? "",

      bTerm2: json["BTerm2"] ?? "",
      bTerm2Rate: json["BTerm2Rate"] ?? "",
      bTerm2Amount: json["BTerm2Amount"] ?? "",


      bTerm3: json["BTerm3"] ?? "",
      bTerm3Rate: json["BTerm3Rate"] ?? "",
      bTerm3Amount: json["BTerm3Amount"] ?? "",

    );
  }

  Map<String, dynamic> toJson() => {

    "PName": pName,
    "Qty": qty,
    "Rate": rate,
    "totalAmt": totalAmt,
    "netTotalAmt": netTotalAmt,
    "PTerm1Code": pTerm1Code,
    "PTerm1Rate": pTerm1Rate,
    "PTerm1Amount": pTerm1Amount,

    "PTerm2Code": pTerm2Code,
    "PTerm2Rate": pTerm2Rate,
    "PTerm2Amount": pTerm2Amount,

    "PTerm3Code": pTerm3Code,
    "PTerm3Rate": pTerm3Rate,
    "PTerm3Amount": pTerm3Amount,
    "BTerm1": bTerm1,
    "BTerm1Rate": bTerm1Rate,
    "BTerm1Amount": bTerm1Amount,

    "BTerm2": bTerm2,
    "BTerm2Rate": bTerm2Rate,
    "BTerm2Amount": bTerm2Amount,

    "BTerm3": bTerm3,
    "BTerm3Rate": bTerm3Rate,
    "BTerm3Amount": bTerm3Amount,

  };

  /// For PDF
  String? getIndex(int index,String disc,String vat) {
    switch (index) {
      case 0:
        return pName;
      case 1:
        return qty;
      case 2:
        return rate;
      case 3:
        return netTotalAmt;
      case 4:
        if(disc == "0.0"){
          return totalAmt;
        }else{
          return pTerm1Amount;
        }
      case 5:
        if(vat == "0.0"){
          return totalAmt;
        }else{
          return pTerm2Amount;
        }
      case 6:
        return totalAmt;
    }
    return '';
  }
}
