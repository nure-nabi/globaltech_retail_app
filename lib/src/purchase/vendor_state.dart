


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/purchase/db/ledger_db.dart';
import 'package:retail_app/src/sales/api/sales_api.dart';

import 'package:retail_app/src/sales/model/outlet_model.dart';

import '../../services/services.dart';
import '../../utils/utils.dart';
import 'api/purchase_api.dart';
import 'db/account_group_list_db.dart';
import 'model/account_group_model.dart';



class LedgerState extends ChangeNotifier {
  LedgerState();

  late BuildContext _context;

  BuildContext get context => _context;
  late final NavigatorState navigator = Navigator.of(_context);

  set getContext(BuildContext value) {
    _context = value;
   // init();
  }

  late CompanyDetailsModel _companyDetail = CompanyDetailsModel.fromJson({});

  CompanyDetailsModel get companyDetail => _companyDetail;

  set getCompanyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  late bool _isLoading = false;

  bool get isLoading => _isLoading;

  set getLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  init(String ledgerName) async {
    await getLedgerListFromDB(ledgerName);
    await checkConnection(ledgerName);
    getCustomer = null;
    getCashBook = null;
  }

  checkConnection(String ledgerName) async {
    CheckNetwork.check().then((network) async {
      getCompanyDetail = await GetAllPref.companyDetail();
      if(LedgerList.isEmpty){
        if (network) {
          await getDataList(ledgerName,"cash book");
        } else {
          await getLedgerListFromDB(ledgerName);
          await getCashBookListFromDB("cash book");
        }
      }else{
        await getLedgerListFromDB(ledgerName);
        await getCashBookListFromDB("cash book");
      }

    });
  }

  clear() async {
   // _isLoading = true;
    _ledgerList = [];
    _cashBookList = [];
    selectedGlCode="";
    _customer = null;
    _cashBook = null;
  }

  customerClear(){
   // _cashBookList = [];
    _customer = null;
  }
  cashBookClear(){
    // _cashBookList = [];
    _cashBook = null;
  }

  Future<List<OutletDataModel>> getDataList(String ledgerName,String cashBook) async {
    // getCompanyDetail = await GetAllPref.companyDetail();
    getLoading = true;
    OutletModel outletData = await OutletList.partyList(
      dbName: _companyDetail.dbName,
      unitCode: await GetAllPref.unitCode(),
    );
    if (outletData.statusCode == 200) {
      await onSuccess(dataModel: outletData.data,ledgerName:ledgerName, cashBook: cashBook);
      return outletData.data;
    } else {
      return [];
    }
  }

  onSuccess({required List<OutletDataModel> dataModel,required String ledgerName,required String cashBook}) async {
    await LedgerDatabase.instance.deleteData();
    for (var element in dataModel) {
      await LedgerDatabase.instance.insertData(element);
    }
    await getLedgerListFromDB(ledgerName);
    await getCashBookListFromDB(cashBook);
    notifyListeners();
  }
  getLedgerListFromDB(String ledgerName) async {

    await LedgerDatabase.instance.getLedgerCatagoryList(ledgerName).then((value) {
      getLedgerList = value;
    });
    getLoading = false;
    notifyListeners();
  }

  getCashBookListFromDB(String ledgerName) async {

    await LedgerDatabase.instance.getLedgerCashBookList(ledgerName).then((value) {
      getCashBookList = value;
    });
    getLoading = false;
    notifyListeners();
  }

  String? selectedGlCode;

  late String? _customer = null;
  String?  get customer => _customer;

  late String? _cashBook = null;
  String?  get cashBook => _cashBook;

  set getCustomer(String? customer) {
    _customer = customer;
    notifyListeners();
  }
  set getCashBook(String? value) {
    _cashBook = value;
    notifyListeners();
  }
  late List<OutletDataModel> _ledgerList = [];
  List<OutletDataModel> get LedgerList => _ledgerList;

  late List<OutletDataModel> _cashBookList = [];
  List<OutletDataModel> get cashBookList => _cashBookList;

  set getLedgerList(List<OutletDataModel> value) {
    _ledgerList = value;
    notifyListeners();
  }
  set getCashBookList(List<OutletDataModel> value) {
    _cashBookList = value;
    notifyListeners();
  }

  late bool _isStatus = true;
  bool get isStatus => _isStatus;

  set getStatus(bool value) {
    _isStatus = value;
    notifyListeners();
  }

}
