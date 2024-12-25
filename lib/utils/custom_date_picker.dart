import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_utils/nepali_utils.dart';

class MyDatePicker {
  MyDatePicker(this.context);

  late BuildContext context;

  /// For Nepali Date
  Future<String> nepaliDate(
      {NepaliDateTime? firstDate, NepaliDateTime? lastDate}) async {
    NepaliDateTime nowDate = NepaliDateTime.now();
    NepaliDateTime? pickedDate = await picker.showMaterialDatePicker(
      context: context,
      initialDate: nowDate,
      firstDate: firstDate ?? NepaliDateTime(2000),
      lastDate: lastDate ?? NepaliDateTime(2090),
      initialDatePickerMode: DatePickerMode.day,
    );
    if (pickedDate != null && pickedDate != firstDate) firstDate = pickedDate;
    return firstDate.toString().substring(0, 10).replaceAll("-", "/");
  }

  /// For English Date
  Future<String> englishDate({DateTime? date}) async {
    DateTime nowDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: nowDate,
      firstDate: date ?? DateTime(2000),
      lastDate: DateTime(2099),
      initialDatePickerMode: DatePickerMode.day,
    );
    if (pickedDate != null && pickedDate != date) date = pickedDate;
    return date.toString().substring(0, 10).replaceAll("-", "/");
  }
}
