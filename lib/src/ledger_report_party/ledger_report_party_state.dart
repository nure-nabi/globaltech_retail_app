import 'package:flutter/material.dart';
import 'package:retail_app/src/ledger_report_party/api/ledger_report_party_api.dart';
import 'package:retail_app/src/ledger_report_party/db/ledger_report_party_db.dart';
import 'package:retail_app/src/ledger_report_party/model/ledger_report_party_model.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/utils/connection_status.dart';

import '../../services/services.dart';

class CustomerState extends ChangeNotifier {
  CustomerState();

  String _glCode = "";

  String get glCode => _glCode;

  late BuildContext _context;

  BuildContext get context => _context;
  late NavigatorState navigator;

  set getContext(BuildContext value) {
    _context = value;
    navigator = Navigator.of(_context);

    init();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set setGlCode(String value) {
    _glCode = value;
    notifyListeners();
  }

  init() async {
    await clear();
    await checkConnection();
    _companyDetail = await GetAllPref.companyDetail();
  }

  clear() async {
    _isLoading = false;
    _companyDetail = await GetAllPref.companyDetail();
  }

  late CompanyDetailsModel _companyDetail = CompanyDetailsModel.fromJson({});

  CompanyDetailsModel get companyDetail => _companyDetail;

  set getCompanyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  late List<CustomerDataModel> _dataList = [];

  List<CustomerDataModel> get dataList => _dataList;

  set getDataList(List<CustomerDataModel> value) {
    _dataList = value;
    notifyListeners();
  }

  Future<void> checkConnection() async {
    try {
      bool network = await CheckNetwork.check();
      if (network) {
        await networkSuccess();
      } else {
        debugPrint('No internet Connection');
        await getCustomerListFromDB();
      }
    } catch (e) {
      debugPrint('Error checking network: $e');
    }
  }

  Future<void> networkSuccess() async {
    isLoading = true;
    await getCustomerListFromDB();
    if(_filterCustomerList.isNotEmpty){
      await getCustomerListFromDB();
    }else{
      await getCustomerDataFromAPI();
    }

    isLoading = false;
  }

  late List<CustomerDataModel> _customerList = [], _filterCustomerList= [];
  List<CustomerDataModel> get customerList => _customerList;
  List<CustomerDataModel> get filterCustomerList => _filterCustomerList;

  set getCustomerList(List<CustomerDataModel> value) {
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

  double _totalCustomerAmount = 0.0;
  double get totalCustomerAmount => _totalCustomerAmount;

  set getTotalCustomerAmount(double value){
    _totalCustomerAmount = value;
  }

  Future<void> getCustomerDataFromAPI() async {
    try {
      CustomerModel model = await CustomerApi.apiCall(
        databaseName: _companyDetail.dbName,
        category: 'Customer',
        unitcode: await GetAllPref.unitCode(),
      );

      if (model.statusCode == 200) {
      //  getDataList = model.data;
        await onSuccess(dataModel: model.data);
      }
    } catch (e) {
      debugPrint('Error fetching customer data: $e');
    }
  }

  onSuccess({required List<CustomerDataModel> dataModel}) async {
    await CustomerDatabase.instance.deleteData();
    for (var element in dataModel) {
      await CustomerDatabase.instance.insertData(element);
    }

    await getCustomerListFromDB();
    notifyListeners();
  }
  getCustomerListFromDB() async {
    await CustomerDatabase.instance.getGlDescData().then((value) {
      getCustomerList = value;
    });
    await calculateTotal();
    notifyListeners();
  }

  set filterCustomerListScreen(value) {
    _filterCustomerList = _customerList
        .where((u) => (u.glDesc.toLowerCase().contains(value.toLowerCase())))
        .toList();
    notifyListeners();
  }


  calculateTotal(){
    double totalAmount = 0.0;
    for(int i = 0; i<filterCustomerList.length; i++){
      totalAmount += double.parse(filterCustomerList[i].amount);
    }
    getTotalCustomerAmount = totalAmount;
  }

  late CustomerModel _selectedGroup = CustomerModel.fromJson({}, "");

  CustomerModel get selectedGroup => _selectedGroup;

  set getSelectedGroup(CustomerModel value) {
    _selectedGroup = value;
    notifyListeners();
  }
}