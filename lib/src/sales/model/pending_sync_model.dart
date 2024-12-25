class ProductPendingSync {
  ProductPendingSync({
    required this.productCode,
    required this.outletDesc,
    required this.alias,
    required this.rate,
    required this.quantity,
    required this.totalAmount,
  });

  final String productCode;
  final String outletDesc;
  final String alias;
  final String quantity;
  final String rate;
  final String totalAmount;

  factory ProductPendingSync.fromJson(Map<String, dynamic> json) {
    return ProductPendingSync(
      productCode: json["PCode"] ?? "",
      outletDesc: json["outlet_desc"] ?? "",
      alias: json["Alias"] ?? "",
      quantity: json["Qty"] ?? "",
      rate: json["Rate"] ?? "",
      totalAmount: json["TotalAmt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "PCode": productCode,
    "outlet_desc": outletDesc,
    "Alias": alias,
    "Qty": quantity,
    "Rate": rate,
    "TotalAmt": totalAmount,
  };
}
