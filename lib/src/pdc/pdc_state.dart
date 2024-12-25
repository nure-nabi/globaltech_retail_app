import 'package:flutter/material.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import '../../services/services.dart';
import '../pdf/pdf.dart';
import 'api/pdc_api.dart';
import 'model/pdc_model.dart';
import 'model/pdf_print_model.dart';

class PDCState extends ChangeNotifier {
  PDCState();

  late BuildContext _context;

  BuildContext get context => _context;

  set getContext(BuildContext value) {
    _context = value;

    ///
    init();
  }

  late bool _isLoading = false;

  bool get isLoading => _isLoading;

  set getLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // late ProductState productState;

  // getOutletInfoState() {
  //   productState = Provider.of<ProductState>(context, listen: false);
  // }

  init() async {
    await clear();
    // await getOutletInfoState();
    await getPDCReportListFromAPI();
  }

  late CompanyDetailsModel _companyDetail = CompanyDetailsModel.fromJson({});

  CompanyDetailsModel get companyDetail => _companyDetail;

  set getCompanyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  clear() async {
    _isLoading = false;
    _companyDetail = await GetAllPref.companyDetail();
    Future.delayed(const Duration(seconds: 0), () {
      searchListData = "Deu";
    });
  }

  late List<PDCReportDataModel> _dataList = [], _filterDataList = [];

  List<PDCReportDataModel> get dataList => _dataList;

  List<PDCReportDataModel> get filterDataList => _filterDataList;

  set getDataList(List<PDCReportDataModel> value) {
    _dataList = value;
    _filterDataList = _dataList;
    notifyListeners();
  }

  set searchListData(value) {
    if (value.toString().toUpperCase() != "ALL") {
      _filterDataList = _dataList
          .where((u) =>
      (u.depositType.toLowerCase() == value.toString().toLowerCase()))
          .toList();
    } else {
      _filterDataList = _dataList;
    }
    notifyListeners();
  }

  getPDCReportListFromAPI() async {
    getLoading = true;
    PDCReportModel reportModel = await PDCReportAPI.apiCall(
      databaseName: _companyDetail.dbName,
      // glCode: productState.outletDetail.glCode,
      glCode: _companyDetail.ledgerCode,
    );

    if (reportModel.statusCode == 200) {
      getDataList = reportModel.data;
      getLoading = false;
    } else {
      getLoading = false;
    }
    notifyListeners();
  }

  final filterTypeList = ["All", "Deposit", "Due", "Cancel"];

  /// ***************************************
  /// ***************************************
  /// ***************************************

  late List<PDCPrintDataModel> _pdfDataList = [];

  List<PDCPrintDataModel> get pdfDataList => _pdfDataList;

  set getPDFDataList(List<PDCPrintDataModel> value) {
    _pdfDataList = [];
    _pdfDataList = value;
    notifyListeners();
  }

  getPDCReportPrintFromAPI({required String vNo, required String name}) async {
    getLoading = true;
    _companyDetail = await GetAllPref.companyDetail();

    _pdfDataList.clear();
    PdcPrintModel reportModel = await PDCReportAPI.pdcPrint(
      databaseName: _companyDetail.dbName,
      vNo: vNo,
    );

    if (reportModel.statusCode == 200) {
      getPDFDataList = reportModel.data;
      getLoading = false;
      await onPrint(name: name);
    } else {
      getLoading = false;
    }
    notifyListeners();
  }

  onPrint({required String name}) async {
    for (var value in _pdfDataList) {
      final pdfFile = await PDCPdfInvoiceApi.generate(
        companyDetails: _companyDetail,
        billTitleName: "PDC Report",
        receivedNo: value.vno,
        date: value.vMiti,
        bankName: value.bankName,
        chequeNo: value.chequeNo,
        chequeDate: value.chMiti,
        receivedFrom: value.gldesc,
        receivedAmount: "${value.amount}",
        remarks: value.remarks,
        // receivedBy: _companyDetail.loginName,
        receivedBy: _companyDetail.phoneNo,
      );

      ////  opening the pdf file
      FileHandleApi.openFile(pdfFile);
    }

    notifyListeners();
  }
}
