 import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/constants/assets_list.dart';
import 'package:retail_app/src/index/index.dart';
import 'package:retail_app/src/login/companylist_screen.dart';
import 'package:retail_app/src/login/login_state.dart';
import 'package:retail_app/src/purchase/db/ledger_db.dart';
import 'package:retail_app/src/purchase/db/purchase_product_order_db.dart';
import 'package:retail_app/src/purchase/db/temp_purchase_order_db.dart';
import 'package:retail_app/src/setting/setting.dart';
import 'package:retail_app/themes/themes.dart';

import '../../../constants/text_style.dart';
import '../../ledger_report_party_bill/db/ledger_report_party_bill_db.dart';
import '../../purchase/db/account_group_list_db.dart';
import '../../sales/db/product_sales_db.dart';
import '../../sales/db/temp_product_sales_db.dart';
import '../../sales_bill_term/db/sales_bill_term_db.dart';
import '../../salesreport/db/sales_report_db.dart';

class DrawerSection extends StatelessWidget {
  const DrawerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<IndexState>();
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.7,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(children: [
          titleSection(context),
          DrawerIconName(
            name: "Dashboard",
            iconName: Icons.dashboard,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          divider(),
          DrawerIconName(
            name: "Switch Company",
            iconName: MdiIcons.redoVariant,
            onTap: () {
              context.read<LoginState>().getCompanyFromDatabase();
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const CompanyListScreen(
                    automaticallyImplyLeading: true,
                  ),
                ),
              );
            },
          ),
          divider(),
          DrawerIconName(
            name: "Clear Data",
            iconName: Icons.clear,
            onTap: () {
              state.clearSharePref(context);
              TempProductOrderDatabase.instance.deleteData();
              TempPurchaseOrderDatabase.instance.deleteData();
              ProductOrderDatabase.instance.deleteData();
              PurchaseProductOrderDatabase.instance.deleteData();
              LedgerDatabase.instance.deleteData();
              SalesTermDatabase.instance.deleteData();
              SalesReportDbDatabase.instance.deleteData();
              LedgerReportDatabase.instance.deleteData();
              AccountGroupListDatabase.instance.deleteData();
            },
          ),
          divider(),
          DrawerIconName(
            name: "Log Out",
            iconName: Icons.logout,
            onTap: () {
              state.logOut(context);
            },
          ),
          divider(),
          DrawerIconName(
            name: "Setting",
            iconName: Icons.settings,
            onTap: () {
            //  state.logOut(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SystemSettingPage()),
              );
            },
          ),
          divider(),
        ]),
      ),
    );
  }

  Widget titleSection(context) {
    final state = Provider.of<IndexState>(context, listen: false);

    return Container(
      color: primaryColor,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage(AssetsList.appIcon),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "OMS|Retails",
            style: cardTextStyleHeader,
          ),
        ),
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "GlobalTech Nepal",
            style: cardTextStyleHeader,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              state.companyDetail.companyName,
              style: cardTextStyleHeader,
            ),
          ),
        ),
      ]),
    );
  }

  Widget divider() {
    return Container(height: 1.0, color: Colors.grey.shade300);
  }
}

class DrawerIconName extends StatelessWidget {
  final String name;
  final IconData iconName;
  final Function onTap;

  const DrawerIconName({
    super.key,
    required this.iconName,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Icon(
                iconName,
                size: 25.0,
                color: primaryColor,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                name,
                style: cardTextStyleSalePurchase,
              ),
            ),
          ],
        ),
      ),
    );
  }
}