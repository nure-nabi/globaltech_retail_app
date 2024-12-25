class ListBillModel {
  ListBillModel({
    required this.message,
    required this.statusCode,
    required this.listDataBillModel,
  });

  late final String message;
  late final int statusCode;
  late final List<ListDataBillModel> listDataBillModel;

  ListBillModel.fromJson(Map<String, dynamic> json) {
    message = json['MESSAGE'];
    statusCode = json['STATUS_CODE'];
    listDataBillModel = List.from(json['data'] ?? [])
        .map((e) => ListDataBillModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['MESSAGE'] = message;
    data['STATUS_CODE'] = statusCode;
    data['data'] = listDataBillModel.map((e) => e.toJson()).toList();
    return data;
  }
}

class ListDataBillModel {
  ListDataBillModel({
    required this.hVno,
    required this.hDate,
    required this.hMiti,
    required this.hGlDesc,
    required this.hGlCode,
    required this.hPanNo,
    required this.hMobileNo,
    required this.hAgent,
    required this.dSno,
    required this.dPDesc,
    required this.dQty,
    required this.unitCode,
    required this.address,
    required this.dLocalRate,
    required this.dBasicAmt,
    required this.dTermAMt,
    required this.dNetAmt,
    required this.hTermAMt,
    required this.hNetAmt,
    required this.balanceAmt,
  });

  late final String hVno;
  late final String hDate;
  late final String hMiti;
  late final String hGlDesc;
  late final String hGlCode;
  late final String hPanNo;
  late final String hMobileNo;
  late final String hAgent;
  late final String dSno;
  late final String dPDesc;
  late final String dQty;
  late final String unitCode;
  late final String address;
  late final String dLocalRate;
  late final String dBasicAmt;
  late final String dTermAMt;
  late final String dNetAmt;
  late final String hTermAMt;
  late final String hNetAmt;
  late final String balanceAmt;

  ListDataBillModel.fromJson(Map<String, dynamic> json) {
    hVno = json['HVno'] ?? "-";
    hDate = json['HDate'] ?? "-";
    hMiti = json['HMiti'] ?? "-";
    hGlDesc = json['HGlDesc'] ?? "-";
    hGlCode = json['HGlCode'] ?? "-";
    hPanNo = json['HPanNo'] ?? "-";
    hMobileNo = json['HMobileNo'] ?? "-";
    hAgent = json['HAgent'] ?? "-";
    dSno = json['DSno'] == null
        ? "0"
        : int.parse(json['DSno'].toString()).toString();
    dPDesc = json['DPDesc'] ?? "-";

    dQty = json['DQty'] == null
        ? "0.00"
        : double.parse(json['DQty'].toString()).toStringAsFixed(2);
    unitCode = json['UnitCode'] ?? "-";
    address = json['Address'] ?? "-";

    dLocalRate = json['DLocalRate'] == null
        ? "0.00"
        : double.parse(json['DLocalRate'].toString()).toStringAsFixed(2);
    dBasicAmt = json['DBasicAmt'] == null
        ? "0.00"
        : double.parse(json['DBasicAmt'].toString()).toStringAsFixed(2);
    dTermAMt = json['DTermAMt'] == null
        ? "0.00"
        : double.parse(json['DTermAMt'].toString()).toStringAsFixed(2);
    dNetAmt = json['DNetAmt'] == null
        ? "0.00"
        : double.parse(json['DNetAmt'].toString()).toStringAsFixed(2);
    hTermAMt = json['HTermAMt'] == null
        ? "0.00"
        : double.parse(json['HTermAMt'].toString()).toStringAsFixed(2);
    hNetAmt = json['HNetAmt'] == null
        ? "0.00"
        : double.parse(json['HNetAmt'].toString()).toStringAsFixed(2);
    balanceAmt = json['BalanceAmt'] == null
        ? "0.00"
        : double.parse(json['BalanceAmt'].toString()).toStringAsFixed(2);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['HVno'] = hVno;
    data['HDate'] = hDate;
    data['HMiti'] = hMiti;
    data['HGlDesc'] = hGlDesc;
    data['HGlCode'] = hGlCode;
    data['HPanNo'] = hPanNo;
    data['HMobileNo'] = hMobileNo;
    data['HAgent'] = hAgent;
    data['DSno'] = dSno;
    data['DPDesc'] = dPDesc;
    data['DQty'] = dQty;
    data['UnitCode'] = unitCode;
    data['Address'] = address;
    data['DLocalRate'] = dLocalRate;
    data['DBasicAmt'] = dBasicAmt;
    data['DTermAMt'] = dTermAMt;
    data['DNetAmt'] = dNetAmt;
    data['HTermAMt'] = hTermAMt;
    data['HNetAmt'] = hNetAmt;
    data['BalanceAmt'] = balanceAmt;
    return data;
  }

  /// For PDF
  String getIndex(int index) {
    switch (index) {
      case 0:
        return dSno;
      case 1:
        return dPDesc;
      case 2:
        return dQty;
      case 3:
        return unitCode;
      case 4:
        return dLocalRate;
      case 5:
        return dTermAMt;
      case 6:
        return dNetAmt;
    }
    return '';
  }
}
