import 'package:retail_app/constants/assets_list.dart';

class ProductModel {
  ProductModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  final String message;
  final int statusCode;
  final List<ProductDataModel> data;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      message: json["MESSAGE"] ?? "",
      statusCode: json["STATUS_CODE"] ?? 0,
      data: json["data"] == null
          ? []
          : List<ProductDataModel>.from(
        json["data"]!.map((x) => ProductDataModel.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "MESSAGE": message,
    "STATUS_CODE": statusCode,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class ProductDataModel {
  ProductDataModel({
    required this.pCode,
    required this.pDesc,
    required this.pShortName,
    required this.groupName,
    required this.subGroupName,
    required this.group1,
    required this.group2,
    required this.unit,
    required this.altUnit,
    required this.altQty,
    required this.hsCode,
    required this.buyRate,
    required this.salesRate,
    required this.mrp,
    required this.tradeRate,
    required this.discountPercentage,
    required this.imageName,
    required this.pImage,
    required this.imageFolderName,
    required this.offerDiscount,
    required this.stockStatus,
    required this.stockQty,
  });

  final String pCode;
  final String pDesc;
  final String pShortName;
  final String groupName;
  final String subGroupName;
  final String group1;
  final String group2;
  final String unit;
  final String altUnit;
  final String altQty;
  final String hsCode;
  final String buyRate;
  final String salesRate;
  final String mrp;
  final String tradeRate;
  final String discountPercentage;
  final String imageName;
  final String pImage;
  final String imageFolderName;
  final String offerDiscount;
  final String stockStatus;
  final String stockQty;

  factory ProductDataModel.fromJson(Map<String, dynamic> json) {
    return ProductDataModel(
      pCode: json["PCode"] ?? "",
      pDesc: json["PDesc"] ?? "",
      pShortName: json["PShortName"] ?? "",
      groupName: json["GroupName"] ?? "",
      subGroupName: json["SubGroupName"] ?? "",
      group1: json["Group1"] ?? "",
      group2: json["Group2"] ?? "",
      unit: json["Unit"] ?? "",
      altUnit: json["AltUnit"] ?? "",
      altQty: json["AltQty"] == null ? "0.0" : "${json["AltQty"]}",
      hsCode: json["HsCode"] ?? "",
      buyRate: json["BuyRate"] == null ? "0.0" : "${json["BuyRate"]}",
      salesRate: json["SalesRate"] == null ? "0.0" : "${json["SalesRate"]}",
      mrp: json["MRP"] == null ? "0.0" : "${json["MRP"]}",
      tradeRate: json["TradeRate"] == null ? "0.0" : "${json["TradeRate"]}",
      discountPercentage: json["Discount Percentage"] == null
          ? "0.0"
          : "${json["Discount Percentage"]}",
      imageName: json["Image Name"] ?? "",
    // pImage: json["PImage"] ?? ""?? AssetsList.errorBase64Image,
     pImage:  AssetsList.errorBase64Image,
      imageFolderName: json["Image Folder Name"] ?? "",
      offerDiscount:
      json["Offer Discount"] == null ? "0.0" : "${json["Offer Discount"]}",
      stockStatus: json["StockStatus"] ?? "",
      stockQty: json["StockQty"] == null ? "0.0" : "${json["StockQty"]}",
    );
  }

  Map<String, dynamic> toJson() => {
    "PCode": pCode,
    "PDesc": pDesc,
    "PShortName": pShortName,
    "GroupName": groupName,
    "SubGroupName": subGroupName,
    "Group1": group1,
    "Group2": group2,
    "Unit": unit,
    "AltUnit": altUnit,
    "AltQty": altQty,
    "HsCode": hsCode,
    "BuyRate": buyRate,
    "SalesRate": salesRate,
    "MRP": mrp,
    "TradeRate": tradeRate,
    "[Discount Percentage]": discountPercentage,
    "[PImage]": pImage,
    "[Image Name]": imageName,
    "[Image Folder Name]": imageFolderName,
    "[Offer Discount]": offerDiscount,
    "StockStatus": stockStatus,
    "StockQty": stockQty,
  };
}
