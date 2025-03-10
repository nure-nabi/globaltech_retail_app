import 'package:flutter/material.dart';
import 'package:retail_app/src/ledger_report_party/model/ledger_report_party_model.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/vendor_report_ledger/vendor_report_ledger.dart';
import 'package:retail_app/utils/connection_status.dart';
import '../../services/services.dart';

class VendorReportLedgerState extends ChangeNotifier {
  VendorReportLedgerState();

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
      }
    } catch (e) {
      debugPrint('Error checking network: $e');
    }
  }

  Future<void> networkSuccess() async {
    isLoading = true;
    await getVendorDataFromAPI();
    isLoading = false;
  }

  late List<CustomerDataModel> _vendorList = [], _filterVendorList = [];
  List<CustomerDataModel> get vendorList => _vendorList;
  List<CustomerDataModel> get filterVendorList => _filterVendorList;

  set getVendorList(List<CustomerDataModel> value) {
    _vendorList = value;
    _filterVendorList = _vendorList;
    notifyListeners();
  }

  set filterVendorList(value) {
    _filterVendorList = _vendorList
        .where((u) => (u.glDesc.toLowerCase().contains(value.toLowerCase())))
        .toList();
    notifyListeners();
  }

  double _totalVendorAmount = 0.0;
  double get totalVendorAmount => _totalVendorAmount;

  set getTotalVendorAmount(double value){
    _totalVendorAmount = value;
  }


  // Future<void> getVendorDataFromAPI() async {
  //   try {
  //     CustomerModel model = await VendorReportLedgerApi.apiCall(
  //       databaseName: _companyDetail.dbName,
  //       category: 'Customer',
  //     );
  //
  //     if (model.statusCode == 200) {
  //       getDataList = model.data;
  //       await onSuccess(dataModel: model.data);
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching customer data: $e');
  //   }
  // }


  Future<void> getVendorDataFromAPI() async {
    try {
      CustomerModel model = await VendorReportLedgerApi.apiCall(
        databaseName: _companyDetail.dbName,
        category: 'Vendor',
        unitcode: await GetAllPref.unitCode(),
      );

      if (model.statusCode == 200) {
        getDataList = model.data;
        await onSuccess(dataModel: model.data);
      }
    } catch (e) {
      debugPrint('Error fetching customer data: $e');
    }
  }

  onSuccess({required List<CustomerDataModel> dataModel}) async {
    await VendorDatabase.instance.deleteData();
    for (var element in dataModel) {
      await VendorDatabase.instance.insertData(element);
    }

    await getVendorListFromDB();
    notifyListeners();
  }
  getVendorListFromDB() async {
    await VendorDatabase.instance.getGlDescData().then((value) {
      getVendorList = value;
    });
    await calculateTotal();
    notifyListeners();
  }



  calculateTotal(){
    double totalAmount = 0.0;
    for(int i = 0; i<filterVendorList.length; i++){
      totalAmount += double.parse(filterVendorList[i].amount);
    }
    getTotalVendorAmount = totalAmount;
  }

  late CustomerModel _selectedGroup = CustomerModel.fromJson({}, "");

  CustomerModel get selectedGroup => _selectedGroup;

  set getSelectedGroup(CustomerModel value) {
    _selectedGroup = value;
    notifyListeners();
  }
}