import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/services/sharepref/get_all_pref.dart';
import 'package:retail_app/src/datepicker/date_picker_state.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/pdf/ledger_pdf.dart';
import 'package:retail_app/src/pdf/purcahse_report_share.dart';

import 'package:retail_app/src/purchase_report/api/purchase_report_api.dart';
import 'package:retail_app/src/purchase_report/db/purchase_report_db.dart';
import 'package:retail_app/src/purchase_report/model/purchase_report_model.dart';
import 'package:retail_app/utils/connection_status.dart';
import 'package:retail_app/utils/custom_log.dart';

class PurchaseReportState extends ChangeNotifier {
  PurchaseReportState();

  late BuildContext _context;

  String _voucherNo = "";

  String get voucherNo => _voucherNo;

  BuildContext get context => _context;
  late NavigatorState navigator;

  set getContext(BuildContext value) {
    _context = value;
    navigator = Navigator.of(_context);

    init();
  }

  late bool _isLoading = false;

  bool get isLoading => _isLoading;

  set getLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  double totalSum = 0.0;

  String? errorMessage;
  set setVoucher(String value) {
    _voucherNo = value;
    notifyListeners();
  }

  init() async {
    await clean();
    await getPurchaseReportFromAPI();
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

  late List<PurchaseDataModel> _purchaseList = [];

  List<PurchaseDataModel> get purchaseList => _purchaseList;

  set purchaseList(List<PurchaseDataModel> value) {
    _purchaseList = value;
    notifyListeners();
  }

  late List<PurchaseDataModel> _dataList = [];

  List<PurchaseDataModel> get dataList => _dataList;

  set getDataList(List<PurchaseDataModel> value) {
    _dataList = value;
    notifyListeners();
  }

  late List<PurchaseDataModel> _customerList = [], _filterCustomerList= [];
  List<PurchaseDataModel> get customerList => _customerList;
  List<PurchaseDataModel> get filterCustomerList => _filterCustomerList;

  set getCustomerList(List<PurchaseDataModel> value) {
    _customerList = value;
    _filterCustomerList = _customerList;
    notifyListeners();
  }

  set filterCustomerList(value) {
    _filterCustomerList = _customerList
        .where((u) => (u.glDesc.toLowerCase().contains(value.toLowerCase())))
        .toList();
    notifyListeners();
  }
  set filterCustomerListScreen(value) {
    _filterCustomerList = _customerList
        .where((u) => (u.glDesc.toLowerCase().contains(value.toLowerCase())))
        .toList();
    notifyListeners();
  }
  Future<void> checkConnection() async {
    try {
      bool network = await CheckNetwork.check();
      if (network) {
        await networkSuccess();
      } else {
        debugPrint('No internet Connection');
      }
    } catch (e) {
      debugPrint('Error checking network: $e');
    }
  }

  Future<void> networkSuccess() async {
    _isLoading = true;
    getPurchaseReportFromAPI();
    _isLoading = false;
  }

  Future<void> getPurchaseReportFromAPI() async {
    getLoading = true;
    PurchaseModel model = await PurchaseReportAPI.apiCall(
      databaseName: _companyDetail.dbName,
      unitCode: await GetAllPref.unitCode(),
    );

    if (model.statusCode == 200) {
      //  getDataList = model.data;
      await onSuccess(dataModel: model.data);
      getLoading = false;
    } else {
      getLoading = false;
    }
    notifyListeners();
  }

  Future<List<PurchaseDataModel>> getPurchaseAmountFromAPI() async {
    PurchaseModel model = await PurchaseReportAPI.apiCall(
      databaseName: _companyDetail.dbName,
      unitCode: await GetAllPref.unitCode(),
    );

    if (model.statusCode == 200) {
      return model.data;
      getLoading = false;
    } else {
      return [];
    }
    notifyListeners();
  }

  onSuccess({required List<PurchaseDataModel> dataModel}) async {
    await PurchaseReportDbDatabase.instance.deleteData();

    for (var element in dataModel) {
      await PurchaseReportDbDatabase.instance.insertData(element);
    }

    await getLedgerDateWiseFromDB(fromDate,toDate);
    notifyListeners();
  }
  onDatePickerConfirm() async {
    getDataList = [];
    getFromDate = Provider.of<DatePickerState>(context, listen: false).fromDate;
    getToDate = Provider.of<DatePickerState>(context, listen: false).toDate;
    // await getDataFromDatabase().whenComplete(() {
    //   Navigator.pop(context);
    // });
    notifyListeners();
  }
  String toDate = "";
  String fromDate = "";
  set getFromDate(String value) {
    fromDate = value.replaceAll("/", "-");
    notifyListeners();
  }

  set getToDate(String value) {
    toDate = value.replaceAll("/", "-");
    notifyListeners();
  }

  double _totalAmount = 0.0;
  double get totalAmount => _totalAmount;

  set getTotalAmount(double totalAmt){
    _totalAmount = totalAmt;
  }

  getLedgerDateWiseFromDB( String fromDated, String toDated,) async {
    await PurchaseReportDbDatabase.instance.getDateWiseList(fromDate: fromDate, toDate: toDate).then((value) {
      getDataList = value;
      getCustomerList = value;
      toDate="";
      fromDate="";

    });
    await getPurchaseTotalFromDB();
    await calculate();
    notifyListeners();
  }

  calculate(){
    double totalAmount = 0.0;
    for(int i = 0; i<filterCustomerList.length; i++){
      totalAmount += filterCustomerList[i].netAmt;
    }
    getTotalAmount = totalAmount;
    notifyListeners();
  }

  Future<void> getPurchaseTotalFromDB() async {
    try {
      totalSum = await PurchaseReportDbDatabase.instance.totalPurchaseSum();
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to fetch data';
      debugPrint('Error fetching data: $e');
    } finally {
      notifyListeners();
    }
  }
  shareLedger() async {
    CustomLog.log(value: _companyDetail.ledgerCode);
    await generatePurchaseInvoiceShare(
      companyDataDetails: _companyDetail,
      purchaseReportList: _dataList,
      vNo: '',
      vDate: '',
      vMiti: '',
      glDesc: '',
      netAmt: '',
    );
  }

}