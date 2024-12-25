import 'package:flutter/material.dart';
import 'package:retail_app/services/sharepref/get_all_pref.dart';
import 'package:retail_app/src/bill_report/api/bill_report_api.dart';
import 'package:retail_app/src/bill_report/model/bill_report_model.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/pdf/purchase_bill_pdf.dart';
import 'package:retail_app/utils/date_formater.dart';

class BillReportState extends ChangeNotifier {
  BillReportState();

  var value;
  late BuildContext _context;



  BuildContext get context => _context;
  late NavigatorState navigator;

  set getContext(BuildContext value) {
    _context = value;
    navigator = Navigator.of(_context);


  }

  late bool _isLoading = false;
  bool get isLoading => _isLoading;
  set getLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  init({required String vNo}) async {
    await clean();
    await getPurchaseReportFromAPI(vNo: vNo);
    _companyDetail = await GetAllPref.companyDetail();
  }

  clean() async {
    _isLoading = false;
    _companyDetail = await GetAllPref.companyDetail();
  }

  late CompanyDetailsModel _companyDetail = CompanyDetailsModel.fromJson({});
  CompanyDetailsModel get companyDetail => _companyDetail;
  set companyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }




  late List<PurchaseReportDataModel> _dataList = [];
  List<PurchaseReportDataModel> get dataList => _dataList;
  set getDataList(List<PurchaseReportDataModel> value) {
    _dataList = value;
    notifyListeners();
  }




  getPurchaseReportFromAPI({required String vNo}) async {
    getLoading = true;
    PurchaseReportModel model = await PurchaseReportApi.apiCall(
      databaseName:_companyDetail.dbName,
      vNo:vNo,
        unit: await GetAllPref.unitCode()
    );

    if (model.statusCode == 200) {
      getDataList = model.data;
      getLoading = false;
    } else {
      getLoading = false;
    }
    calculate();
    notifyListeners();
  }

  double _hTermAmount = 0.0;
  double get hTermAmount => _hTermAmount;
  double _hNetAmount = 0.0;
  double get hNetAmount => _hNetAmount;
  double _hBasicAmount = 0.0;
  double get hBasicAmount => _hBasicAmount;

  set gethTermAmt(double hTerm){
    _hTermAmount = hTerm;
    notifyListeners();
  }
  set getHnetAmt(double hNet){
    _hNetAmount = hNet;
    notifyListeners();
  }

  set getBasicAmt(double hNet){
    _hBasicAmount = hNet;
    notifyListeners();
  }

  calculate(){
    double hTetmAmt = 0.0;
    double hNetAmt = 0.0;
    double hBasicAmt = 0.0;
    for(int i =0; i<dataList.length;++i){
      hTetmAmt = double.parse(dataList[i].hTermAMt);
      hNetAmt = double.parse(dataList[i].hNetAmt);
      hBasicAmt = double.parse(dataList[i].hBasicAMt);
    }
    gethTermAmt = hTetmAmt;
    getHnetAmt = hNetAmt;
    getBasicAmt = hBasicAmt;
    notifyListeners();
  }

  onPrint({required String name}) async {
    double dNetAmt = 0.00;
    double dTermAMt = 0.00;
    double totalAMT = 0.00;
    int i=1;
    for (var value in dataList) {
      dNetAmt += double.parse(value.dNetAmt);
      dTermAMt += double.parse(value.dTermAMt);
      totalAMT = dNetAmt + dTermAMt;

      final pdfFile = await PdfInvoiceApiPurchase.generate(
        companyDetails: _companyDetail,
        vNo: value.hvno,
        customer: value.hGlDesc,
        address: value.address,
        phone: value.hMobileNo,
        panNo: value.hPanNo,
        balanceAmt: value.balanceAmt,
        dpDesc: value.dpDesc,
        date: DateConverter.nepaliToEnglish(
          year: int.parse(value.hMiti.split("/").last),
          month: int.parse(value.hMiti.split("/").elementAt(1)),
          day: int.parse(value.hMiti.split("/").first),
        ).toString().substring(0, 10).replaceAll("-", "/"),
        miti: value.hMiti,
        dataList: dataList,
        totalAmount: totalAMT,
        totalNetAmount: double.parse(value.hNetAmt).toStringAsFixed(2),
        totalTermAmount: double.parse(value.hTermAMt).toStringAsFixed(2), billTitleName: 'Purchase Invoice',

      );

      FileHandleApiPurchase.openFile(pdfFile);
    }

    notifyListeners();
  }
}