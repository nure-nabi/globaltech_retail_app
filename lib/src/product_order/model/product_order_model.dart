
class ProductOrderModel {
  ProductOrderModel({
    required this.id,
    required this.productCode,
    required this.productName,
    required this.quantity,
    required this.rate,
    required this.productDescription,
    required this.total,
    required this.images,
    this.orderId,
  });

  final String id;
  final String productCode;
  final String productName;
  final String quantity;
  final String rate;
  final String productDescription;
  final String total;
  final String images;
  final String? orderId;

  factory ProductOrderModel.fromJson(Map<String, dynamic> json) {
    return ProductOrderModel(
      id: json["Id"] ?? "",
      productCode: json["ProductCode"] ?? "",
      productName: json["ProductName"] ?? "",
      quantity: json["Quantity"] ?? "",
      rate: json["Rate"] ?? "",
      productDescription: json["ProductDescription"] ?? "",
      total: json["Total"] ?? "",
      images: json["Images"] ?? "",

      orderId: json["OrderId"] != null ? json["OrderId"].toString() // Convert status to String
          : "0",
    );
  }

  Map<String, dynamic> toJson() => {
    "OrderId": orderId,
    "Id": id,
    "ProductCode": productCode,
    "ProductName": productName,
    "Quantity": quantity,
    "Rate": rate,
    "ProductDescription": productDescription,
    "Total": total,
    "Images": images,
  };
  //for pdf
  String getIndex(int index, bool showEnglishDate) {
    switch (index) {
      case 0:
        return productDescription;
      case 1:
        return images;
      case 2:
        return quantity;
      case 3:
        return rate;
      case 4:
        return total;
    }
    return '';
  }
}