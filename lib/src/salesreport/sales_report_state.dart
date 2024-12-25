import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/services/sharepref/get_all_pref.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/pdf/sales_report_share.dart';
import 'package:retail_app/src/salesreport/api/sales_report_api.dart';
import 'package:retail_app/src/salesreport/db/sales_report_db.dart';
import 'package:retail_app/src/salesreport/model/sales_report_model.dart';
import 'package:retail_app/utils/connection_status.dart';
import 'package:retail_app/utils/custom_log.dart';

import '../datepicker/date_picker_state.dart';

class SalesReportState extends ChangeNotifier {
  SalesReportState();

  late BuildContext _context;

  String _billNo = "";

  String get billNo => _billNo;

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

  set setBillNo(String value) {
    _billNo = value;
    notifyListeners();
  }

  init() async {
   // await clean();
    await checkConnection();
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

  late List<SalesDataModel> _dataList = [];

  List<SalesDataModel> get dataList => _dataList;

  set getDataList(List<SalesDataModel> value) {
    _dataList = value;
    notifyListeners();
  }

  late List<SalesDataModel> _customerList = [], _filterCustomerList= [];
  List<SalesDataModel> get customerList => _customerList;
  List<SalesDataModel> get filterCustomerList => _filterCustomerList;

  set getCustomerList(List<SalesDataModel> value) {
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

  Future<void> checkConnection() async {
    try {
      bool network = await CheckNetwork.check();
      if (network) {
        await networkSuccess();
      } else {
        await getLedgerDateWiseFromDB(fromDate,toDate);
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
    SalesModel model = await SalesReportApi.apiCall(
      databaseName: _companyDetail.dbName,
      unitCode: await GetAllPref.unitCode(),
    );

    if (model.statusCode == 200) {
     // getDataList = model.data;
      await onSuccess(dataModel: model.data);
      getLoading = false;
    } else {
      getLoading = false;
    }
    notifyListeners();
  }

  Future<List<SalesDataModel>> getSalesFromAPI() async {
    //getLoading = true;
    SalesModel model = await SalesReportApi.apiCall(
      databaseName: _companyDetail.dbName,
      unitCode: await GetAllPref.unitCode(),
    );

    if (model.statusCode == 200) {
    //  getLoading = false;
     return  model.data;

    } else {
     return [];
    }
    notifyListeners();
  }

  onSuccess({required List<SalesDataModel> dataModel}) async {
    await SalesReportDbDatabase.instance.deleteData();

    for (var element in dataModel) {
      await SalesReportDbDatabase.instance.insertData(element);
    }
    await getLedgerDateWiseFromDB(fromDate,toDate);
    notifyListeners();
  }

  getCustomerListFromDB() async {
    await SalesReportDbDatabase.instance.getAllSalesReportData().then((value) {
      getCustomerList = value;
    });
    notifyListeners();
  }

  getLedgerDateWiseFromDB( String fromDated, String toDated,) async {
    await SalesReportDbDatabase.instance.getDateWiseList(fromDate: fromDate, toDate: toDate).then((value) {
      getDataList = value;
      getCustomerList = value;
      toDate="";
      fromDate="";
      calculate();
    });
    notifyListeners();
  }
  double _totalAmount = 0.0;
  double get totalAmount => _totalAmount;

  set getTotalAmount(double totalAmt){
    _totalAmount = totalAmt;
  }
  calculate(){
    double totalAmount = 0.0;
    for(int i = 0; i<filterCustomerList.length; i++){
      totalAmount += filterCustomerList[i].netAmount;
    }
    getTotalAmount = totalAmount;
    notifyListeners();
  }

  set filterCustomerListScreen(value) {
    _filterCustomerList = _customerList
        .where((u) => (u.glDesc.toLowerCase().contains(value.toLowerCase())))
        .toList();
    calculate();
    notifyListeners();
  }

  Future<void> getSaleTotalFromDB() async {
    try {
      totalSum = await SalesReportDbDatabase.instance.totalSalesSum();
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
    await generateSalesInvoice(
      companyDataDetails: _companyDetail,
      salesReportList: _dataList,
      billDate: '',
      billNo: '',
      glDesc: '',
      salesType: '',
      netAmount: '',

    );
  }
}