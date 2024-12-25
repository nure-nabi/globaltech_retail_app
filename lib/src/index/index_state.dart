import 'package:flutter/material.dart';
import 'package:retail_app/services/database/database_provider.dart';
import 'package:retail_app/services/router/router_name.dart';
import 'package:retail_app/services/sharepref/get_all_pref.dart';
import 'package:retail_app/services/sharepref/pref_text.dart';
import 'package:retail_app/services/sharepref/share_preference.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/customer_vendor_total_amount_api.dart';
import 'model/customer_vendor_total_amount_model.dart';

class IndexState extends ChangeNotifier {
  IndexState();

  late BuildContext _context;

  BuildContext get context => _context;
  late final NavigatorState navigator = Navigator.of(_context);

  set getContext(BuildContext value) {
    _context = value;

    init();
  }

  late bool _isLoading = false;

  bool get isLoading => _isLoading;

  set getLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }



  init() async {
    await clean();
    await clear();
    _companyDetail = await GetAllPref.companyDetail();
  }

  clean() async {
    _isLoading = false;
    _companyDetail = await GetAllPref.companyDetail();
  }

  clear() async {
    _isLoading = false;
    _companyDetail = await GetAllPref.companyDetail();
  }

  CompanyDetailsModel get companyDetail => _companyDetail;
  late CompanyDetailsModel _companyDetail = CompanyDetailsModel.fromJson({});

  set getCompanyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  logOut(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await SharedPref.removeData(key: PrefText.loginSuccess, type: "bool");
    prefs.setBool('use_biometric',false);
    //await SharedPref.removeData(key: PrefText.companySelected, type: "bool");
    //await SharedPref.removeData(key: PrefText.userName, type: "String");
   // await SharedPref.removeData(key: PrefText.companyDetail, type: "String");
    await DatabaseHelper.instance.onDropDatabase();
    await refreshPageToLogIn(context);
  }

  clearSharePref(context) async {
    await SharedPref.removeAllData(context);
    await logOut(context);
    // await refreshPageToLogIn(context);
  }

  refreshPageToLogIn(context) async {
    Navigator.of(context).pushNamedAndRemoveUntil(splashPath, (route) => false);
  }

  Future<List<CustomerVendorAmountDataModel>> getCustomerVendorAmountFromAPI() async {
    //getLoading = true;
    CustomerVendorAmountModel model = await CustomerAndVendorAmountApi.getCustomerAndVendorAmountHomePage(
      databaseName: _companyDetail.dbName,
    );

    if (model.statusCode == 200) {
      return model.data;

      getLoading = false;
    } else {
      return [];
    }
    notifyListeners();
  }



}