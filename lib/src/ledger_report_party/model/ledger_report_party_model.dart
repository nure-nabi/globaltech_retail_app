class CustomerModel {
  CustomerModel({
    required this.statusCode,
    required this.status,
    required this.data,
  });

  final int statusCode;
  final bool status;
  final List<CustomerDataModel> data;

  factory CustomerModel.fromJson(Map<String, dynamic> json, String category) {
    return CustomerModel(
      statusCode: json["status_code"] ?? 0,
      status: json["status"] ?? false,
      data: json["data"] == null
          ? []
          : List<CustomerDataModel>.from(json["data"].map(
            (x) => CustomerDataModel.fromJson(x, category),
      )),
    );
  }

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CustomerDataModel {
  CustomerDataModel({
    required this.catagory,
    required this.glDesc,
    required this.glCode,
    required this.accountGroup,
    required this.accountSubGroup,
    required this.glShortName,
    required this.amount,
    required this.address,
    required this.mobileNo,
    required this.panNo,
  });

  final String catagory;
  final String glDesc;
  final String glCode;
  final String accountGroup;
  final String accountSubGroup;
  final String glShortName;
  final String amount;
  final String address;
  final String mobileNo;
  final String panNo;

  factory CustomerDataModel.fromJson(
      Map<String, dynamic> json,
      String category,
      ) {
    return CustomerDataModel(
      catagory: category,
      glDesc: json["GlDesc"] ?? "",
      glCode: json["GlCode"] ?? "",
      accountGroup: json["AccountGroup"] ?? "",
      accountSubGroup: json["AccountSubGroup"] ?? "",
      glShortName: json["Glshortname"] ?? "",
      amount: json["Amount"] == null ? "0.00" : json["Amount"].toString(),
      address: json["Address"] ?? "",
      mobileNo: json["MobileNo"] ?? "",
      panNo: json["PanNo"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "Catagory": catagory,
    "GlDesc": glDesc,
    "GlCode": glCode,
    "AccountGroup": accountGroup,
    "AccountSubGroup": accountSubGroup,
    "Glshortname": glShortName,
    "Amount": amount,
    "Address": address,
    "MobileNo": mobileNo,
    "PanNo": panNo,
  };
}