
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../src/ledger_report_party_bill/provider/report_provider.dart';

class CustomerLedgerDialogOptions extends StatelessWidget {
  final BuildContext topContext;

  const CustomerLedgerDialogOptions(this.topContext, {super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context, listen: true);

    return Column(
      children: [
       // if (HiveModelQuery().isUserOnlineCustomer() == false)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ledger'),
              const SizedBox(width: 30),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                  ),
                  child: InkWell(
                    onTap: () {},
                        //Navigator.push(context, MaterialPageRoute(builder: (_) => const LedgerPicker(glCategory: 'CUSTOMER')),),
                    child: const Text("Customer"),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Group By'),
            SizedBox(
              width: 150,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  value: reportProvider.groupByForLedgers == '' ? null : reportProvider.groupByForLedgers,
                  items: [
                    'Normal',
                  ].map<DropdownMenuItem>((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  hint: const Text(
                    'Select',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  onChanged: (value) {
                    reportProvider.groupByForLedgers = value.toString();
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 35,
                    width: 120,
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
                    width: 120,
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
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Summary'),
            Checkbox(
              value: reportProvider.isSummary,
              onChanged: (checked) {
                reportProvider.isSummary = checked!;
              },
            ),
            const Text('Narration'),
            Checkbox(
              value: reportProvider.isNarration,
              onChanged: (checked) {
                reportProvider.isNarration = checked!;
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Product Details'),
            Checkbox(
              value: reportProvider.isProductDetails,
              onChanged: (checked) {
                reportProvider.isProductDetails = checked!;
              },
            ),
          ],
        ),
       // if (HiveModelQuery().isUserOnlineCustomer() == false)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Select All'),
              Checkbox(
                value: reportProvider.isSelectAll,
                onChanged: (checked) async {
                  reportProvider.isSelectAll = checked!;
                  if (checked == true) {

                  } else {
                    reportProvider.ledgerId = '0';
                  }
                },
              ),
            ],
          ),
      ],
    );
  }
}
