import 'package:flutter/widgets.dart';
import 'package:retail_app/services/services.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/pdf/sales_bill_pdf.dart';
import 'package:retail_app/src/sales_bill_report/model/sales_bill_report_model.dart';
import 'package:retail_app/src/vendor_bill_report_details/api/vendor_bill_report_details_api.dart';
import 'package:retail_app/utils/date_formater.dart';

class VendorPartyBillDetailsState extends ChangeNotifier {
  VendorPartyBillDetailsState();

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
    await getPurchaseBillReportFromAPI(vNo: vNo);
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

  late List<SalesBillReportDataModel> _dataList = [];

  List<SalesBillReportDataModel> get dataList => _dataList;

  set getDataList(List<SalesBillReportDataModel> value) {
    _dataList = value;
    notifyListeners();
  }

  getPurchaseBillReportFromAPI({required String vNo}) async {
    getLoading = true;
    SalesBillReportModel model = await VendorPartyBillDetailsApi.apiCall(
        databaseName: _companyDetail.dbName,
        vNo: vNo,
        unit: await GetAllPref.unitCode());

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

  set gethTermAmt(double hTerm) {
    _hTermAmount = hTerm;
    notifyListeners();
  }

  set getHnetAmt(double hNet) {
    _hNetAmount = hNet;
    notifyListeners();
  }

  set getBasicAmt(double hNet) {
    _hBasicAmount = hNet;
    notifyListeners();
  }

  calculate() {
    double hTetmAmt = 0.0;
    double hNetAmt = 0.0;
    double hBasicAmt = 0.0;
    for (int i = 0; i < dataList.length; ++i) {
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
    int i = 1;
    for (var value in dataList) {
      dNetAmt += double.parse(value.dNetAmt);
      dTermAMt += double.parse(value.dTermAMt);
      totalAMT = dNetAmt + dTermAMt;

      final pdfFile = await PdfInvoiceApiSales.generate(
        companyDetails: _companyDetail,
        vNo: value.hvno,
        customer: value.hGlDesc,
        address: value.address,
        phone: value.hMobileNo,
        panNo: value.hPanNo,
        dpDesc: value.dpDesc,
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
        billTitleName: 'Purchase Invoice',
      );

      ////  opening the pdf file
      FileHandleApiSales.openFile(pdfFile);
    }

    notifyListeners();
  }


}