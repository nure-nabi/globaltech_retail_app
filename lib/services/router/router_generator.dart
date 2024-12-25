import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:retail_app/services/router/router_name.dart';
import 'package:retail_app/src/branch/screen/branch_screen.dart';
import 'package:retail_app/src/index/index_screen.dart';
import 'package:retail_app/src/ledger_master/ledger_master_screen.dart';
import 'package:retail_app/src/ledger_report_party/ledger_report_party_screen.dart';
import 'package:retail_app/src/login/login_screen.dart';
import 'package:retail_app/src/product_master/product_master_screen.dart';
import 'package:retail_app/src/products/components/product_list_screen.dart';
import 'package:retail_app/src/purchase_report/purchase_report_screen.dart';
import 'package:retail_app/src/sales/components/sales_confirm_section.dart';
import 'package:retail_app/src/salesreport/sales_report_screen.dart';
import 'package:retail_app/src/splash/splash_screen.dart';
import 'package:retail_app/src/vendor_report_ledger/vendor_report_ledger_screen.dart';
import '../../src/ledger_report_party_bill/ledger_report_party_bill.dart';
import '../../src/products/products_screen.dart';
import '../../src/purchase/screen/vendor_screen.dart';
import '../../src/sales/customer_list_entry.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashPath:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const SplashScreen(),
        );
      case loginPath:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const LoginScreen(),
        );
      case indexPath:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const IndexScreen(),
        );
      case createLedgerPath:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const LedgerMasterScreen(),
        );
      case productScreenPath:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const ProductScreen(),
        );
      case productListPath:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const ProductListScreen(),
        );
    // ProductListScreen
      case ledgerReportPath:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const CustomerScreen(),
          //  CustomerScreen
        );
      case orderConfirmPath:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const OrderConfirmSection(),
        );
      case productMasterPath:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const ProductMasterScreen(),
        );
      case purchaseReportPath:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const PurchaseScreen(),
        );
      case salesReportPath:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const SalesReportScreen(),
        );
      case customerScreenPath:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const CustomerListEntry(ledgerName: 'customer',),
        );
      case branchPath:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const BranchListScreen(automaticallyImplyLeading: true,),
        );
      case ledgerScreenPath:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const LedgerListScreen(ledgerName: 'vendor',),
        );
      case ledgerReportPartyBillScreen:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const LedgerReportPartyBillScreen(glCode: '', customerName: '',),
        );
      case vendorReportLedger:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: VendorReportLedgerScreen(),
        );
    /*PurchaseScreen*/
      default:
        return errorRoute();
       //  break;
    }
  }

  static Route<dynamic> errorRoute() {
   // return PageTransition(
   //    type: PageTransitionType.rightToLeft,
   //    child: const IndexScreen(),
   //  );
   //  return PageTransition(
   //    type: PageTransitionType.rightToLeft,
   //    child: Scaffold(
   //      appBar: AppBar(title: const Text('Error')),
   //      body: const Center(child: Text('ERROR ROUTE')),
   //    ),
   //
    //ERROR Screen Message for illegal route call
      return MaterialPageRoute(builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('ERROR ROUTE')),
        );
      });
    }

}