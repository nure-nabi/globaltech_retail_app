import 'dart:convert';

import 'package:retail_app/src/login/model/login_model.dart';

import '../../config/config.dart';
import 'pref_text.dart';
import 'share_preference.dart';

class GetAllPref {
  static checkLogin() async {
    return await SharedPref.getData(
      key: PrefText.loginSuccess,
      dValue: false,
      type: "bool",
    );
  }

  static checkCompanySelected() async {
    return await SharedPref.getData(
      key: PrefText.companySelected,
      dValue: false,
      type: "bool",
    );
  }

  static userName() async {
    return await SharedPref.getData(
      key: PrefText.userName,
      dValue: "-",
      type: "String",
    );
  }

  static getPassword() async {
    return await SharedPref.getData(
      key: PrefText.setPassword,
      dValue: "-",
      type: "String",
    );
  }
  static baseImageURL() async {
    return await SharedPref.getData(
      key: PrefText.apiImageUrl,
      dValue: "-",
      type: "String",
    );
  }

  static companyInitial() async {
    return await SharedPref.getData(
      key: PrefText.companyInital,
      dValue: "-",
      type: "String",
    );
  }

  static userCode() async {
    return await SharedPref.getData(
      key: PrefText.userCode,
      dValue: "-",
      type: "String",
    );
  }
  static customerName() async {
    return await SharedPref.getData(
      key: PrefText.customerName,
      dValue: "-",
      type: "String",
    );
  }

  static customerAddress() async {
    return await SharedPref.getData(
      key: PrefText.customerAddress,
      dValue: "-",
      type: "String",
    );
  }

  static salePurchaseMap() async {
    return await SharedPref.getData(
      key: PrefText.salePurchaseMap,
      dValue: "-",
      type: "String",
    );
  }

  static outLetCode() async {
    return await SharedPref.getData(
      key: PrefText.outLetCode,
      dValue: "-",
      type: "String",
    );
  }

  static getVoucher() async {
    return await SharedPref.getData(
      key: PrefText.voucherNo,
      dValue: "-",
      type: "String",
    );
  }
  static unitCode() async {
    return await SharedPref.getData(
      key: PrefText.unitCode,
      dValue: "-",
      type: "String",
    );
  }

  static apiUrl() async {
    return await SharedPref.getData(
      key: PrefText.apiUrl,
      dValue: AppDetails.demoAPI,
      type: "String",
    );
  }

  static imageURL() async {
    return await SharedPref.getData(
      key: PrefText.imageURL,
      dValue: "-",
      type: "String",
    );
  }

  static companyDetail() async {
    String value = await SharedPref.getData(
      key: PrefText.companyDetail,
      dValue: "ERROR",
      type: "String",
    );
    if (value != "-") {
      Map<String, dynamic> userAuthData = jsonDecode(value);
      return CompanyDetailsModel.fromJson(userAuthData);
    } else {
      return CompanyDetailsModel.fromJson({});
    }
  }

  static deviceInfo() async {
    await SharedPref.setData(
      key: PrefText.deviceInfo,
      dValue: "-",
      type: "String",
    );
  }

  static getTimeCurrent() async {
    return await SharedPref.getData(
      key: PrefText.settimeCurrent,
      dValue: "-",
      type: "String",
    );
  }

  static getStartDate() async {
    return await SharedPref.getData(
      key: PrefText.setStartDate,
      dValue: "-",
      type: "String",
    );
  }

  static getEndDate() async {
    return await SharedPref.getData(
      key: PrefText.setEndDate,
      dValue: "-",
      type: "String",
    );
  }
}
