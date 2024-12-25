import 'package:fluttertoast/fluttertoast.dart';

class TempProductOrderModel {
  TempProductOrderModel({
     this.id,
    required this.pCode,
    required this.pName,
    required this.rate,
    required this.quantity,
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
    required this.sign3,

    required this.totalAmount,




  });

  final int? id;
  final String pCode;
  final String pName;
  final String rate;
  final String quantity;
  final String pTerm1Code;
  final String pTerm1Rate;
  final String pTerm1Amount;
  final String sign1;
  final String pTerm2Code;
  final String pTerm2Rate;
  final String pTerm2Amount;
  final String sign2;

  final String pTerm3Code;
  final String pTerm3Rate;
  final String pTerm3Amount;
  final String sign3;

  final String totalAmount;




  factory TempProductOrderModel.fromJson(Map<String, dynamic> json) {
    return TempProductOrderModel(
      id: json["Id"] ?? 0,
      pCode: json["PCode"] ?? "",
      pName: json["PName"] ?? "",
      quantity: json["Qty"] ?? "",
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
      rate: json["Rate"] ?? "",
      totalAmount: json["TotalAmt"] ?? "",

    );
  }


  Map<String, dynamic> toJson() => {
    "Id": id,
    "PCode": pCode,
    "PName": pName,
    "Qty": quantity,
    "Rate": rate,
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
    "Sign3": sign3,
    "TotalAmt": totalAmount,
  };
  /// For PDF
  String getIndex(int index) {
    switch (index) {
      case 0:
        return pCode;
      case 1:
        return pName;
      case 2:
        return quantity;
      case 3:
        return rate;
      case 4:
        return totalAmount;
    }
    return '';
  }
}
