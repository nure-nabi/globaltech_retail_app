import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:retail_app/src/login/db/login_db.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import '../../config/app_detail.dart';
import '../../services/sharepref/sharepref.dart';
import '../../utils/location_permission.dart';
import '../../utils/utils.dart';
import 'api/login_api.dart';
import 'companylist_screen.dart';

import 'setapi_screen.dart';

class LoginState extends ChangeNotifier {
  LoginState();

  late final GlobalKey<FormState> loginKey = GlobalKey<FormState>(),
      apiKey = GlobalKey<FormState>();

  late TextEditingController userNameController;
  late TextEditingController passwordController;
  late TextEditingController apiController;
  late TextEditingController apiImageController;

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
    await clear();
  }

  clear() async {
    apiController = TextEditingController(text: "");
    userNameController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");
    apiImageController = TextEditingController(text: "");

    _isLoading = false;
    _isPasswordHidden = true;

    baseUrl = await GetAllPref.apiUrl();
  }

  set getMyAPI(String value) {
    apiController.text = value.trim();
    notifyListeners();
  }

  set getImageAPI(String value) {
    apiImageController.text = value.trim();
    notifyListeners();
  }

  late bool _isLoading = false, _isPasswordHidden = false;
  bool get isLoading => _isLoading;
  bool get isPasswordHidden => _isPasswordHidden;
  set showHidePassword(value) {
    _isPasswordHidden = value;
    notifyListeners();
  }

  set getLoading(value) {
    _isLoading = value;
    notifyListeners();
  }


  permissionHandler(bool isRemembeMre) async {
    await MyPermission.askPermissions().then((value) async {
      if (value) {
        await isOnline(isRemembeMre);
        // await getLoginAPICall();
      } else {
        await MyPermission.askPermissions();
      }
    });
    notifyListeners();
  }

  setAPI() async {
    if (apiKey.currentState!.validate()) {
      CustomLog.actionLog(value: apiController.text.trim());
      await SetAllPref.baseURL(value: apiController.text.trim());
      await SetAllPref.baseImageURL(value: apiImageController.text.replaceAll("api", "").replaceAll(":802/", ""));

      await SetAllPref.imageURL(
        value: apiController.text.replaceAll("api", "").replaceAll(":802/", ""),
      );
      ShowToast.successToast(msg: "API has been set.");
      navigator.pop();
    }

    notifyListeners();
  }

  isOnline(bool isRemembeMre) async {
    await CheckNetwork.check().then((internet) async {
      if (internet) {
        await getLoginAPICall(isRemembeMre);
      } else {
        ShowToast.errorToast(msg: "No Internet Connection.");
      }
    });
  }

  onLogin(context,bool isRemembeMre) async {
    if (loginKey.currentState!.validate()) {
      if (demoLoginCheck()) {
      //  navigator.pushReplacementNamed(indexPath);

        return;
      } else {
      //  Fluttertoast.showToast(msg: "msg2");

      await  permissionHandler(isRemembeMre);
       // await isOnline(isRemembeMre);
      }
    }
    notifyListeners();
  }

  demoLoginCheck() {
    return AppDetails.demoUser == userNameController.text.trim() &&
        AppDetails.demoPassword == passwordController.text.trim();
  }

  getLoginAPICall(bool isRemembeMre) async {
    getLoading = true;

    CompanyModel model = await LoginAPI.login(
      username: userNameController.text.trim(),
      password: passwordController.text.trim(),
    ).onError((error, stackTrace) {
      CustomLog.warningLog(value: "ERROR $error");

      getLoading = false;
      //
      navigator.push(PageTransition(
        type: PageTransitionType.rightToLeft,
        child: const SetAPISection(),
      ));
    });
    CustomLog.warningLog(value: "API RESPONSE => ${jsonEncode(model)}");

    if (model.statusCode == 200) {
      await onLoginSuccess(data: model.data, isRemembeMre: isRemembeMre);
    }
    //
    else {
      getLoading = false;
      ShowToast.errorToast(msg: model.message);
    }
  }

  late List<CompanyDetailsModel> _companyList = [];
  List<CompanyDetailsModel> get companyList => _companyList;
  set getCompanyList(List<CompanyDetailsModel> value) {
    _companyList = value;
    notifyListeners();
  }

  onLoginSuccess({required List<CompanyDetailsModel> data,required bool isRemembeMre}) async {
    await ClientListDBHelper.instance.deleteAllData();
    for (var element in data) {
      await ClientListDBHelper.instance.insertData(element);
    }



    await onSuccess(isRemembeMre);
    notifyListeners();
  }

  onSuccess(bool isRemembeMre) async {
    getLoading = false;
    await SetAllPref.userName(value: userNameController.text.trim());
    await SetAllPref.setPassword(value: passwordController.text.trim());
    await SetAllPref.isLogin(value: isRemembeMre);
    final location = MyLocation();
    final String latitude = await location.lat();
    final String longitude = await location.long();
    await SetAllPref.latitude(value: latitude);
    await SetAllPref.longitude(value: longitude);
    await getCompanyFromDatabase();

    ///
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CompanyListScreen(
              automaticallyImplyLeading: false,
            ),
          ),
        );
    // navigator.pushReplacement(PageTransition(
    //   type: PageTransitionType.rightToLeft,
    //   child: const CompanyListScreen(automaticallyImplyLeading: false),
    // ));
  }

  getCompanyFromDatabase() async {
    await ClientListDBHelper.instance.getDataList().then((value) {
      getCompanyList = value;
    });
    notifyListeners();
  }
}
