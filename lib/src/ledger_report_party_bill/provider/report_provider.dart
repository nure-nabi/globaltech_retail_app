
import 'package:flutter/cupertino.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';

import '../../../constants/values.dart';
import '../../branch/model/branch_model.dart';
import 'data_provider.dart';

class ReportProvider with ChangeNotifier {
  TableRow? _headerWidget = null;

  TableRow? get headerWidget => _headerWidget;

  List<String> _headerList = [];

  List<String> get headerList => _headerList;

  List<String> _termHeaderList = [];

  List<String> get termHeaderList => _termHeaderList;

  bool _isAltQty = false;

  bool get isAltQty => _isAltQty;

  NepaliDateTime _fromDateNep = NepaliDateTime.now();

  NepaliDateTime get fromDateNep => _fromDateNep;

  NepaliDateTime _toDateNep = NepaliDateTime.now();

  NepaliDateTime get toDateNep => _toDateNep;

  DateTime _fromDateEng = DateTime.now();

  DateTime get fromDateEng => _fromDateEng;

  DateTime _toDateEng = DateTime.now();

  DateTime get toDateEng => _toDateEng;

  AccountingPeriod _chosenDate = AccountingPeriod.today;

  AccountingPeriod get chosenDate => _chosenDate;

  DateTime _selectedGeneralReportDateEng = DateTime.now();

  DateTime get selectedGeneralReportDateEng => _selectedGeneralReportDateEng;

  NepaliDateTime _selectedGeneralReportDateNep = NepaliDateTime.now();

  NepaliDateTime get selectedGeneralReportDateNep => _selectedGeneralReportDateNep;

  NepaliDateTime _selectedFromDateNep = NepaliDateTime.now();

  NepaliDateTime get selectedFromDateNep => _selectedFromDateNep;

  NepaliDateTime _selectedToDateNep = NepaliDateTime.now();

  NepaliDateTime get selectedToDateNep => _selectedToDateNep;

  bool _isDetails = false;

  bool get isDetails => _isDetails;

  bool _isOnlyZero = false;

  bool get isOnlyZero => _isOnlyZero;

  bool _isDateType = false;

  bool get isDateType => _isDateType;

  bool _isHorizontal = true;

  bool get isHorizontal => _isHorizontal;

  bool _isDisabledCheckDetails = false;

  bool get isDisabledCheckDetails => _isDisabledCheckDetails;

  String _ledgerId = '0';

  String get ledgerId => _ledgerId;

  String _ledgerName = '';

  String get ledgerName => _ledgerName;

  bool _isZeroBalance = false;

  bool get isZeroBalance => _isZeroBalance;

  bool _isSummary = false;

  bool get isSummary => _isSummary;

  bool _isNarration = false;

  bool get isNarration => _isNarration;

  bool _isNarrationInColumn = false;

  bool get isNarrationInColumn => _isNarrationInColumn;

  bool _isProductDetails = false;

  bool get isProductDetails => _isProductDetails;

  bool _isSelectAll = false;

  bool get isSelectAll => _isSelectAll;

  bool _isRemarks = false;

  bool get isRemarks => _isRemarks;

  bool _isSubLedger = false;

  bool get isSubLedger => _isSubLedger;

  bool _isMergeSales = false;

  bool get isMergeSales => _isMergeSales;

  bool _mergeCustomerVendor = false;

  bool get mergeCustomerVendor => _mergeCustomerVendor;

  String _voucherNumbers = '';

  String get voucherNumbers => _voucherNumbers;

  String _productIds = '';

  String get productIds => _productIds;

  String _chosenStatus = 'Due';

  String get chosenStatus => _chosenStatus;

  String _depositType = 'Both';

  String get depositType => _depositType;

  bool _includeLedger = false;

  bool get includeLedger => _includeLedger;

  bool _includeSubLedger = false;

  bool get includeSubLedger => _includeSubLedger;

  bool _isDepartment = false;

  bool get isDepartment => _isDepartment;

  bool _isMergeCustomerVendor = false;

