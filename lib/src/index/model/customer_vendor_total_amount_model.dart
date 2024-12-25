class CustomerVendorAmountModel {
  final int statusCode;
  final bool status;
  final List<CustomerVendorAmountDataModel> data;

  CustomerVendorAmountModel({
    required this.statusCode,
    required this.status,
    required this.data,
  });

  factory CustomerVendorAmountModel.fromJson(Map<String, dynamic> json) {
    return CustomerVendorAmountModel(
      statusCode: json["status_code"] ?? 0,
      status: json["status"] ?? false,
      data: json["data"] != null
          ? List<CustomerVendorAmountDataModel>.from(
          json["data"].map((x) => CustomerVendorAmountDataModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status_code": statusCode,
      "status": status,
      "data": data.map((x) => x.toJson()).toList(),
    };
  }
}

class CustomerVendorAmountDataModel {
  final String category;
  final double amount;

  CustomerVendorAmountDataModel({
    required this.category,
    required this.amount,
  });

  factory CustomerVendorAmountDataModel.fromJson(Map<String, dynamic> json) {
    return CustomerVendorAmountDataModel(
      category: json["Catagory"] ?? "",
      amount: json["Amount"] != null ? json["Amount"].toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Catagory": category,
      "Amount": amount,
    };
  }
}