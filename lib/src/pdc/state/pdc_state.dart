import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/sharepref/get_all_pref.dart';
import '../../login/model/login_model.dart';
import '../../pdf/bill_pdf.dart';
import '../../pdf/pdc_pdf.dart';
import '../../products/products.dart';
import '../../purchase/vendor_state.dart';
import '../api/pdc_api.dart';
import '../model/pdc_model.dart';
import '../model/pdf_bounce_cheque_model.dart';
import '../model/pdf_print_model.dart';

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

  late bool _isCustomerFilter = false;
  bool get isCustomerFilter => _isCustomerFilter;
  set getCustomerFilter(bool value) {
    _isCustomerFilter = value;
    notifyListeners();
  }

  late ProductState productState;

  getOutletInfoState() {
    productState = Provider.of<ProductState>(context, listen: false);
  }

  init() async {

    await clear();
    await  ledger();
    await getOutletInfoState();


    await Future.wait([
      getPDCReportListFromAPI(),
      getPDCBounceListFromAPI(),

    ]);
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

    _bounceList = [];
    _dataList = [];
  }

  late List<PDCReportDataModel> _dataList = [], _filterDataList = [];

  List<PDCReportDataModel> get dataList => _dataList;

  List<PDCReportDataModel> get filterDataList => _filterDataList;

  set getDataList(List<PDCReportDataModel> value) {
    _dataList = value;
    _filterDataList = _dataList;
    searchListData = "Due";
    notifyListeners();
  }

  set searchListData(value) {
    debugPrint("TYPE VALUE => $value");
    if (value.toString().toUpperCase() != "ALL") {
      _filterDataList = _dataList
          .where((u) => (u.bankName.toLowerCase() == value.toString().toLowerCase()))
          .toList();
    } else {
      _filterDataList = _dataList;
    }
    notifyListeners();
  }

  Future getPDCReportListFromAPI() async {
    getLoading = true;
    PDCReportModel reportModel = await PDCReportAPI.apiCall(
      databaseName: _companyDetail.dbName,
      glCode: ledgerState.selectedGlCode!.isNotEmpty ? ledgerState.selectedGlCode! : "",
      agentCode: "",
      // agentCode: "4",
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

 late LedgerState ledgerState;
 Future ledger()async{
    ledgerState =  Provider.of<LedgerState>(context,listen: false);
  }
  Future getPDCBounceListFromAPI() async {
    getLoading = true;
    PdcBounceModel reportModel = await PDCReportAPI.apiCallfromBounceList(
      databaseName: _companyDetail.dbName,
      glCode: ledgerState.selectedGlCode!.isNotEmpty? ledgerState.selectedGlCode! :"",
      agentCode: "",
      // agentCode: "",
    );

    if (reportModel.statusCode == 200) {
      bounceList = reportModel.data;
      getLoading = false;
    } else {
      getLoading = false;
    }
    notifyListeners();
  }

  late List<PdcBounceDataModel> _bounceList = [];
  List<PdcBounceDataModel> get bounceList => _bounceList;
  set bounceList(List<PdcBounceDataModel> value) {
    _bounceList = value;

    notifyListeners();
  }

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
        receivedBy: await GetAllPref.userName(),
        branchName: '',
      );

      ////  opening the pdf file
      FileHandleApi.openFile(pdfFile);
    }

    notifyListeners();
  }
}
