import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

import 'package:retail_app/src/branch/api/branch_api.dart';
import 'package:retail_app/src/branch/model/branch_model.dart';
import 'package:retail_app/src/login/db/login_db.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import '../../config/app_detail.dart';
import '../../services/sharepref/sharepref.dart';
import '../../utils/utils.dart';


class BranchState extends ChangeNotifier {
  BranchState();

  late final GlobalKey<FormState> loginKey = GlobalKey<FormState>(),
      apiKey = GlobalKey<FormState>();

  late TextEditingController userNameController;
  late TextEditingController passwordController;
  late TextEditingController apiController;

  late String baseUrl;

  ///
  late BuildContext context;
  late final NavigatorState navigator = Navigator.of(context);
  set getContext(value) {
    context = value;

    ///
    init();
  }

  init() async {
    await checkConnection();
  }

  clear() async {
    apiController = TextEditingController(text: "");
    userNameController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");

    _isLoading = false;
    _isPasswordHidden = true;

    baseUrl = await GetAllPref.apiUrl();
  }

  set getMyAPI(String value) {
    apiController.text = value.trim();
    notifyListeners();
  }

  late bool _isLoading = false, _isPasswordHidden = false;
  bool get isLoading => _isLoading;

  set getLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  late String _unitCode = "";

  String get unitCode => _unitCode;

  set getUnitCode(String value) {
    _unitCode = value;
    notifyListeners();
  }

  checkConnection() async {
    // Fluttertoast.showToast(msg: "daba");
    CheckNetwork.check().then((network) async {
      getCompanyDetail = await GetAllPref.companyDetail();
      await getBranchAPICall();

      if (network) {
        //  await networkSuccess();
      } else {
        // await getGroupProductListFromDB();
      }
    });
  }
  late CompanyDetailsModel _companyDetail = CompanyDetailsModel.fromJson({});

  CompanyDetailsModel get companyDetail => _companyDetail;

  set getCompanyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }


  getBranchAPICall() async {

    getLoading = true;
    BranchModel model = await BranchAPI.branch(
      dbName: _companyDetail.dbName,
      usercode: await GetAllPref.userName(),
    ).onError((error, stackTrace) {
      CustomLog.warningLog(value: "ERROR $error");

      getLoading = false;
      //

    });
    CustomLog.warningLog(value: "API RESPONSE => ${jsonEncode(model)}");

    if (model.statusCode == 200) {
      await onLoginSuccess(data: model.data);

    }
    //
    else {
      getLoading = false;
      ShowToast.errorToast(msg: model.message);
    }
  }

  late List<BranchDetailsModel> _branchList = [];
  List<BranchDetailsModel> get branchList => _branchList;
  set getBranchList(List<BranchDetailsModel> value) {
    _branchList = value;
    notifyListeners();
  }

  onLoginSuccess({required List<BranchDetailsModel> data}) async {
    getBranchList = data;
    notifyListeners();
  }

  onSuccess() async {
    getLoading = false;

    //
    await SetAllPref.userName(value: userNameController.text.trim());
    await SetAllPref.setPassword(value: passwordController.text.trim());
    await SetAllPref.isLogin(value: true);
    await getCompanyFromDatabase();


  }

  getCompanyFromDatabase() async {
    await ClientListDBHelper.instance.getDataList().then((value) {
      //getCompanyList = value;
    });
    notifyListeners();
  }
}