  bool get isMergeCustomerVendor => _isMergeCustomerVendor;

  bool _isLedger = false;

  bool get isLedger => _isLedger;

  bool _isSortDrCr = false;

  bool get isSortDrCr => _isSortDrCr;

  bool _isOpeningOnly = false;

  bool get isOpeningOnly => _isOpeningOnly;

  bool _isIncludeClosingStock = false;

  bool get isIncludeClosingStock => _isIncludeClosingStock;

  bool _isDisableCheckedOpeningOnly = true;

  bool get isDisableCheckedOpeningOnly => _isDisableCheckedOpeningOnly;

  bool _isRepostValue = false;

  bool get isRepostValue => _isRepostValue;

  String _groupByForSales = 'Date';

  String get groupByForSales => _groupByForSales;

  String _groupByForPurchase = 'Date';

  String get groupByForPurchase => _groupByForPurchase;

  String _groupByForCashBook = 'Normal';

  String get groupByForCashBook => _groupByForCashBook;

  String _groupByForBankBook = 'Normal';

  String get groupByForBankBook => _groupByForBankBook;

  String _groupByForLedgers = 'Normal';

  String get groupByForLedgers => _groupByForLedgers;

  String _groupByForStock = 'Product';

  String get groupByForStock => _groupByForStock;

  String _groupByForProfitLoss = 'Account Group/Ledger';

  String get groupByForProfitLoss => _groupByForProfitLoss;

  String _groupByForTrialBalance = 'Normal';

  String get groupByForTrialBalance => _groupByForTrialBalance;

  String _groupByForBalanceSheet = 'Account Group/Ledger';

  String get groupByForBalanceSheet => _groupByForBalanceSheet;

  String _groupWiseByRestaurantLog = 'Time Wise';

  String get groupWiseByRestaurantLog => _groupWiseByRestaurantLog;

  String _reportTypeForCashBook = 'Normal';

  String get reportTypeForCashBook => _reportTypeForCashBook;

  String _reportTypeForBankBook = 'Normal';

  String get reportTypeForBankBook => _reportTypeForBankBook;

  String _reportTypeForCashFlow = 'Ledger';

  String get reportTypeForCashFlow => _reportTypeForCashFlow;

  String _reportTypeForBankFlow = 'Ledger';

  String get reportTypeForBankFlow => _reportTypeForBankFlow;

  String _reportTypeForBalanceSheet = 'Normal';

  String get reportTypeForBalanceSheet => _reportTypeForBalanceSheet;

  List<BranchModel> _branchList = [];

  List<BranchModel> get branchList => _branchList;

  int _branchId = 0;

  int get branchId => _branchId;

  void reset(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.reset();

    _groupByForSales = 'Date';
    _groupByForPurchase = 'Date';
    _groupByForCashBook = 'Normal';
    _groupByForBankBook = 'Normal';
    _groupByForLedgers = 'Normal';
    _groupByForStock = 'Product';
    _groupByForProfitLoss = 'Account Group/Ledger';
    _groupByForTrialBalance = 'Normal';
    _groupByForBalanceSheet = 'Account Group/Ledger';
    _groupWiseByRestaurantLog = 'Time Wise';

    _headerList.clear();
    _branchList.clear();
    _branchId = 0;
    _headerWidget = null;
    _fromDateNep = NepaliDateTime.now();
    _toDateNep = NepaliDateTime.now();
    _fromDateEng = DateTime.now();
    _toDateEng = DateTime.now();
    _chosenDate = AccountingPeriod.today;
    _selectedFromDateNep = NepaliDateTime.now();
    _selectedToDateNep = NepaliDateTime.now();
    _isAltQty = false;
    _isDetails = false;
    _isOnlyZero = false;
    _isDateType = false;
    _isHorizontal = true;
    _isDisabledCheckDetails = false;
    _ledgerId = '0';
    _ledgerName = '';
    _isZeroBalance = false;
    _isSummary = false;
    _isNarration = false;
    _isNarrationInColumn = false;
    _isSelectAll = false;
    _isProductDetails = false;
    _isRemarks = false;
    _isSubLedger = false;
    _isMergeSales = false;
    _mergeCustomerVendor = false;
    _voucherNumbers = '';
    _productIds = '';
    _reportTypeForCashBook = 'Normal';
    _reportTypeForBankBook = 'Normal';
    _reportTypeForCashFlow = 'Ledger';
    _reportTypeForBankFlow = 'Ledger';
    _reportTypeForBalanceSheet = 'Normal';

    _chosenStatus = 'Due';
    _depositType = 'Both';
    _includeLedger = false;
    _includeSubLedger = false;
    _isDepartment = false;
    _isMergeCustomerVendor = false;
    _isLedger = false;
    _isSortDrCr = false;
    _isOpeningOnly = false;
    _isIncludeClosingStock = false;
    _isDisableCheckedOpeningOnly = true;
    _isRepostValue = false;
    notifyListeners();
  }

