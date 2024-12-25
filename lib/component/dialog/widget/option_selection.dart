
import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';

import '../../../constants/values.dart';
import '../../../src/ledger_report_party_bill/provider/report_provider.dart';
import '../../../storage/hive_storage.dart';
import '../option_dialog_custom_option.dart';
import 'date_selection.dart';
import 'options/all_ledger_dialog_options.dart';


final NepaliDateTime nepaliDateTimeNow = NepaliDateTime.now();

final NepaliDateTime nepaliDateToday = NepaliDateTime(
  nepaliDateTimeNow.year,
  nepaliDateTimeNow.month,
  nepaliDateTimeNow.day,
);

final NepaliDateTime nepaliDateYesterday = NepaliDateTime(
  nepaliDateTimeNow.year,
  nepaliDateTimeNow.month,
  nepaliDateTimeNow.day - 1,
);

final NepaliDateTime nepaliFirstDayOfCurrentWeek = NepaliDateTime.now().subtract(Duration(days: nepaliDateTimeNow.weekday - 1));

final NepaliDateTime nepaliLastDayOfCurrentWeek = NepaliDateTime.now().subtract(Duration(days: nepaliDateTimeNow.weekday - 7));

final NepaliDateTime nepaliFirstDayOfLastWeek = NepaliDateTime.now().subtract(Duration(days: nepaliDateTimeNow.weekday + 6));

final NepaliDateTime nepaliLastDayOfLastWeek = NepaliDateTime.now().subtract(Duration(days: nepaliDateTimeNow.weekday));

final NepaliDateTime nepaliFirstDayOfCurrentMonth = NepaliDateTime(
  nepaliDateTimeNow.year,
  nepaliDateTimeNow.month,
  1,
);

final NepaliDateTime nepaliLastDayOfCurrentMonth = NepaliDateTime(
  nepaliDateTimeNow.year,
  nepaliDateTimeNow.month,
  nepaliDateTimeNow.totalDays,
);

final NepaliDateTime nepaliFirstDayOfLastMonth = NepaliDateTime(
  nepaliDateTimeNow.year,
  nepaliDateTimeNow.month - 1,
  1,
);

final NepaliDateTime nepaliLastDayOfLastMonth = NepaliDateTime(
  nepaliDateTimeNow.year,
  nepaliDateTimeNow.month - 1,
  nepaliFirstDayOfLastMonth.difference(nepaliFirstDayOfCurrentMonth).inDays.abs(),
);

final accountingPeriodStart = HiveStorage.get(UserKey.startDate.name);
final accountingPeriodEnd = HiveStorage.get(UserKey.endDate.name);

void changeNepaliDate(ReportProvider reportProvider) {
  switch (reportProvider.chosenDate) {
    case AccountingPeriod.today:
      reportProvider.fromDateNep = nepaliDateToday;
      reportProvider.toDateNep = nepaliDateToday;
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
    case AccountingPeriod.yesterday:
      reportProvider.fromDateNep = nepaliDateYesterday;
      reportProvider.toDateNep = nepaliDateYesterday;
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
    case AccountingPeriod.current_week:
      reportProvider.fromDateNep = nepaliFirstDayOfCurrentWeek;
      reportProvider.toDateNep = nepaliLastDayOfCurrentWeek;
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
    case AccountingPeriod.last_week:
      reportProvider.fromDateNep = nepaliFirstDayOfLastWeek;
      reportProvider.toDateNep = nepaliLastDayOfLastWeek;
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
    case AccountingPeriod.current_month:
      reportProvider.fromDateNep = nepaliFirstDayOfCurrentMonth;
      reportProvider.toDateNep = nepaliLastDayOfCurrentMonth;
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
    case AccountingPeriod.last_month:
      reportProvider.fromDateNep = nepaliFirstDayOfLastMonth;
      reportProvider.toDateNep = nepaliLastDayOfLastMonth;
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
    case AccountingPeriod.accounting_period:
      reportProvider.fromDateNep = DateTime.parse(accountingPeriodStart).toNepaliDateTime();
      reportProvider.toDateNep = DateTime.parse(accountingPeriodEnd).toNepaliDateTime();
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
    case AccountingPeriod.custome_date:
      reportProvider.fromDateNep = reportProvider.selectedFromDateNep;
      reportProvider.toDateNep = reportProvider.selectedToDateNep;
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
  }
}

