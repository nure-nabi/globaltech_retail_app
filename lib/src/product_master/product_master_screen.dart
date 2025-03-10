
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/product_master/product_master_state.dart';
import 'package:retail_app/src/products/model/product_model.dart';
import 'package:retail_app/src/products/products.dart';
import 'package:retail_app/themes/colors.dart';
import 'package:retail_app/utils/show_toast.dart';
import 'package:retail_app/widgets/custom_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../constants/text_style.dart';


class ProductMasterScreen extends StatefulWidget {
  const ProductMasterScreen({super.key});

  @override
  State<ProductMasterScreen> createState() => _ProductMasterScreenState();
}

class _ProductMasterScreenState extends State<ProductMasterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode nodeOne = FocusNode();
 bool isSubmittedProduct = false;
 bool isSubmittedGroup = false;
 bool isSubmittedUnit = false;
  List<String> item = [
    'Item',
  ];
  String? selected;
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController textEditingUnitController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Provider.of<ProductMaterState>(context, listen: false).getContext = context;
    Provider.of<ProductState>(context, listen: false).getContext = context;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<ProductMaterState>(context, listen: false).clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Product Master',style: cardTextStyleHeader,),
      ),
      body: Consumer2<ProductMaterState,ProductState>(builder: (context, state,productState, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: state.productName,
                      style: cardTextWriteTitle,
                      cursorColor: Colors.orange,
                      cursorHeight: 20,
                      autofocus: true,
                      focusNode: nodeOne,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(27),
                      ],
                      decoration: InputDecoration(
                        hintText: "Product Name *",
                        // prefixIcon: const Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: const BorderSide(color: Colors.orange, width: 1),
                        ),
                        errorBorder: state.productName.text.isEmpty
                            ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: const BorderSide(color: Colors.red, width: 1),
                        ) : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          isSubmittedProduct = false;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return null;
                        }
                        return null;
                      },
                    ),
                  ),
                  if (isSubmittedProduct == true && state.productName.text.isEmpty)
                     Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Please enter Product name',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.red, fontSize: 12.0),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  //120
                  // FutureBuilder<List<ProductDataModel>>(
                  //   future: state.getDataList(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       List<ProductDataModel> groupList = snapshot.data!;
                  //       Set<String> uniqueGroupNames = groupList.map((product) => product.groupName.toString()).toSet();
                  //       return Container(
                  //         height: 50,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           border: Border.all(color: Colors.grey, width: 1),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: DropdownButton<String>(
                  //             value: state.selectedGrpCode,
                  //             hint:  Text('Select Group',style: cardTextWriteTitle,),
                  //          //   isDense: true,
                  //             isExpanded: true,
                  //             icon: const Icon(Icons.keyboard_arrow_down),
                  //             style: const TextStyle(color: Colors.black),
                  //             underline: Container(
                  //               height: 0.0,
                  //             ),
                  //             items: uniqueGroupNames.map((groupName) {
                  //               return DropdownMenuItem<String>(
                  //                 value: groupName,
                  //                 child: Text(groupName,style: cardTextWriteTitle,),
                  //               );
                  //             }).toList(),
                  //             onChanged: (value) {
                  //               setState(() {
                  //                 state.selectedGrpCode = value;
                  //                 isSubmittedGroup = false;
                  //               });
                  //             },
                  //           ),
                  //         ),
                  //       );
                  //     }else {
                  //       return Container(
                  //         height: 50,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           border: Border.all(color: Colors.grey, width: 1),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: DropdownButton<String>(
                  //             value: selected,
                  //             hint:  Text('Select Group',style: cardTextWriteTitle,),
                  //             isExpanded: true,
                  //             icon: const Icon(Icons.keyboard_arrow_down),
                  //             style: const TextStyle(color: Colors.black),
                  //             underline: Container(
                  //               height: 0.0,
                  //             ),
                  //             items: item.map((groupName) {
                  //               return DropdownMenuItem<String>(
                  //                 value: groupName,
                  //                 child: Text(groupName,style: cardTextWriteTitle,),
                  //               );
                  //             }).toList(),
                  //             onChanged: (value) {
                  //               setState(() {
                  //                selected = value;
                  //               });
                  //             },
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //   },
                  // ),
                  // if (isSubmittedGroup == true && state.selectedGrpCode == null)
                  //    Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: Container(
                  //       alignment: Alignment.topLeft,
                  //       child: const Text(
                  //         'Please select group',
                  //         style: TextStyle(color: Colors.red,  fontFamily: 'Montserrat Regular',fontSize: 12.0),
                  //       ),
                  //     ),
                  //   ),

                  Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        value: state.selectedGrpCode,
                        isDense: true,
                        isExpanded: true,
                        hint: Text(
                          'Select product group',
                          style: cardTextWriteTitle,
                        ),
                        items: productState.groupList.map((item) => DropdownMenuItem(
                          value: item.groupName,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0)),
                                color: Colors.grey[200],
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
                                  Text(item.groupName, style: cardTextStyleDropDownHeader,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                            .toList(),
                        // Custom display of the selected item
                        selectedItemBuilder: (BuildContext context) {
                          return productState.groupList.map((party) {
                            return Text(party.groupName, style: cardTextStyleProductHeader,);
                          }).toList();
                        },
                        onChanged: (value) {
                          setState(() {
                                            state.selectedGrpCode = value;
                                            isSubmittedGroup = false;
                            // state.selectedGrpCode = value;
                            // isSubmittedLedgerType = false;
                          });
                        },

                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
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
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 400,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 60,
                          padding: EdgeInsets.only(left: 8, right: 8),
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
                                hintText: 'Search for ledger...',
                                hintStyle: const TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 1),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            String itemValue = item.value.toString();
                            String lowercaseItemValue =
                            itemValue.toLowerCase();
                            String uppercaseItemValue =
                            itemValue.toUpperCase();

                            String lowercaseSearchValue =
                            searchValue.toLowerCase();
                            String uppercaseSearchValue =
                            searchValue.toUpperCase();

                            return lowercaseItemValue
                                .contains(lowercaseSearchValue) ||
                                uppercaseItemValue
                                    .contains(uppercaseSearchValue) ||
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
                    ),
                  ),
                  if (isSubmittedGroup == true &&
                      state.selectedGrpCode == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Please select ledger type',
                          style: TextStyle(color: Colors.red, fontSize: 12.0),
                        ),
                      ),
                    ),

                  const SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: state.purchaseRate,
                      keyboardType: TextInputType.number,
                      style: cardTextWriteTitle,
                      cursorColor: Colors.orange,
                      cursorHeight: 20,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                        // Limit to 10 characters
                      ],
                      decoration: InputDecoration(
                        hintText: "Purchase Rate",
                        //  prefixIcon: const Icon(Icons.mobile_screen_share_outlined),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: const BorderSide(color: Colors.orange, width: 1),
                        ),
                        errorBorder: state.purchaseRate.text.isEmpty
                            ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide:
                          const BorderSide(color: Colors.red, width: 1),
                        )
                            : null,
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Please enter Purchase Rate';
                      //   }
                      //   else if(value[0] == "0")
                      //   {
                      //     return 'Cannot Begin with Zero';
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: state.salesRate,
                      keyboardType: TextInputType.number,
                      style: cardTextWriteTitle,
                      cursorColor: Colors.orange,
                      cursorHeight: 20,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                        // Limit to 10 characters
                      ],
                      decoration: InputDecoration(
                        hintText: "Sales Rate",
                        // prefixIcon: const Icon(Icons.people_sharp),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: const BorderSide(color: Colors.orange, width: 1),
                        ),
                        errorBorder: state.salesRate.text.isEmpty
                            ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide:
                          const BorderSide(color: Colors.red, width: 1),
                        )
                            : null,
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Please enter Sales Rate';
                      //   }
                      //   else if(value[0] == "0")
                      //   {
                      //     return 'Cannot Begins with Zero';
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  // FutureBuilder<List<ProductDataModel>>(
                  //   future: state.getDataUnitList(),
                  //   builder: (context, snapshot,) {
                  //   if (snapshot.hasError) {
                  //       return Center(child: Text('Error: ${snapshot.error}'));
                  //     } else if (snapshot.hasData) {
                  //       List<ProductDataModel> unitList = snapshot.data!;
                  //       Set<String> uniqueUnitNames = unitList.map((product) => product.unit.toString()).toSet();
                  //       return Container(
                  //         height: 50,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           border: Border.all(color: Colors.grey, width: 1),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: DropdownButton<String>(
                  //             value: state.selectedUnit,
                  //             hint:  Text('Select Unit',style: cardTextWriteTitle,),
                  //             isExpanded: true,
                  //             icon: const Icon(Icons.keyboard_arrow_down),
                  //             style: const TextStyle(color: Colors.black),
                  //             underline: Container(
                  //               height: 0.0,
                  //             ),
                  //             items: uniqueUnitNames.map((unit) {
                  //               return DropdownMenuItem<String>(
                  //                 value: unit,
                  //                 child: Text(unit,style: cardTextWriteTitle,),
                  //               );
                  //             }).toList(),
                  //             onChanged: (value) {
                  //               setState(() {
                  //                 state.selectedUnit = value;
                  //                 isSubmittedUnit = false;
                  //               });
                  //             },
                  //           ),
                  //         ),
                  //       );
                  //     } else {
                  //       return  Container(
                  //         height: 50,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           border: Border.all(color: Colors.grey, width: 1),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: DropdownButton<String>(
                  //             value: selected,
                  //             hint:  Text('Select Unit',style: cardTextWriteTitle,),
                  //             isExpanded: true,
                  //             icon: const Icon(Icons.keyboard_arrow_down),
                  //             style: const TextStyle(color: Colors.black),
                  //             underline: Container(
                  //               height: 0.0,
                  //             ),
                  //             items: item.map((groupName) {
                  //               return DropdownMenuItem<String>(
                  //                 value: groupName,
                  //                 child: Text(groupName,style: cardTextWriteTitle,),
                  //               );
                  //             }).toList(),
                  //             onChanged: (value) {
                  //               setState(() {
                  //                 selected = value;
                  //
                  //               });
                  //             },
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //   },
                  // ),



                  Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        value: state.selectedUnit,
                        isDense: true,
                        isExpanded: true,
                        hint: Text(
                          'Select Unit',
                          style: cardTextWriteTitle,
                        ),
                        items: productState.unitList.map((item) => DropdownMenuItem(
                          value: item.unit,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0)),
                                color: Colors.grey[200],
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
                                  Text(item.unit, style: cardTextStyleDropDownHeader,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                            .toList(),
                        // Custom display of the selected item
                        selectedItemBuilder: (BuildContext context) {
                          return productState.unitList.map((party) {
                            return Text(party.unit, style: cardTextStyleProductHeader,);
                          }).toList();
                        },
                        onChanged: (value) {
                          setState(() {
                            state.selectedUnit = value;
                            isSubmittedUnit = false;
                          });
                        },

                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
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
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 400,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 60,
                          padding: EdgeInsets.only(left: 8, right: 8),
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: textEditingUnitController,
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
                              controller: textEditingUnitController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Search for ledger...',
                                hintStyle: const TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 1),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            String itemValue = item.value.toString();
                            String lowercaseItemValue =
                            itemValue.toLowerCase();
                            String uppercaseItemValue =
                            itemValue.toUpperCase();

                            String lowercaseSearchValue =
                            searchValue.toLowerCase();
                            String uppercaseSearchValue =
                            searchValue.toUpperCase();

                            return lowercaseItemValue
                                .contains(lowercaseSearchValue) ||
                                uppercaseItemValue
                                    .contains(uppercaseSearchValue) ||
                                itemValue.contains(searchValue);
                          },
                        ),
                        //This to clear the search value when you close the menu
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            textEditingUnitController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                  if (isSubmittedUnit == true &&
                      state.selectedUnit == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Please select ledger type',
                          style: TextStyle(color: Colors.red, fontSize: 12.0),
                        ),
                      ),
                    ),

                  const SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    //height: 50, // Set the height as per your requirement
                    child: SaveButton(
                      buttonName: "Create Product",
                      padding: 12,
                      onClick: () async {
                        if (state.productName.text.isNotEmpty && state.selectedGrpCode != null && state.selectedUnit != null) {
                          await state.sendPostRequest();
                          state.productName.text = "";
                          state.selectedGrpCode = null;
                          state.purchaseRate.text = "";
                          state.salesRate.text = "";
                          state.selectedUnit = null;
                          setState(() {
                          });
                        } else {
                          FocusScope.of(context).requestFocus(nodeOne);
                          setState(() {
                            isSubmittedProduct = true;
                            isSubmittedGroup = true;
                            isSubmittedUnit = true;
                          });
                          ShowToast.errorToast(msg: "Please enter required field");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}