  set headerWidget(TableRow? value) {
    _headerWidget = value;
    notifyListeners();
  }

  void addHeaderList(List<String> headerList) {
    _headerList.clear();
    _headerList = headerList;
  }

  void addTermHeaderList(List<String> termHeaderList) {
    _termHeaderList.clear();
    _termHeaderList = headerList;
  }

  set isDisabledCheckDetails(bool value) {
    _isDisabledCheckDetails = value;
    notifyListeners();
  }

  set isHorizontal(bool value) {
    _isHorizontal = value;
    notifyListeners();
  }

  set isDetails(bool value) {
    _isDetails = value;
    notifyListeners();
  }

  set isOnlyZero(bool value) {
    _isOnlyZero = value;
    notifyListeners();
  }

  set isDateType(bool value) {
    _isDateType = value;
    notifyListeners();
  }

  set chosenDate(AccountingPeriod value) {
    _chosenDate = value;
    notifyListeners();
  }

  set toDateEng(DateTime value) {
    _toDateEng = value;
    notifyListeners();
  }

  set fromDateEng(DateTime value) {
    _fromDateEng = value;
    notifyListeners();
  }

  set toDateNep(NepaliDateTime value) {
    _toDateNep = value;
    notifyListeners();
  }

  set fromDateNep(NepaliDateTime value) {
    _fromDateNep = value;
    notifyListeners();
  }

  set isAltQty(bool value) {
    _isAltQty = value;
    notifyListeners();
  }

  set selectedGeneralReportDateNep(NepaliDateTime value) {
    _selectedGeneralReportDateNep = value;
    notifyListeners();
  }

  set selectedGeneralReportDateEng(DateTime value) {
    _selectedGeneralReportDateEng = value;
    notifyListeners();
  }

  set selectedToDateNep(NepaliDateTime value) {
    _selectedToDateNep = value;
    notifyListeners();
  }

  set selectedFromDateNep(NepaliDateTime value) {
    _selectedFromDateNep = value;
    notifyListeners();
  }

  set ledgerId(String value) {
    if (value.split(',').isEmpty) {
      _isSelectAll = false;
    }
    _ledgerId = value;
    notifyListeners();
  }

  set ledgerName(String value) {
    _ledgerName = value;
    notifyListeners();
  }

  set isZeroBalance(bool value) {
    _isZeroBalance = value;
    notifyListeners();
  }

  set isSummary(bool value) {
    _isSummary = value;
    notifyListeners();
  }

  set isNarration(bool value) {
    _isNarration = value;
    notifyListeners();
  }

  set isNarrationInColumn(bool value) {
    _isNarrationInColumn = value;
    notifyListeners();
  }

  set isSelectAll(bool value) {
    _isSelectAll = value;
    if (_isSelectAll) {
      _ledgerId = '0';
      _ledgerName = '';
    }
    notifyListeners();
  }

  set isProductDetails(bool value) {
    _isProductDetails = value;
    notifyListeners();
  }

  set isRemarks(bool value) {
    _isRemarks = value;
    notifyListeners();
  }