void setDropDownPeriod(ReportProvider reportProvider, AccountingPeriod accountingPeriod) {
  reportProvider.chosenDate = accountingPeriod;
  switch (accountingPeriod) {
    case AccountingPeriod.today:
      reportProvider.fromDateNep = nepaliDateToday;
      reportProvider.toDateNep = nepaliDateToday;
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
    case AccountingPeriod.yesterday:
      reportProvider.fromDateNep = nepaliDateYesterday;
      reportProvider.toDateNep = nepaliDateYesterday;
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
    case AccountingPeriod.current_week:
      reportProvider.fromDateNep = nepaliFirstDayOfCurrentWeek;
      reportProvider.toDateNep = nepaliLastDayOfCurrentWeek;
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
    case AccountingPeriod.last_week:
      reportProvider.fromDateNep = nepaliFirstDayOfLastWeek;
      reportProvider.toDateNep = nepaliLastDayOfLastWeek;
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
    case AccountingPeriod.current_month:
      reportProvider.fromDateNep = nepaliFirstDayOfCurrentMonth;
      reportProvider.toDateNep = nepaliLastDayOfCurrentMonth;
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
    case AccountingPeriod.last_month:
      reportProvider.fromDateNep = nepaliFirstDayOfLastMonth;
      reportProvider.toDateNep = nepaliLastDayOfLastMonth;
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
    case AccountingPeriod.accounting_period:
      reportProvider.fromDateNep = DateTime.parse(accountingPeriodStart).toNepaliDateTime();
      reportProvider.toDateNep = DateTime.parse(accountingPeriodEnd).toNepaliDateTime();
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
    case AccountingPeriod.custome_date:
      reportProvider.fromDateNep = reportProvider.selectedFromDateNep;
      reportProvider.toDateNep = reportProvider.selectedToDateNep;
      reportProvider.fromDateEng = reportProvider.fromDateNep.toDateTime();
      reportProvider.toDateEng = reportProvider.toDateNep.toDateTime();
      break;
  }
}

class OptionSelection extends StatelessWidget {
  final OptionDialogCustomOption optionDialogCustomOption;
  final BuildContext parentContext;

  OptionSelection(
    this.optionDialogCustomOption,
    this.parentContext, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DateSelectionContainer(optionDialogCustomOption.optionDialogGroup),
        // if (optionDialogCustomOption.optionDialogGroup == OptionDialogGroup.sales) SalesDialogOptions(parentContext),
        // if (optionDialogCustomOption.optionDialogGroup == OptionDialogGroup.purchase) PurchaseDialogOptions(parentContext),
        // if (optionDialogCustomOption.optionDialogGroup == OptionDialogGroup.stock) StockDialogOptions(parentContext),
        // if (optionDialogCustomOption.optionDialogGroup == OptionDialogGroup.cashBook) CashBookDialogOptions(parentContext),
        // if (optionDialogCustomOption.optionDialogGroup == OptionDialogGroup.cashFlow) CashFlowDialogOptions(parentContext),
        // if (optionDialogCustomOption.optionDialogGroup == OptionDialogGroup.bankBook) BankBookDialogOptions(parentContext),
        // if (optionDialogCustomOption.optionDialogGroup == OptionDialogGroup.bankFlow) BankFlowDialogOptions(parentContext),
      //  if (optionDialogCustomOption.optionDialogGroup == OptionDialogGroup.allLedger) AllLedgerDialogOptions(parentContext),

      ],
    );
  }
}
