
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';

import '../../../constants/values.dart';
import '../../../src/ledger_report_party_bill/provider/report_provider.dart';
import '../../../utils/string_utils.dart';
import '../option_dialog_custom_option.dart';
import 'option_selection.dart';

Widget _fromDatePicker(ReportProvider reportProvider, BuildContext context) {
  //if (HiveStorage.get(UserKey.useNepaliDatePicker.name) != 'true') {
    return TextButton(
      onPressed: () async {
        if (reportProvider.chosenDate.toString() == AccountingPeriod.custome_date.toString()) {
          DateTime? dateTime = await showDatePicker(
            context: context,
            initialDate: reportProvider.fromDateEng,
            firstDate: NepaliDateTime(2000),
            lastDate: NepaliDateTime(2090),
            initialDatePickerMode: DatePickerMode.day,
          );

          if (dateTime != null) {
            reportProvider.fromDateEng = dateTime;
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12)
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month),
            SizedBox(width: 1,),
            Text(
              reportProvider.fromDateEng.toString().substring(0, 10),
              style: TextStyle(
                fontSize: 13,
                color: reportProvider.chosenDate.toString() == AccountingPeriod.custome_date.toString() ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
 // }

  return TextButton(
    onPressed: () async {
      if (reportProvider.chosenDate.toString() == AccountingPeriod.custome_date.toString()) {
        NepaliDateTime? nepaliDateTime = await picker.showMaterialDatePicker(
          context: context,
          initialDate: reportProvider.fromDateNep,
          firstDate: NepaliDateTime(2000),
          lastDate: NepaliDateTime(2090),
          initialDatePickerMode: DatePickerMode.day,
        );

        if (nepaliDateTime != null) {
          reportProvider.fromDateNep = nepaliDateTime;
          reportProvider.fromDateEng = nepaliDateTime.toDateTime();
        }
      }
    },
    child: Text(
      reportProvider.fromDateNep.toString().substring(0, 10),
      style: TextStyle(
        color: reportProvider.chosenDate.toString() == AccountingPeriod.custome_date.toString() ? Colors.white : Colors.grey,
      ),
    ),
  );
}

Widget _toDatePicker(ReportProvider reportProvider, BuildContext context) {
 // if (HiveStorage.get(UserKey.useNepaliDatePicker.name) != 'true') {
    return TextButton(
      onPressed: () async {
        if (reportProvider.chosenDate.toString() == AccountingPeriod.custome_date.toString()) {
          DateTime? dateTime = await showDatePicker(
            context: context,
            initialDate: reportProvider.toDateEng,
            firstDate: NepaliDateTime(2000),
            lastDate: NepaliDateTime(2090),
            initialDatePickerMode: DatePickerMode.day,
          );

          if (dateTime != null) {
            reportProvider.toDateEng = dateTime;
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12)
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month),
            SizedBox(width: 1,),
            Text(
              reportProvider.toDateEng.toString().substring(0, 10),
              style: TextStyle(
                fontSize: 13,
                color: reportProvider.chosenDate.toString() == AccountingPeriod.custome_date.toString() ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
 // }

  return TextButton(
    onPressed: () async {
      if (reportProvider.chosenDate.toString() == AccountingPeriod.custome_date.toString()) {
        NepaliDateTime? nepaliDateTime = await picker.showMaterialDatePicker(
          context: context,
          initialDate: reportProvider.toDateNep,
          firstDate: NepaliDateTime(2000),
          lastDate: NepaliDateTime(2090),
          initialDatePickerMode: DatePickerMode.day,
        );

        if (nepaliDateTime != null) {
          reportProvider.toDateNep = nepaliDateTime;
          reportProvider.toDateEng = nepaliDateTime.toDateTime();
        }
      }
    },
    child: Text(
      reportProvider.toDateNep.toString().substring(0, 10),
      style: TextStyle(
        color: reportProvider.chosenDate.toString() == AccountingPeriod.custome_date.toString() ? Colors.white : Colors.grey,
      ),
    ),
  );
}

class DateSelectionContainer extends StatelessWidget {
  final OptionDialogGroup optionDialogGroup;

  DateSelectionContainer(this.optionDialogGroup, {super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);

    final List<String> accountingPeriods = AccountingPeriod.values.map((e) => e.name).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Select'),
            const Text(''),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: const Text(
                  'Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  overflow: TextOverflow.ellipsis,
                ),
                items: accountingPeriods
                    .map((accountingPeriod) => DropdownMenuItem<String>(
                        value: accountingPeriod,
                        child: Text(
                          StringUtils.getAccountingPeriodText(accountingPeriod),
                          overflow: TextOverflow.ellipsis,
                        )))
                    .toList(),
                value: reportProvider.chosenDate.name,
                onChanged: (value) {
                  reportProvider.chosenDate = AccountingPeriod.values.firstWhere((e) => e.name == value);

                  reportProvider.voucherNumbers = '';

                  changeNepaliDate(reportProvider);
                },
                buttonStyleData: ButtonStyleData(
                  height: 35,
                  width: 150,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey),
                  ),
                  elevation: 0,
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_forward_ios_outlined),
                  iconSize: 14,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 35,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 300,
                  width: 150,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 1,
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all(1),
                    thumbVisibility: MaterialStateProperty.all(true),
                  ),
                ),
                // offset: const Offset(-20, 0),
              ),
            ),
          ],
        ),
        Column(
        //  crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('From'),
                      _fromDatePicker(reportProvider, context),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text('To'),
                      _toDatePicker(reportProvider, context),
                    ],
                  ),
                ),

              ],
            ),
          ],
        ),
      ],
    );
  }
}
