


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
    await checkConnection(ledgerName);
    getCustomer = null;
  }

  checkConnection(String ledgerName) async {
    CheckNetwork.check().then((network) async {
      getCompanyDetail = await GetAllPref.companyDetail();
      if (network) {
        await getDataList(ledgerName);
      } else {
         await getLedgerListFromDB(ledgerName);
      }
    });
  }

  clear() async {
    _isLoading = false;

  }

  Future<List<OutletDataModel>> getDataList(String ledgerName) async {
    // getCompanyDetail = await GetAllPref.companyDetail();
    OutletModel outletData = await OutletList.partyList(
      dbName: _companyDetail.dbName,
    );
    if (outletData.statusCode == 200) {
      await onSuccess(dataModel: outletData.data,ledgerName:ledgerName);
      return outletData.data;
    } else {
      return [];
    }
  }

  onSuccess({required List<OutletDataModel> dataModel,required String ledgerName}) async {
    await LedgerDatabase.instance.deleteData();
    for (var element in dataModel) {
      await LedgerDatabase.instance.insertData(element);
    }
    await getLedgerListFromDB(ledgerName);
    notifyListeners();
  }
  getLedgerListFromDB(String ledgerName) async {
    await LedgerDatabase.instance.getLedgerCatagoryList(ledgerName).then((value) {
      getLedgerList = value;
    });
    notifyListeners();
  }

  String? selectedGlCode;

  late String? _customer = null;
  String?  get customer => _customer;

  set getCustomer(String? customer) {
    _customer = customer;
    notifyListeners();
  }
  late List<OutletDataModel> _ledgerList = [];
  List<OutletDataModel> get LedgerList => _ledgerList;

  set getLedgerList(List<OutletDataModel> value) {
    _ledgerList = value;
    notifyListeners();
  }

  late bool _isStatus = true;
  bool get isStatus => _isStatus;

  set getStatus(bool value) {
    _isStatus = value;
    notifyListeners();
  }

}
