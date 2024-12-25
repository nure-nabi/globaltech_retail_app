class ProductMasterModel {
  ProductMasterModel({
    required this.groupName,
    required this.dbName,
    required this.subGroupName,
    required this.productUnit,
    required this.productAltUnit,
    required this.salesRate,
    required this.purchaseRate,
    required this.productCode,
    required this.productName,
  });

  final String groupName;
  final String dbName;
  final String subGroupName;
  final String productUnit;
  final String productAltUnit;
  final String salesRate;
  final String purchaseRate;
  final String productCode;
  final String productName;

  factory ProductMasterModel.fromJson(Map<String, dynamic> json) {
    final objLedgerDetails = json['objLedgerDetails'][0];
    return ProductMasterModel(
      groupName: objLedgerDetails['GroupName'] ?? "",
      dbName: objLedgerDetails['DbName'] ?? "",
      subGroupName: objLedgerDetails['SubGroupName'] ?? "",
      productUnit: objLedgerDetails['ProductUnit'] ?? "",
      productAltUnit: objLedgerDetails['ProductAltUnit'] ?? "",
      salesRate: objLedgerDetails['SalesRate'] ?? "",
      purchaseRate: objLedgerDetails['PurchaseRate'] ?? "",
     // purchaseRate: objLedgerDetails["PurchaseRate"] == "" ? "0.0" : "${objLedgerDetails["PurchaseRate"]}",
     // purchaseRate: son["BuyRate"] == null ? "0.0" : "${json["BuyRate"]}",
      productCode: objLedgerDetails['ProductCode'] ?? "",
      productName: objLedgerDetails['ProductName'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "GroupName": groupName,
    "DbName": dbName,
    "SubGroupName": subGroupName,
    "ProductUnit": productUnit,
    "ProductAltUnit": productAltUnit,
    "SalesRate": salesRate,
    "PurchaseRate": purchaseRate,
    "ProductCode": productCode,
    "ProductName": productName,
  };
}