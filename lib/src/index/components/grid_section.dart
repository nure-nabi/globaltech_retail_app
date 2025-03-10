import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retail_app/constants/assets_list.dart';
import 'package:retail_app/services/router/router_name.dart';
import 'package:retail_app/src/index/components/scrolling.dart';
import 'package:retail_app/themes/colors.dart';
import 'package:retail_app/themes/fonts_style.dart';
import '../../../constants/text_style.dart';
import '../../purchase/screen/vendor_screen.dart';

class HomeGridSection extends StatelessWidget {
  const HomeGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        Text(
          'Master Creation',
          style: cardTextStyleTitle,
        ),
        const SizedBox(
          height: 4.0,
        ),
        Row(
          children: [
            Expanded(
              child: Card(
                elevation: 4, // Set elevation for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Set border radius for the card
                ),
                child: GridWidget(
                  image: AssetsList.createImage,
                  name: "Ledger",
                  name2: "Creation",
                  icon: const Icon(FontAwesomeIcons.fontAwesome),
                  onTap: () {
                    Navigator.pushNamed(context, createLedgerPath);
                  },
                ),
              ),
            ),
            Expanded(
              child: Card(
                elevation: 4, // Set elevation for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Set border radius for the card
                ),
                child: GridWidget(
                  image: AssetsList.productImage,
                  name: "Product",
                  name2: "Master",
                  onTap: () {
                    Navigator.pushNamed(context, productMasterPath);
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          'Our Products',
          style: cardTextStyleTitle,
        ),
        const SizedBox(
          height: 4.0,
        ),
        const ScrollingImages(),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          'Transition  Entry',
          style: cardTextStyleTitle,
        ),
        const SizedBox(
          height: 4.0,
        ),
        Row(
          children: [
            Expanded(
              child: Card(
                elevation: 4, // Set elevation for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Set border radius for the card
                ),
                child: GridWidget(
                  image: AssetsList.purchaseImage,
                  name: "Purchase",
                  name2: "Entry",
                  onTap: () {
                    Navigator.pushNamed(context, ledgerScreenPath);
                  },
                ),
              ),
            ),
            Expanded(
              child: Card(
                elevation: 4, // Set elevation for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Set border radius for the card
                ),
                child: GridWidget(
                  image: AssetsList.salesImage,
                  name: "Sales",
                  name2: "Entry",
                  onTap: () {
                    Navigator.pushNamed(context, customerScreenPath);
                  },
                ),
              ),
            ),
            Expanded(
              child: Card(
                elevation: 4, // Set elevation for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Set border radius for the card
                ),
                child: GridWidget(
                  image: AssetsList.reportImage,
                  name: "Vendor",
                  name2: "Report",
                  onTap: () {
                    // vendorReportLedger
                    Navigator.pushNamed(context, vendorReportLedger);
                    // Fluttertoast.showToast(msg: "In a Progress");
                    // Navigator.pushNamed(context, customerScreenPath);
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          'Transition  Report',
          style: cardTextStyleTitle,
        ),
        const SizedBox(
          height: 4.0,
        ),
        Row(
          children: [
            Expanded(
              child: Card(
                elevation: 4, // Set elevation for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Set border radius for the card
                ),
                child: GridWidget(
                  image: AssetsList.reportPurchase,
                  name: "Purchase",
                  name2: "Report",
                  onTap: () {
                    Navigator.pushNamed(context, purchaseReportPath,
                        arguments: {"Customer/Vendor"});
                  },
                ),
              ),
            ),
            Expanded(
              child: Card(
                elevation: 4, // Set elevation for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Set border radius for the card
                ),
                child: GridWidget(
                  image: AssetsList.salereport,
                  name: "Sales",
                  name2: "Report",
                  onTap: () {
                    Navigator.pushNamed(context, salesReportPath,
                        arguments: {"Customer"});

                  },
                ),
              ),
            ),
            Expanded(
              child: Card(
                elevation: 4, // Set elevation for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Set border radius for the card
                ),
                child: GridWidget(
                  image: AssetsList.customerreport,
                  name: "Customer",
                  name2: "Report",
                  icon: const Icon(FontAwesomeIcons.fontAwesome),
                  onTap: () {
                    Navigator.pushNamed(context, ledgerReportPath);
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          'Report',
          style: cardTextStyleTitle,
        ),
        const SizedBox(
          height: 4.0,
        ),
        Row(
          children: [
            Expanded(
              child: Card(
                elevation: 1, // Set elevation for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Set border radius for the card
                ),
                child: GridWidget(
                  image: AssetsList.reportPurchase,
                  name: "Daily",
                  name2: "Report",
                  onTap: () {
                    Navigator.pushNamed(context, dailyReport);
                  },
                ),
              ),
            ),
            Expanded(
              child: Card(
                elevation: 1, // Set elevation for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Set border radius for the card
                ),
                child: GridWidget(
                  image: AssetsList.reportPurchase,
                  name: "Pdc",
                  name2: "Report",
                  onTap: () {
                    Navigator.pushNamed(context, pDCScreen);
                  },
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }
}

class GridWidget extends StatelessWidget {
  final String name;
  final String name2;
  final String? image;
  final Icon? icon;
  final void Function()? onTap;

  const GridWidget({
    super.key,
    this.image,
    required this.name,
    required this.name2,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Container(
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 5.0,
      //   vertical: 5.0,
      // ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: (image != null)
                      ? Image.asset(
                    image ?? "",
                    width: 20,
                    height: 25,
                  )
                      : icon,
                ),
              ),
              const SizedBox(height: 3.0),
              Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      name,
                      textAlign: TextAlign.center, style: cardTextStyle,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      name2,
                      textAlign: TextAlign.center, style: cardTextStyle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// customerScreenPath