
import 'package:hive/hive.dart';

import '../constants/values.dart';

enum UserKey {
  customUrl,
  isAuthenticated,
  userName,
  userCode,
  userType,
  ledgerId,
  salesmanId,
  initial,
  databaseName,
  companyName,
  companyAddress,
  companyPhoneNo,
  fiscalYear,
  branchId,
  branchDescription,
  branchShortName,
  areaId,
  areaDesc,
  areaShortName,
  startDate,
  endDate,
  rememberMe,
  appVersion,
  useNepaliDatePicker,
}

enum MenuIdKey {
  Default,
  DashBoardReportSummary,
  LedgerMaster,
  ProductMaster,
  OnlineSalesOrderEntry,
  OnlineSalesInvoiceEntry,
  OnlineSalesReturnEntry,
  OnlineCashBankEntry,
  OnlinePdcEntry,
  OfflineSalesOrderEntry,
  OfflineSalesInvoiceEntry,
  OfflineSalesReturnEntry,
  OfflineCashBankEntry,
  OfflinePdcEntry,
  PurchaseReport,
  SalesReport,
  FinanceReport,
  TrialBalanceReport,
  BalanceSheetReport,
  ProfitLossReport,
  StockReport,
  GeneralDayClosingReport,
  GeneralGraphReport,
  RestaurantLog,
  PurchaseOrder,
  PurchaseChallan,
  PurchaseInvoice,
  PurchaseReturn,
  SalesOrder,
  SalesChallan,
  SalesInvoice,
  SalesReturn,
  CashBook,
  BankBook,
  CashFlow,
  BankFlow,
  AllLedger,
  CustomerLedger,
  VendorLedger,
  OtherLedger,
  PdcList,
  TrialBalanceNormal,
  TrialBalancePerodic,
  BalanceSheetNormal,
  BalanceSheetPerodic,
  ProfitLossNormal,
  ProfitLossPerodic,
  StockInAndOut,
  StockInAndOutWithValues,
  UserLoginHistory,
  UserMovementHistory,
  MenuPermission,
}

class HiveData {
  HiveData(this.key, this.value);

  final String key;
  final String value;

  @override
  String toString() {
    return '{$key: $value}';
  }
}

class HiveStorage {
  static final Box _userPrefBox = Hive.box(HiveDatabase.user_prefs.name);

  static bool hasPermission(MenuIdKey key) {
    return _userPrefBox.get(key.name, defaultValue: false);
  }

  static Future<void> setPermission(MenuIdKey key, bool value) async {
    await _userPrefBox.put(key.name, value);
  }

  static Future<void> add(String key, String value) async {
    await _userPrefBox.put(key, value);
  }

  static String get(String key) {
    return _userPrefBox.get(key, defaultValue: '');
  }

  static Map<String, String> getAll() {
    return _userPrefBox.toMap() as Map<String, String>;
  }

  static Future<void> delete(String key) async {
    await _userPrefBox.delete(key);
  }

  static Future<void> deleteAll() async {
    await _userPrefBox.deleteAll(_enumList());
  }

  static List<String> _enumList() {
    final List<String> list = [];
    for (UserKey value in UserKey.values) {
      list.add(value.name);
    }
    return list;
  }


}


