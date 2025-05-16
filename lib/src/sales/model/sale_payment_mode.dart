class SalePaymentResModel{
 String? MESSAGE;
 int? STATUS_CODE;

 List<SalePaymentModel> data;

 SalePaymentResModel({required this.MESSAGE,required this.STATUS_CODE,required this.data});

 factory SalePaymentResModel.fromJson(Map<String, dynamic> json){
  return SalePaymentResModel(
      MESSAGE: json["MESSAGE"] ?? "",
      STATUS_CODE: json["STATUS_CODE"] ?? 0,
      data: json["data"] == null ? [] : List<SalePaymentModel>.from(
       json["data"].map((x) => SalePaymentModel.fromJson(x)),
      )
      );
 }
}

class SalePaymentModel{
 String? paymentMode;
 String? glcode;

 SalePaymentModel({required this.paymentMode,required this.glcode});

 factory SalePaymentModel.fromJson(Map<String, dynamic> json){
  return SalePaymentModel(
      paymentMode: json["PaymentMode"] ?? "",
      glcode: json["Glcode"] ?? "");
 }
}