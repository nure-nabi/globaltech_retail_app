import 'package:flutter/foundation.dart';

class DataProvider with ChangeNotifier {
  List<dynamic> _reportList = [];

  List<dynamic> get reportList => _reportList;

  void reset() {
    _reportList.clear();
    notifyListeners();
  }

  void addReportList(List<dynamic> reportList) {
    _reportList.clear();
    _reportList = reportList;
  }
}
