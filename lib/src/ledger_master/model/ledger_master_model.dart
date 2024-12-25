class LedgerMasterModel {
  LedgerMasterModel({
    required this.longitude,
    required this.outletName,
    required this.panNo,
    required this.tag,
    required this.phoneNo,
    required this.route,
    required this.agentCode,
    required this.address,
    required this.mobileNo,
    required this.email,
    required this.latitude,
    required this.outletCode,
    required this.contactPerson,
    required this.priceTag,
    required this.dbName,
    required this.catagory,
    required this.grpCode,
  });

  final String? longitude;
  final String outletName;
  final String panNo;
  final String tag;
  final String phoneNo;
  final String? route;
  final String? agentCode;
  final String address;
  final String mobileNo;
  final String email;
  final String? latitude;
  final String? outletCode;
  final String contactPerson;
  final String priceTag;
  final String dbName;
  final String catagory;
  final String grpCode;

  factory LedgerMasterModel.fromJson(Map<String, dynamic> json) {
    return LedgerMasterModel(
      longitude: json["Longitude"],
      outletName: json["OutletName"] ?? "",
      panNo: json["PanNo"] ?? "",
      tag: json["Tag"] ?? "",
      phoneNo: json["PhoneNo"] ?? "",
      route: json["Route"],
      agentCode: json["AgentCode"],
      address: json["Address"] ?? "",
      mobileNo: json["MobileNo"] ?? "",
      email: json["Email"] ?? "",
      latitude: json["Latitude"],
      outletCode: json["OutletCode"],
      contactPerson: json["ContactPerson"] ?? "",
      priceTag: json["PriceTag"] ?? "",
      dbName: json["DbName"] ?? "",
      catagory: json["Catagory"] ?? "",
      grpCode: json["GrpCode"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "Longitude": longitude,
    "OutletName": outletName,
    "PanNo": panNo,
    "Tag": tag,
    "PhoneNo": phoneNo,
    "Route": route,
    "AgentCode": agentCode,
    "Address": address,
    "MobileNo": mobileNo,
    "Email": email,
    "Latitude": latitude,
    "OutletCode": outletCode,
    "ContactPerson": contactPerson,
    "PriceTag": priceTag,
    "DbName": dbName,
    "Catagory": catagory,
    "GrpCode": grpCode,
  };
}
