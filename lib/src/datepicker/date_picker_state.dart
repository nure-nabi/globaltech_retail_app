import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';

class DatePickerState extends ChangeNotifier {
  DatePickerState();

  init() async {
   // _toDate = NepaliDateTime.now().toString().substring(0, 10);
  //  _fromDate = NepaliDateTime.now().subtract(const Duration(days: 30)).toString().substring(0, 10);

    _toDate = DateTime.now().toString().substring(0, 10);
   // _fromDate = DateTime.now().toString().substring(0, 10);

    _fromDate = DateTime.now().subtract(const Duration(days: 30)).toString().substring(0, 10);
  }

  late String _fromDate = "";
  String get fromDate => _fromDate;
  set getFromDate(String value) {
    _fromDate = value.replaceAll("/", "-");
    notifyListeners();
  }

  late String _toDate = "";
  String get toDate => _toDate;
  set getToDate(String value) {
    _toDate = value.replaceAll("/", "-");
    notifyListeners();
  }
}