  set isSubLedger(bool value) {
    _isSubLedger = value;
    notifyListeners();
  }

  set isMergeSales(bool value) {
    _isMergeSales = value;
    notifyListeners();
  }

  set mergeCustomerVendor(bool value) {
    _mergeCustomerVendor = value;
    notifyListeners();
  }

  set voucherNumbers(String value) {
    _voucherNumbers = value;
    notifyListeners();
  }

  set productIds(String value) {
    _productIds = value;
    notifyListeners();
  }

  set chosenStatus(String value) {
    _chosenStatus = value;
    notifyListeners();
  }

  set depositType(String value) {
    _depositType = value;
    notifyListeners();
  }

  set includeLedger(bool value) {
    _includeLedger = value;
    notifyListeners();
  }

  set includeSubLedger(bool value) {
    _includeSubLedger = value;
    notifyListeners();
  }

  set isDepartment(bool value) {
    _isDepartment = value;
    notifyListeners();
  }

  set isMergeCustomerVendor(bool value) {
    _isMergeCustomerVendor = value;
    notifyListeners();
  }

  set isLedger(bool value) {
    _isLedger = value;
    notifyListeners();
  }

  set isSortDrCr(bool value) {
    _isSortDrCr = value;
    notifyListeners();
  }

  set isOpeningOnly(bool value) {
    _isOpeningOnly = value;
    notifyListeners();
  }

  set isIncludeClosingStock(bool value) {
    _isIncludeClosingStock = value;
    notifyListeners();
  }

  set isDisableCheckedOpeningOnly(bool value) {
    _isDisableCheckedOpeningOnly = value;
    notifyListeners();
  }

  set isRepostValue(bool value) {
    _isRepostValue = value;
    notifyListeners();
  }

  set groupByForPurchase(String value) {
    _groupByForPurchase = value;
    notifyListeners();
  }

  set groupWiseForRestaurantLog(String value) {
    _groupWiseByRestaurantLog = value;
    notifyListeners();
  }

  set groupByForSales(String value) {
    _groupByForSales = value;
    notifyListeners();
  }

  set groupByForStock(String value) {
    _groupByForStock = value;
    notifyListeners();
  }

  set groupByForCashBook(String value) {
    _groupByForCashBook = value;
    notifyListeners();
  }

  set groupByForBankBook(String value) {
    _groupByForBankBook = value;
    notifyListeners();
  }

  set groupByForLedgers(String value) {
    _groupByForLedgers = value;
    notifyListeners();
  }

  set groupByForTrialBalance(String value) {
    _groupByForTrialBalance = value;
    notifyListeners();
  }

  set groupByForProfitLoss(String value) {
    _groupByForProfitLoss = value;
    notifyListeners();
  }

  set groupByForBalanceSheet(String value) {
    _groupByForBalanceSheet = value;
    notifyListeners();
  }

  set reportTypeForCashBook(String value) {
    _reportTypeForCashBook = value;
    notifyListeners();
  }

  set reportTypeForBankBook(String value) {
    _reportTypeForBankBook = value;
    notifyListeners();
  }

  set reportTypeForCashFlow(String value) {
    _reportTypeForCashFlow = value;
    notifyListeners();
  }

  set reportTypeForBankFlow(String value) {
    _reportTypeForBankFlow = value;
    notifyListeners();
  }

  set reportTypeForBalanceSheet(String value) {
    _reportTypeForBalanceSheet = value;
    notifyListeners();
  }

  set groupWiseByRestaurantLog(String groupWiseByRestaurantLog) {
    _groupWiseByRestaurantLog = groupWiseByRestaurantLog;
    notifyListeners();
  }

  set branchId(int branchId) {
    _branchId = branchId;
    notifyListeners();
  }

  set branchList(List<BranchModel> branchList) {
    _branchList = branchList;
    //notifyListeners();
  }

  // ReportProvider() {
  //   _branchId = int.tryParse(HiveStorage.get(UserKey.branchId.name)) ?? 0;
  // }
}
