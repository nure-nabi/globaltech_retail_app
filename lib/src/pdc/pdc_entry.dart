
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/branch/branch_state.dart';
import 'package:retail_app/src/pdc/state/pdc_entries_state.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import '../../services/sharepref/set_all_pref.dart';
import '../../themes/colors.dart';
import '../../utils/custom_date_picker.dart';
import '../../utils/loading_indicator.dart';
import '../imagepicker/image_picker_screen.dart';
import 'model/bank_model.dart';



class PDCEntriesScreen extends StatefulWidget {
  const PDCEntriesScreen({super.key});

  @override
  State<PDCEntriesScreen> createState() => _PDCEntriesScreenState();
}

class _PDCEntriesScreenState extends State<PDCEntriesScreen> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Provider.of<BranchState>(context, listen: false).context = context;
    Provider.of<PDCEntriesState>(context, listen: false).getContext = context;
  }
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer2<PDCEntriesState,BranchState>(builder: (context, state,providerBranch, child) {
      return Stack(children: [
        Scaffold(
          appBar: AppBar(title: const Text("PDC Entry")),
          body: Form(
            key: state.validateKey,
            child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                children: [
                  const SizedBox(height: 20.0),

                  if (state.bankList.isNotEmpty)
                    Visibility(
                      visible: state.isBankLoading,
                      replacement: CustomDropdown<BankListModel>.search(
                        hintText: 'Choose BANK',
                        items: state.bankList,
                        excludeSelected: false,
                        listItemBuilder: (_, item, isSelected, onItemSelect) {
                          return Text(item.bankName);
                        },
                        headerBuilder: (_, item,bool) {
                          return Text(item.bankName);
                        },
                        overlayHeight: 400,
                        onChanged: (value) {
                          state.validateKey.currentState!.validate();
                          state.getBankName = value!.bankName;
                        },
                      ),
                      // replacement: CustomSearchableDropDown(
                      //   items: state.bankList,
                      //   label: 'Choose BANK',
                      //   decoration: ContainerDecoration.decoration(
                      //     color: Colors.white,
                      //     bColor: Colors.white,
                      //   ),
                      //   prefixIcon: const Padding(
                      //     padding: EdgeInsets.all(0.0),
                      //     child: Icon(Icons.search),
                      //   ),
                      //   dropDownMenuItems: state.bankList.map((item) {
                      //     return item.bankName;
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     if (value != null) {
                      //       state.validateKey.currentState!.validate();
                      //       state.getBankName = value!.bankName;
                      //     } else {
                      //       state.getBankName = "";
                      //     }
                      //   },
                      // ),

                      child: const Center(child: CircularProgressIndicator()),
                    ),

                  // ///
                  // state.isBankLoading
                  //     ? const Center(child: CircularProgressIndicator())
                  //     : CustomSearchableDropDown(
                  //         items: state.bankList,
                  //         label: 'Choose BANK',
                  //         decoration: ContainerDecoration.decoration(
                  //           color: Colors.white,
                  //           bColor: Colors.white,
                  //         ),
                  //         prefixIcon: const Padding(
                  //           padding: EdgeInsets.all(0.0),
                  //           child: Icon(Icons.search),
                  //         ),
                  //         dropDownMenuItems: state.bankList.map((item) {
                  //           return item.bankName;
                  //         }).toList(),
                  //         onChanged: (value) {
                  //           if (value != null) {
                  //             state.validateKey.currentState!.validate();
                  //             state.getBankName = value!.bankName;
                  //           } else {
                  //             state.getBankName = "";
                  //           }
                  //         },
                  //       ),
                  ///
                  ///
                  ///
                  ///
                  // : CustomDropDown<BankListModel>(
                  //     items: state.bankList
                  //         .map(
                  //           (item) => DropdownMenuItem<BankListModel>(
                  //             value: item,
                  //             child: Text(
                  //               item.bankName,
                  //               style: const TextStyle(fontSize: 14),
                  //             ),
                  //           ),
                  //         )
                  //         .toList(),
                  //     hint: "Select Bank",
                  //     dropdownMaxHeight: 400.0,
                  //     primaryColor: primaryColor,
                  //     borderColor: Colors.grey.shade200,
                  //     onChanged: (BankListModel? value) {
                  //       state.validateKey.currentState!.validate();
                  //       state.getBankName = value!.bankName;
                  //     },
                  //   ),

                  ///
                  TextFormField(
                    controller: state.amount,
                    onChanged: (text) {
                      state.validateKey.currentState!.validate();
                      // state.getAmount = text;
                    },
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return "* Enter Amount";
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: "Amount",
                      prefixIcon: Icon(Icons.attach_money_sharp),
                      hintText: "Amount",
                    ),
                  ),

                  ///
                  TextFormField(
                    controller: state.chequeNo,
                    onChanged: (text) {
                      state.validateKey.currentState!.validate();
                      // state.getChequeNo = text;
                    },
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return "* Enter Cheque Number";
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Cheque Number",
                      prefixIcon: Icon(Icons.attachment),
                      hintText: "Cheque Number",
                    ),
                  ),
                  TextFormField(
                    controller: state.chequeDate,
                    readOnly: true,
                    onTap: () async {
                      state.getChequeDate =
                      await MyDatePicker(context).englishDate();
                      state.validateKey.currentState!.validate();
                    },
                    // onChanged: (text) {
                    //   state.validateKey.currentState!.validate();
                    //   state.getChequeDate = text;
                    // },
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return "* Enter Cheque Date";
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Cheque Date",
                      prefixIcon: Icon(Icons.calendar_month_outlined),
                      hintText: "Cheque Date",
                    ),
                  ),

                  ///
                  TextFormField(
                    controller: state.remarks,
                    onChanged: (text) {
                      state.validateKey.currentState!.validate();
                      // state.getRemark = text;
                    },
                    // validator: (value) {
                    //   if (value!.isNotEmpty) {
                    //     return null;
                    //   } else {
                    //     return "* Enter Remark";
                    //   }
                    // },
                    decoration: const InputDecoration(
                      labelText: "Remark",
                      prefixIcon: Icon(Icons.note_alt_outlined),
                      hintText: "Remark",
                    ),
                  ),

                  const SizedBox(height: 20.0),
                  ///
                  //Branch
                  providerBranch.branchList.isNotEmpty ?
                  Consumer<BranchState>(
                      builder: (BuildContext context, state, Widget? child) {
                        // Ensure that the unitCode is valid before passing it to the dropdown
                        String unitCode = state.unitCode;
                        if (unitCode.isEmpty && state.branchList.isNotEmpty) {
                          // Fallback to the first item if unitCode is empty
                          unitCode = state.branchList[0].unitDesc;
                        }
                        return DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            value: unitCode,
                            isDense: true,
                            isExpanded: true,
                            hint: Text(
                              'Select Unit',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: state.branchList.map<DropdownMenuItem<String>>((party) {
                              return DropdownMenuItem<String>(
                                value: party.unitDesc.toString(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius:   const BorderRadius.all(Radius.circular(12.0)),
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
                                        Text(party.unitDesc.toString()),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),

                            // Custom display of the selected item
                            selectedItemBuilder: (BuildContext context) {
                              return state.branchList.map((party)  {
                                return Text(
                                  party.unitDesc,
                                );
                              }).toList();
                            },
                            onChanged: (value) {
                              setState(() async {
                                state.getUnitDesc = value.toString();
                                state.setSelectBranch = true;
                                //  state.getStatus = true;
                               // await SetAllPref.setBranchName(value: value.toString());

                                int index = state.branchList.indexWhere((party) => party.unitDesc.toString() == value);

                                if (index != -1) {
                                  String selectedGlCode =state.branchList[index].unitCode;
                                  await SetAllPref.setBranch(value: selectedGlCode);
                                   state.getUnitCode = selectedGlCode;

                                  // Fluttertoast.showToast(msg: selectedGlCode);
                                } else {}
                              });
                            },

                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: 350,
                              padding: const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: providerBranch.selectBranch == false ? Colors.red : Colors.black26,
                                ),
                                // color: Colors.redAccent,
                              ),
                              // elevation: 2,
                            ),
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 500,
                            ),
                            menuItemStyleData:  const MenuItemStyleData(
                              height: 60,
                              padding: EdgeInsets.only(left: 14, right: 14),
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
                                    hintText: 'Search unit...',
                                    hintStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
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

                                return lowercaseItemValue
                                    .contains(lowercaseSearchValue) ||
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
                      }) : SizedBox(),
                  const SizedBox(height: 7,),
                  ///
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Checkbox(
                              value: state.isImageAdd,
                              onChanged: (value) {
                                state.getIsImageAdd = value!;
                              },
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Add Image",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (state.isImageAdd)
                        Container(
                          padding: const EdgeInsets.only(
                            bottom: 10.0,
                          ),
                          color: Colors.white,
                          child: const ImagePickerScreen(
                            isHeaderShow: false,
                            isCropperEnable: true,
                          ),
                        )
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  ///
                  providerBranch.selectBranch == false ?
                  const ElevatedButton(
                    onPressed: null,
                    child: Text("CONFIRM"),
                  ) :   ElevatedButton(
                    onPressed: () async {
                      await state.onConfirm(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text("CONFIRM"),
                    ),
                  ) ,
                ]),
          ),
        ),
        if (state.isLoading) LoadingScreen.loadingScreen(),
      ]);
    });
  }
}
