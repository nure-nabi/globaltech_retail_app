import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/services/services.dart';
import 'package:retail_app/src/sales/model/outlet_model.dart';
import 'package:retail_app/src/sales/sales_state.dart';
import 'package:retail_app/utils/loading_indicator.dart';
import '../../../themes/themes.dart';
import '../../../widgets/widgets.dart';
import '../../constants/text_style.dart';
import '../../services/router/router_name.dart';
import '../../services/sharepref/set_all_pref.dart';
import '../purchase/vendor_state.dart';
import 'db/product_sales_db.dart';
import 'db/temp_product_sales_db.dart';

class CustomerListEntry extends StatefulWidget {
 final String ledgerName;
  const CustomerListEntry({super.key,required this.ledgerName});

  @override
  State<CustomerListEntry> createState() => _CustomerListEntryState();
}

class _CustomerListEntryState extends State<CustomerListEntry> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LedgerState>(context, listen: false).getContext = context;
    Provider.of<LedgerState>(context, listen: false).init(widget.ledgerName);

   // orderState.clear2();

  }
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final state = context.watch<LedgerState>();
    return Scaffold(
        appBar: AppBar(
          title: Text("Customer List",style: cardTextStyleHeader,),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),

              child: Consumer<LedgerState>(
                  builder: (BuildContext context, state, Widget? child)
                  {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        value: state.customer,
                        isDense: true,
                        isExpanded: true,
                        hint: Text(
                          'Select Customer',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: state.LedgerList.map((party)=>
                           DropdownMenuItem<String>(
                            value: party.glDesc.toString(),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(12.0)),
                                  color:Colors.grey[200],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(party.glDesc.toString(),style: cardTextStyleDropDownHeader,),
                                    const SizedBox(height: 4,),
                                    party.address.isNotEmpty ? Text('Address: ${party.address.toString()}',style: cardTextStyleDropDownTitle,): const SizedBox(),
                                    const SizedBox(height: 4,),
                                    party.mobile.isNotEmpty ? Text('Mobile No: ${party.mobile.toString()}',style: cardTextStyleDropDownTitle): const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ).toList(),
                        // Custom display of the selected item
                        selectedItemBuilder: (BuildContext context) {
                          return state.LedgerList.map((party)  {
                            return Text(
                              party.glDesc,
                              style: cardTextStyleProductHeader,
                            );
                          }).toList();
                        },
                        onChanged: (value) {
                          setState(() async {
                            state.getCustomer = value.toString();
                            await  SetAllPref.customerName(value: value.toString());
                            int index = state.LedgerList.indexWhere((party) => party.glDesc.toString() == value);
                            if (index != -1) {
                              String selectedGlCode = state.LedgerList[index].glCode;
                              String address = state.LedgerList[index].address;
                              state.selectedGlCode = selectedGlCode;
                              await  SetAllPref.outLetCode(value: selectedGlCode);
                              await  SetAllPref.customerAddress(value: address.toString());
                            } else {
                            }
                          });
                        },
                        buttonStyleData:ButtonStyleData(
                          height: 50,
                          width: 350,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            // color: Colors.redAccent,
                          ),
                          // elevation: 2,
                        ),
                        dropdownStyleData:  DropdownStyleData(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                          //maxHeight: 700,
                        ),
                        menuItemStyleData:  MenuItemStyleData(
                          height: state.LedgerList.every((party) => party.address.isEmpty) ? 65 : state.LedgerList.every((party) => party.mobile.isEmpty) ? 65 : 95,
                         // widght: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 14, right: 14),

                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: textEditingController,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: textEditingController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Search for customer...',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.orange, width: 1),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            String itemValue = item.value.toString();
                            String lowercaseItemValue = itemValue.toLowerCase();
                            String uppercaseItemValue = itemValue.toUpperCase();
                            String lowercaseSearchValue = searchValue.toLowerCase();
                            String uppercaseSearchValue = searchValue.toUpperCase();
                            return lowercaseItemValue.contains(lowercaseSearchValue) ||
                                uppercaseItemValue.contains(uppercaseSearchValue) ||
                                itemValue.contains(searchValue);
                          },
                        ),
                        //This to clear the search value when you close the menu
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            textEditingController.clear();
                          }
                        },
                      ),
                    );
                  }
              ),
            ),
            const SizedBox(height: 15.0,),

            InkWell(
              onTap: () async {
                if(state.customer != null){
                  SetAllPref.salePurchaseMap(value: "sale");
                  Navigator.pushNamed(context,productScreenPath);
                  await ProductOrderDatabase.instance.deleteData();
                  await TempProductOrderDatabase.instance.deleteData();
                }else{
                  Fluttertoast.showToast(msg: "Please Select Customer");
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child:  Center(
                    child: Text("Add Item/Service",style: cardTextStyleHeader,),
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}
