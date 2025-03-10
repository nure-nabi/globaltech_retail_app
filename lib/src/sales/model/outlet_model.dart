class OutletModel {
  OutletModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  final String message;
  final int statusCode;
  final List<OutletDataModel> data;

  factory OutletModel.fromJson(Map<String, dynamic> json) {
    return OutletModel(
      message: json["message"] ?? "",
      statusCode: json["status_code"] ?? 0,
      data: json["data"] == null ? [] : List<OutletDataModel>.from(
        json["data"].map((x) => OutletDataModel.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class OutletDataModel {
  OutletDataModel({
    required this.glCode,
    required this.glDesc,
    required this.glCatagory,
    required this.mobile,
    required this.address,
    required this.panno,
  });

  final String glCode;
  final String glDesc;
  final String glCatagory;
  final String mobile;
  final String address;
  final String panno;

  factory OutletDataModel.fromJson(Map<String, dynamic> json) {
    return OutletDataModel(
      glCode: json["GlCode"] ?? "",
      glDesc: json["GlDesc"] ?? "",
      glCatagory: json["GlCatagory"] ?? "",
      mobile: json["MobileNo"] ?? "",
      address: json["Address"] ?? "",
      panno: json["Panno"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "GlCode": glCode,
    "GlDesc": glDesc,
    "GlCatagory": glCatagory,
    "MobileNo": mobile,
    "Address": address,
    "Panno": panno,
  };
}
