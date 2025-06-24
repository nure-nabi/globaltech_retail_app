class GodownResModel{
 String? MESSAGE;
 int? STATUS_CODE;

 List<GodownModel> data;

 GodownResModel({required this.MESSAGE,required this.STATUS_CODE,required this.data});

 factory GodownResModel.fromJson(Map<String, dynamic> json){
  return GodownResModel(
      MESSAGE: json["MESSAGE"] ?? "",
      STATUS_CODE: json["STATUS_CODE"] ?? 0,
      data: json["data"] == null ? [] : List<GodownModel>.from(
       json["data"].map((x) => GodownModel.fromJson(x)),
      )
      );
 }
}



class GodownModel{
 String? godownCode;
 String? godownDesc;
 String? godownShortName;

 GodownModel({required this.godownCode,required this.godownDesc,required this.godownShortName});

 factory GodownModel.fromJson(Map<String, dynamic> json){
  return GodownModel(
      godownCode: json["GodownCode"] ?? "",
      godownDesc: json["GodownDesc"] ?? "",
      godownShortName: json["GodownShortName"] ?? ""
  );
 }
}