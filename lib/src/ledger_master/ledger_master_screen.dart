import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/constants/text_style.dart';
import 'package:retail_app/src/ledger_master/ledger_master_state.dart';
import 'package:retail_app/themes/colors.dart';
import 'package:retail_app/utils/show_toast.dart';
import 'package:retail_app/widgets/custom_button.dart';

class LedgerMasterScreen extends StatefulWidget {
  const LedgerMasterScreen({super.key});

  @override
  State<LedgerMasterScreen> createState() => _LedgerMasterScreenState();
}

class _LedgerMasterScreenState extends State<LedgerMasterScreen> {
  FocusNode nodeOne = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSubmittedLedgerName = false;
  bool isSubmittedLedgerType = false;
  bool isSubmittedAcountGroup = false;
  final List<String> items = [
    'Customer',
    'Vendor',
    'Cash Bank',
    'Bank Book',
    'Other',
  ];

  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<LedgerMasterState>(context, listen: false).getContext = context;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<LedgerMasterState>(context, listen: false).clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ledger Master',
          style: cardTextStyleHeader,
        ),
      ),
      body: Consumer<LedgerMasterState>(
        builder: (context, state, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: state.outletName,
                        style: cardTextWriteTitle,
                        cursorColor: Colors.orange,
                        cursorHeight: 20,
                        autofocus: true,
                        focusNode: nodeOne,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(21),
                        ],
                        decoration: InputDecoration(
                          hintText: "Ledger Name *",
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: const BorderSide(
                                color: Colors.orange, width: 1),
                          ),
                          errorBorder: state.outletName.text.isEmpty
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1),
                                )
                              : null,
                        ),
                        onChanged: (value) {
                          setState(() {
                            isSubmittedLedgerName = false;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return;
                          }
                          return null;
                        },
                      ),
                    ),
                    if (isSubmittedLedgerName == true &&
                        state.outletName.text.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'Please enter ledger name',
                            style: TextStyle(color: Colors.red, fontSize: 12.0),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isDense: true,
                          isExpanded: true,
                          hint: Text(
                            'Select Ledger Type',
                            style: cardTextWriteTitle,
                          ),
                          items: items.map((item) => DropdownMenuItem(
                                    value: item,
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
                                            Text(item, style: cardTextStyleDropDownHeader,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          // Custom display of the selected item
                          selectedItemBuilder: (BuildContext context) {
                            return items.map((party) {
                              return Text(party, style: cardTextStyleProductHeader,);
                            }).toList();
                          },
                          value: state.selectedGrpCode,
                          onChanged: (value) {
                            setState(() {
                              state.selectedGrpCode = value;
                              isSubmittedLedgerType = false;
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
                    if (isSubmittedLedgerType == true &&
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
                      height: 8,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        value: state.accountGroup,
                        isDense: true,
                        isExpanded: true,
                        hint: Text(
                          'Select Account Group',
                          style: cardTextWriteTitle,
                        ),
                        items: state.accountGroupList.map<DropdownMenuItem<String>>(
                            (party) {
                          return DropdownMenuItem<String>(
                            value: party.grpDesc.toString(),
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
                                    Text(
                                      party.grpDesc.toString(),
                                      style: cardTextStyleDropDownHeader,
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),

                        // Custom display of the selected item
                        selectedItemBuilder: (BuildContext context) {
                          return state.accountGroupList.map((party) {
                            return Text(party.grpDesc, style: cardTextStyleProductHeader,);
                          }).toList();
                        },

                        onChanged: (value) {
                          setState(() async {
                            state.getAccountGroup = value.toString();
                            isSubmittedAcountGroup = false;

                          //  state.getStatus = true;
                         //  await SetAllPref.customerName(value: value.toString());
                            int index = state.accountGroupList.indexWhere(
                                (party) => party.grpDesc.toString() == value);
                            if (index != -1) {
                              String selectedGlCode = state.accountGroupList[index].grpCode;
                              state.selectedAccountGrpCode = selectedGlCode;
                             // await SetAllPref.outLetCode(value: selectedGlCode);
                              // Fluttertoast.showToast(msg: selectedGlCode);
                            } else {}
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
                                hintText: 'Search for account group...',
                                hintStyle: const TextStyle(fontSize: 12),
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
                            String lowercaseItemValue = itemValue.toLowerCase();
                            String uppercaseItemValue = itemValue.toUpperCase();

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
                    if (isSubmittedAcountGroup == true && state.accountGroup == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'Please select account list ',
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
                        controller: state.address,
                        style: cardTextWriteTitle,
                        cursorColor: Colors.orange,
                        cursorHeight: 20,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(21),
                          // Limit to 10 characters
                        ],
                        decoration: InputDecoration(
                          hintText: "Address",
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: const BorderSide(
                                color: Colors.orange, width: 1),
                          ),
                          errorBorder: state.address.text.isEmpty
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1),
                                )
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: state.phone,
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
                          hintText: "Phone ",
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: const BorderSide(
                                color: Colors.orange, width: 1),
                          ),
                          errorBorder: state.phone.text.isEmpty
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1),
                                )
                              : null,
                        ),
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter customer name';
                        //   } else if (value.length != 10) {
                        //     return 'Phone number must be 10 digits';
                        //   } else if (!RegExp(r'^98').hasMatch(value)) {
                        //     return 'Phone number must start with 98';
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
                        controller: state.panNo,
                        keyboardType: TextInputType.number,
                        style: cardTextWriteTitle,
                        cursorColor: Colors.orange,
                        cursorHeight: 20,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                        ],
                        decoration: InputDecoration(
                          hintText: "Pan No",
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: const BorderSide(
                                color: Colors.orange, width: 1),
                          ),
                          errorBorder: state.panNo.text.isEmpty
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1),
                                )
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          } else if (value.length != 9) {
                            return 'Pan No must be 9 digits';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: state.email,
                        style: cardTextWriteTitle,
                        cursorColor: Colors.orange,
                        cursorHeight: 20,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(32),
                          // Limit to 10 characters
                        ],
                        decoration: InputDecoration(
                          hintText: "Email",
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: const BorderSide(
                                color: Colors.orange, width: 1),
                          ),
                          errorBorder: state.email.text.isEmpty
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1),
                                )
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          } else if (!EmailValidator.validate(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: state.contactPerson,
                        style: cardTextWriteTitle,
                        cursorColor: Colors.orange,
                        cursorHeight: 20,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(21),
                        ],
                        decoration: InputDecoration(
                          hintText: "Contact Person",
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                            borderSide: const BorderSide(
                                color: Colors.orange, width: 1),
                          ),
                          errorBorder: state.email.text.isEmpty
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1),
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      height: 50, // Set the height as per your requirement
                      child: SaveButton(
                        buttonName: "CREATE LEDGER",
                        onClick: () async {
                          if (state.outletName.text.isNotEmpty &&
                              state.selectedGrpCode != null && state.accountGroup != null) {
                            await state.sendPostRequest();
                            state.outletName.text = "";
                            state.selectedGrpCode = null;
                            state.getAccountGroup = null;
                            state.address.text = "";
                            state.panNo.text = "";
                            state.phone.text = "";
                            state.email.text = "";
                            state.contactPerson.text = "";
                            setState(() {});
                          } else {
                            setState(() {
                              isSubmittedLedgerName = true;
                              isSubmittedLedgerType = true;
                              isSubmittedAcountGroup = true;
                            });
                            FocusScope.of(context).requestFocus(nodeOne);
                            ShowToast.errorToast(
                              msg: "Please enter required field",
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
