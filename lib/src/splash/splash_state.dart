import 'dart:async';

import 'package:flutter/material.dart';
import 'package:retail_app/services/router/router_name.dart';
import 'package:retail_app/services/sharepref/get_all_pref.dart';

import '../../utils/custom_log.dart';

class SplashState extends ChangeNotifier {
  SplashState();

  late BuildContext _context;
  BuildContext get context => _context;
  late final NavigatorState navigator = Navigator.of(_context);
  set getContext(BuildContext value) {
    _context = value;

    ///
    init();
  }

  init() async {
    await startTimer();
  }

  startTimer() {
    Future.delayed(const Duration(seconds: 2), () async {
      await navigateUser();
    });
  }

  navigateUser() async {
    bool login = await GetAllPref.checkLogin();
    bool companySelected = await GetAllPref.checkCompanySelected();

    CustomLog.actionLog(value: "LOGIN => $login");
    CustomLog.actionLog(value: "Company Selected => $companySelected");

    if (!login) {
      return navigator.pushReplacementNamed(loginPath);
    }
    //
    else if (!companySelected) {
      return navigator.pushReplacementNamed(loginPath);
    }
    //
    else {
      return navigator.pushReplacementNamed(indexPath);
    }
  }
}
