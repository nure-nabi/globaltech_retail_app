import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/master/master_state.dart';
import 'package:retail_app/src/master/model/group_model.dart';
import 'package:retail_app/themes/colors.dart';
import 'package:retail_app/utils/show_toast.dart';
import 'package:retail_app/widgets/custom_button.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});
  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MaterState>(context, listen: false).getContext = context;
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<MaterState>(context, listen: false).clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledger Master'),
      ),
      body: Consumer<MaterState>(
        builder: (context, state, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[

                  const SizedBox(
                    height: 8.0,
                  ),
                  FutureBuilder<List<GroupDataModel>>(
                    future: state.getDataList(),
                    builder: (context, snapshot,) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.8), // Semi-transparent white background
                            ),
                            child: CircularProgressIndicator(
                              // Customize the appearance here
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal), // Adjust color
                              strokeWidth: 5, // Adjust thickness
                              backgroundColor: Colors.teal.withOpacity(0.2), // Add a subtle background
                            ),
                          ),
                        );
                      }
                      else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        List<GroupDataModel> groupList = snapshot.data!;
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: primaryColor, width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<String>(
                              value: state.selectedGrpCode,
                              hint: const Text('Select Group'),
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 0.0,
                              ),
                              items: groupList.map((group) {
                                return DropdownMenuItem<String>(
                                  value: group.grpDesc.toString(),
                                  child: Text(group.grpDesc.toString()),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  state.selectedGrpCode = value;
                                });
                              },
                            ),
                          ),
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  DropdownButtonFormField<String>(
                    value: state.categorydropdownvalue,
                    hint: const Text('Select Category'),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: InputDecoration(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15.0),
                      hintText: "Select an Option",
                      hintStyle: const TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide(color: primaryColor, width: 2.5),
                      ),
                    ),
                    items: state.categoryitems.map((String item) {
                      // Use item instead of items
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        state.categorydropdownvalue = newValue!;
                      });
                    },
                    style: const TextStyle(
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    controller: state.customerName,
                    style: const TextStyle(color: Colors.black),
                    cursorColor: primaryColor,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(28), // Limit to 10 characters
                    ],
                    decoration: InputDecoration(
                      hintText: "Customer Name *",
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide(color: primaryColor, width: 2.5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    controller: state.panNo,
                    keyboardType:TextInputType.number ,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9), // Limit to 10 characters
                    ],
                    style: const TextStyle(color: Colors.black),
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: "Pan",
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide(color: primaryColor, width: 2.5),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 8.0,
                  // ),
                  // TextFormField(
                  //   controller: state.contactPerson,
                  //   style: const TextStyle(color: Colors.black),
                  //   cursorColor: primaryColor,
                  //   decoration: InputDecoration(
                  //     hintText: "Contact Person",
                  //     filled: true,
                  //     fillColor: Colors.white,
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(14.0),
                  //       borderSide: const BorderSide(color: Colors.grey),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(14.0),
                  //       borderSide: BorderSide(color: primaryColor, width: 2.5),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    controller: state.customerCode,
                    style: const TextStyle(color: Colors.black),
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: "Customer Code *",
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide(color: primaryColor, width: 2.5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    controller: state.mobileNo,
                    keyboardType:TextInputType.number ,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10), // Limit to 10 characters
                    ],
                    style: const TextStyle(color: Colors.black),
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: "Mobile No",
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide(color: primaryColor, width: 2.5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    controller: state.email,
                    style: const TextStyle(color: Colors.black),
                    cursorColor: primaryColor,
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
                        borderSide: BorderSide(color: primaryColor, width: 2.5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 50, // Set the height as per your requirement
                    child: SaveButton(
                      buttonName: "CREATE LEDGER",
                      onClick: () async {
                        if(state.customerName.text.isNotEmpty &&  state.customerCode.text.isNotEmpty)
                        {
                          await state.sendPostRequest();
                        }
                        else{
                          ShowToast.errorToast(msg: "Please enter required field");
                        }
                      },

                      // onClick: () async {
                      //   if(state.productName.text.isNotEmpty && state.purchaseRate.text.isNotEmpty && state.salesRate.text.isNotEmpty){
                      //     await state.sendPostRequest();
                      //   }
                      //   else{
                      //     Fluttertoast.showToast(msg: "Please Endert required field!");
                      //   }
                      //
                      // },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}