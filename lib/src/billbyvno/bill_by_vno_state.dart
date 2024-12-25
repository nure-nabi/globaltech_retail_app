import 'package:flutter/material.dart';
import 'package:retail_app/src/login/model/login_model.dart';

import '../../enum/enum.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';
import '../pdf/pdf.dart';
import 'api/bill_by_vno_api.dart';
import 'model/bill_by_vno_model.dart';

class BillNoByVnoState extends ChangeNotifier {
  BillNoByVnoState();

  late bool _isLoading = false;
  bool get isLoading => _isLoading;
  set getLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  late CompanyDetailsModel companyDetailsModel;
  late List<ListDataBillModel> _dataList = [];
  List<ListDataBillModel> get dataList => _dataList;
  set getDataList(List<ListDataBillModel> value) {
    _dataList = value;
    notifyListeners();
  }

  init({required String vNo}) async {
    await clear();
    await getAPIData(vNo: vNo);
  }

  late CompanyDetailsModel _companyDetail = CompanyDetailsModel.fromJson({});
  CompanyDetailsModel get companyDetail => _companyDetail;
  set getCompanyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  clear() async {
    _isLoading = false;
    _dataList = [];
    _companyDetail = await GetAllPref.companyDetail();
  }

  late BillPrintEnum _printEnum = BillPrintEnum.none;
  BillPrintEnum get printEnum => _printEnum;
  set getPrintEnum(BillPrintEnum value) {
    _printEnum = value;
  }

  getAPIData({required String vNo}) async {
    getLoading = true;
    ListBillModel modelList = await BillByVNoAPI.billPrint(
      databaseName: _companyDetail.dbName,
      vNo: vNo,
      apiMethodName: getAPIMethodName(),
    );

    if (modelList.statusCode == 200) {
      getDataList = modelList.listDataBillModel;
      getLoading = false;
    } else {
      getDataList = [];
      getLoading = false;
    }

    notifyListeners();
  }

  getAPIMethodName() {
    switch (_printEnum) {
      case BillPrintEnum.none:
        return "ListSalesBillPrint";
      case BillPrintEnum.sales:
        return "ListSalesBillPrint";
      case BillPrintEnum.purchases:
        return "ListPurchaseBillPrint";
      case BillPrintEnum.salesReturn:
        return "ListSalesReturnBillPrint";
      case BillPrintEnum.purchasesReturn:
        return "ListPurchaseReturnBillPrint";
    }
  }

  getBillTitleName() {
    switch (_printEnum) {
      case BillPrintEnum.none:
        return "INVOICE";
      case BillPrintEnum.sales:
        return "Sales Invoice";
      case BillPrintEnum.purchases:
        return "Purchase Invoice";
      case BillPrintEnum.salesReturn:
        return "Sales Return";
      case BillPrintEnum.purchasesReturn:
        return "Purchase Return";
    }
  }

  onPrint({required String name}) async {
    double dNetAmt = 0.00;
    double dTermAMt = 0.00;
    double totalAMT = 0.00;
    for (var value in dataList) {
      dNetAmt += double.parse(value.dNetAmt);
      dTermAMt += double.parse(value.dTermAMt);
      totalAMT = dNetAmt + dTermAMt;

      final pdfFile = await PdfInvoiceApi.generate(
        companyDetails: _companyDetail,
        vNo: value.hVno,
        customer: value.hGlDesc,
        address: value.address,
        phone: value.hMobileNo,
        panNo: value.hPanNo,
        balanceAmt: value.balanceAmt,
        date: DateConverter.nepaliToEnglish(
          year: int.parse(value.hMiti.split("/").last),
          month: int.parse(value.hMiti.split("/").elementAt(1)),
          day: int.parse(value.hMiti.split("/").first),
        ).toString().substring(0, 10).replaceAll("-", "/"),
        miti: value.hMiti,
        dataList: dataList,
        totalAmount: totalAMT,
        totalNetAmount: double.parse(value.hNetAmt).toStringAsFixed(2),
        totalTermAmount: double.parse(value.hTermAMt).toStringAsFixed(2),
        billTitleName: getBillTitleName(),
      );

      ////  opening the pdf file
      FileHandleApi.openFile(pdfFile);
    }

    notifyListeners();
  }

// Future getSharePreference() async {
//   baseUrl = await SharedPref.getData("APIBaseURL", "", "String");

//   String companyData =
//       await SharedPref.getData("CompanyDetailsValue", "", "String");
//   Map<String, dynamic> companyDetail = jsonDecode(companyData);
//   CompanyDetailsModel = CompanyDetailsModel.fromJson(companyDetail);
//   databaseName = CompanyDetailsModel.dbName;

//   notifyListeners();
// }
}
