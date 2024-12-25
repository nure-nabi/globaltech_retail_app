import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:retail_app/src/bill_report/bill_report_state.dart';
import 'package:retail_app/src/billbyvno/bill_by_vno_state.dart';
import 'package:retail_app/src/datepicker/date_picker_state.dart';
import 'package:retail_app/src/index/index_state.dart';
import 'package:retail_app/src/ledger_master/ledger_master_state.dart';
import 'package:retail_app/src/ledger_party_bill_details/ledger_party_bill_details_state.dart';
import 'package:retail_app/src/ledger_report_party/ledger_report_party_state.dart';
import 'package:retail_app/src/ledger_report_party_bill/ledger_report_party_bill_state.dart';
import 'package:retail_app/src/login/login_state.dart';
import 'package:retail_app/src/master/master_state.dart';
import 'package:retail_app/src/pdc/pdc.dart';
import 'package:retail_app/src/product_master/product_master_state.dart';
import 'package:retail_app/src/products/products_state.dart';
import 'package:retail_app/src/purchase_report/purchase_report_state.dart';
import 'package:retail_app/src/sales/sales_state.dart';
import 'package:retail_app/src/sales_bill_report/sales_bill_report_state.dart';
import 'package:retail_app/src/salesreport/sales_report_state.dart';
import 'package:retail_app/src/splash/splash_state.dart';
import 'package:retail_app/src/vendor_bill_report_details/vendor_bill_report_details_state.dart';
import 'package:retail_app/src/vendor_report_bill/vendor_report_bill_state.dart';
import 'package:retail_app/src/vendor_report_ledger/vendor_report_ledger_state.dart';
import '../src/branch/branch_state.dart';

import '../src/ledger_report_party_bill/provider/data_provider.dart';
import '../src/ledger_report_party_bill/provider/report_provider.dart';
import '../src/provider/dashboard_provider.dart';
import '../src/purchase/state/purchase_bill_term_state.dart';
import '../src/purchase/state/purchase_state.dart';
import '../src/purchase/vendor_state.dart';
import '../src/sales_bill_term/sales_bill_term_state.dart';

List<SingleChildWidget> myStateList = [
  ChangeNotifierProvider(create: (_) => SplashState()),
  ChangeNotifierProvider(create: (_) => LoginState()),
  ChangeNotifierProvider(create: (_) => IndexState()),
  ChangeNotifierProvider(create: (_) => ProductState()),
  ChangeNotifierProvider(create: (_) => ProductOrderState()),
  ChangeNotifierProvider(create: (_) => DatePickerState()),
  ChangeNotifierProvider(create: (_) => PDCState()),
  ChangeNotifierProvider(create: (_) => BillNoByVnoState()),
  ChangeNotifierProvider(create: (_) => ProductMaterState()),
  ChangeNotifierProvider(create: (_) => MaterState()),
  ChangeNotifierProvider(create: (_) => PurchaseReportState()),
  ChangeNotifierProvider(create: (_) => BillReportState()),
  ChangeNotifierProvider(create: (_) => SalesBillReportState()),
  ChangeNotifierProvider(create: (_) => SalesReportState()),
  ChangeNotifierProvider(create: (_) => SalesTermState()),
  ChangeNotifierProvider(create: (_) => BranchState()),
  ChangeNotifierProvider(create: (_) => DashBoardProvider()),
  ChangeNotifierProvider(create: (_) => LedgerState()),
  ChangeNotifierProvider(create: (_) => LedgerPartyBillDetailsState()),
  ChangeNotifierProvider(create: (_) => CustomerState()),
  ChangeNotifierProvider(create: (_) => LedgerReportPartyBillState()),
  ChangeNotifierProvider(create: (_) => LedgerMasterState()),
  ChangeNotifierProvider(create: (_) => PurchaseOrderState()),
  ChangeNotifierProvider(create: (_) => ReportProvider()),
  ChangeNotifierProvider(create: (_) => DataProvider()),
  ChangeNotifierProvider(create: (_) => PurchaseTermState()),
  ChangeNotifierProvider(create: (_) => VendorReportLedgerState()),
  ChangeNotifierProvider(create: (_) => VendorReportBillState()),
  ChangeNotifierProvider(create: (_) => VendorPartyBillDetailsState()),
];