import 'package:retail_app/constants/assets_list.dart';

class SalesBillTermModel {
  SalesBillTermModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  final String message;
  final int statusCode;
  final List<SalesBillTermDataModel> data;

  factory SalesBillTermModel.fromJson(Map<String, dynamic> json) {
    return SalesBillTermModel(
      message: json["MESSAGE"] ?? "",
      statusCode: json["STATUS_CODE"] ?? 0,
      data: json["data"] == null
          ? []
          : List<SalesBillTermDataModel>.from(
        json["data"]!.map((x) => SalesBillTermDataModel.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "MESSAGE": message,
    "STATUS_CODE": statusCode,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class SalesBillTermDataModel {
  SalesBillTermDataModel({
    required this.pTCode,
    required this.pTDesc,
    required this.basis,
    required this.type,
    required this.pTRate,
    required this.sign,

  });

  final String pTCode;
  final String pTDesc;
  final String basis;
  final String type;
  final String pTRate;
  final String sign;


  factory SalesBillTermDataModel.fromJson(Map<String, dynamic> json) {
    return SalesBillTermDataModel(
      pTCode: json["PTCode"]  == null ? "0" : "${json["PTCode"]}",
      pTDesc: json["PTDesc"] ?? "",
      basis: json["Basis"] ?? "",
      type: json["Type"] ?? "",
      pTRate: json["PTRate"] == null ? "0.0" : "${json["PTRate"]}",
      sign: json["Sign"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "PTCode": pTCode,
    "PTDesc": pTDesc,
    "Basis": basis,
    "Type": type,
    "PTRate": pTRate,
    "Sign": sign,

  };
}
