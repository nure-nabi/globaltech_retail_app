class LedgerDetails {
  LedgerDetails({
    required this.groupName,
    required this.dbName,
    required this.category,
    required this.panNo,
    required this.contactPerson,
    required this.salesRate,
    required this.customerCode,
    required this.mobileNo,
    required this.email,
    required this.customerName,
  });

  final String groupName;
  final String dbName;
  final String category;
  final String panNo;
  final String contactPerson;
  final String salesRate;
  final String customerCode;
  final String mobileNo;
  final String email;
  final String customerName;

  factory LedgerDetails.fromJson(Map<String, dynamic> json) {
    return LedgerDetails(
      groupName: json["GroupName"] ?? "",
      dbName: json["DbName"] ?? "",
      category: json["Catagory"] ?? "",
      panNo: json["PanNo"] ?? "",
      contactPerson: json["ContactPerson"] ?? "",
      salesRate: json["SalesRate"] ?? "",
      customerCode: json["CustomerCode"] ?? "",
      mobileNo: json["MobileNo"] ?? "",
      email: json["Email"] ?? "",
      customerName: json["CustomerName"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "GroupName": groupName,
        "DbName": dbName,
        "Catagory": category,
        "PanNo": panNo,
        "ContactPerson": contactPerson,
        "SalesRate": salesRate,
        "CustomerCode": customerCode,
        "MobileNo": mobileNo,
        "Email": email,
        "CustomerName": customerName,
      };
}
