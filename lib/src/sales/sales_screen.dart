import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/sales/components/sales_order_list.dart';
import 'package:retail_app/src/sales/sales_state.dart';

import '../../constants/text_style.dart';
import '../../themes/themes.dart';
import '../../widgets/imageviewer/memory_image_viewer.dart';
import '../../widgets/widgets.dart';
import '../products/components/product_list_screen.dart';
import '../sales_bill_term/model/sales_bill_term_model.dart';
import '../sales_bill_term/sales_bill_term_state.dart';

class ProductOrderScreen extends StatefulWidget {
  const ProductOrderScreen({super.key});

  @override
  State<ProductOrderScreen> createState() => _ProductOrderScreenState();
}

class _ProductOrderScreenState extends State<ProductOrderScreen> {
  List<TextEditingController> _controllers = [] ;
  List<TextEditingController> _controllersAmount = [] ;
  double value = 0.00;
  @override
  void initState() {
    super.initState();
    Provider.of<ProductOrderState>(context, listen: false).getContext = context;
    Provider.of<SalesTermState>(context, listen: false).getContext = context;
    Provider.of<ProductOrderState>(context, listen: false).getAllTempProductOrderList();
    Provider.of<SalesTermState>(context, listen: false).termSelected("Product");
  }

  // Future alertDialog( List<SalesBillTermDataModel> list, SalesTermState state2) {
  //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //   String _textValue = '';
  //   List<TextEditingController> _controller = [];
  //   return  showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       final state = context.watch<ProductOrderState>();
  //       return AlertDialog(
  //         title: Text('Product Term'),
  //         content: Form(
  //           key: _formKey,
  //           child: Container(
  //             height: 200, // Adjust height as needed
  //             width: double.maxFinite,
  //             child: Expanded(
  //               child: ListView.builder(
  //                 itemCount: list.length,
  //                   itemBuilder: (context, index){
  //                     return Container(
  //                       alignment: Alignment.center,
  //                       child: Row(
  //                         children: [
  //                           Expanded(child: Container(
  //                             child: Text(list[index].pTDesc,style: TextStyle(fontWeight: FontWeight.w500),),
  //                           )),
  //                           Expanded(child: Container (
  //                             child: TextFormField(
  //
  //                               maxLength: 2,
  //                               //controller: state.discountRate,
  //                               onTap: () {
  //                               //  state.discountRate.text = "dsfg";
  //                               //  state.getDiscountAmt = "";
  //
  //                               },
  //
  //                               onChanged: (value) {
  //                               //  state.orderFormKey.currentState!
  //                               //      .validate();
  //                                // value = double.parse(state.calculateTotalAmount());
  //
  //                               //  _textValue.add(value);
  //                                 state.getDiscountRate = _textValue[1];
  //                                 //state.getDiscountAmount = _textValue[1];
  //
  //
  //
  //                             //    Fluttertoast.showToast(msg: _textValue[0].toString());
  //                                // _textValue = value;
  //                               //  state.calculate();
  //
  //                             //    state.calculateBillTerm();
  //                                 setState(() {
  //
  //                                 });
  //                               },
  //                               keyboardType: TextInputType.number,
  //                               decoration: InputDecoration(
  //                                 filled: true,
  //                                 counter: const Offstage(),
  //                                 isDense: true,
  //                                 hintText: "",
  //                                 labelStyle: const TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   fontSize: 14.0,
  //                                 ),
  //                                 contentPadding:
  //                                 const EdgeInsets.all(10.0),
  //                                 focusedBorder: OutlineInputBorder(
  //                                   borderRadius:
  //                                   BorderRadius.circular(5.0),
  //                                   borderSide: BorderSide(
  //                                     color: primaryColor,
  //                                   ),
  //                                 ),
  //                                 enabledBorder: OutlineInputBorder(
  //                                   borderRadius:
  //                                   BorderRadius.circular(5.0),
  //                                   borderSide: BorderSide(
  //                                     color: Colors.grey.shade300,
  //                                   ),
  //                                 ),
  //                                 border: OutlineInputBorder(
  //                                   borderRadius:
  //                                   BorderRadius.circular(5.0),
  //                                 ),
  //                               ),
  //                             ),
  //                           )),
  //                           SizedBox(width: 5,),
  //
  //                         ],
  //                       ),
  //
  //                     );
  //                   }
  //               ),
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               // Navigator.pushReplacement(
  //               //   context,
  //               //   MaterialPageRoute(builder: (context) => ProductListScreen()),
  //               // );
  //
  //
  //             },
  //             child: Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //
  // }

  @override
  Widget build(BuildContext context) {
    final state2 = context.watch<SalesTermState>();
    final state = context.watch<ProductOrderState>();

    final stateSalesTerm = context.watch<SalesTermState>();
    for(int i=0; i<stateSalesTerm.termList.length; i++){
      _controllers.add(TextEditingController());
      _controllersAmount.add(TextEditingController());
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemoryImageViewer(
                    imageList: [
                      state.productDetail.pImage,
                      // AssetsList.errorBase64Image
                    ],
                  ),
                ),
              );
            },
            child: Visibility(
              visible: false,
              child: Container(
                color: Colors.white,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Visibility(
                      visible: false,
                      child: Center(
                        child: Image.memory(
                          base64Decode(state.productDetail.pImage),
                          height: 120.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemoryImageViewer(
                              imageList: [
                                state.productDetail.pImage,
                                // AssetsList.errorBase64Image
                              ],
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.visibility,
                        color: successColor,
                        size: 40.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          StatefulBuilder(
            builder: (context, void Function(void Function()) setState) {

              return CustomAlertWidget(
                title: state.productDetail.pDesc,
                child: Form(
                  key: state.orderFormKey,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        verticalSpace(10.0),

                        RowDataWidget(
                          valueFlex: 2,
                          title: "Code",
                          titleBold: true,
                          valueBold: true,
                          value: state.productDetail.pShortName.isNotEmpty
                              ? state.productDetail.pShortName
                              : state.productDetail.pCode,
                        ),
                        RowDataWidget(
                          valueFlex: 2,
                          title: "Group",
                          titleBold: true,
                          valueBold: true,
                          value: state.productDetail.groupName,
                        ),
                        RowDataWidget(
                          valueFlex: 2,
                          title: "Buy Rate",
                          titleBold: true,
                          valueBold: true,
                          value: state.productDetail.buyRate,
                        ),

                        Divider(color: hintColor),

                        Container(
                          margin: const EdgeInsets.all(3.0),
                          child: Row(children: [
                            const Expanded(
                              flex: 2,
                              child: Text(
                                "Quantity",
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                            const Expanded(

                              child: Text(' : ',
                                  textAlign: TextAlign.center),
                            ),
                            Expanded(
                              flex: 5,
                              child: TextFormField(
                                controller: state.quantity,
                                onTap: () async {
                                  state.quantity.text = "";

                                },
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      state.quantity.text == "0.00") {
                                    return "";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (text) async {
                                  // state.orderFormKey.currentState!
                                  // .validate();
                                  state.calculate();
                                  state.calculateProductQty();
                                  setState(() {});
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,3}')),
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  counter: const Offstage(),
                                  isDense: true,
                                  hintText: "",
                                  labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                  contentPadding:
                                  const EdgeInsets.all(10.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),

                        Container(
                          margin: const EdgeInsets.all(3.0),
                          child: Row(children: [
                            const Expanded(
                              flex: 2,
                              child: Text(
                                "Sales Rate",
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                            const Expanded(
                                child: Text(' : ',
                                    textAlign: TextAlign.center)),
                            Expanded(
                              flex: 5,
                              child: TextFormField(
                                controller: state.salesRate,
                                onTap: () {
                                  state.salesRate.text = "";
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (text) {
                                  state.orderFormKey.currentState!
                                      .validate();

                                  state.calculate();
                                  state.calculateProductQty();
                                  setState(() {});
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  counter: const Offstage(),
                                  isDense: true,
                                  hintText: "",
                                  labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                  contentPadding:
                                  const EdgeInsets.all(10.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Row(children: [
                          const Expanded(
                              flex: 2,
                              child: Text(
                                "Amount",
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              )),
                          const Expanded(
                              child: Text(' : ',
                                  textAlign: TextAlign.center)),
                          Expanded(
                              flex: 5,
                              child: Text(
                                state.totalSalesPrice.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ]),

                        SizedBox(height: 5,),
                        stateSalesTerm.termList.isNotEmpty ?
                        SizedBox(
                          height: 120, // Adjust height as needed
                          width: double.maxFinite,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    itemCount: stateSalesTerm.termList.length,
                                    itemBuilder: (context, index){
                                      // _controllers[0].text = "";
                                      // _controllers[1].text = "";
                                      // _controllersAmount[0].text = "";
                                      //  _controllersAmount[1].text = "";

                                      return Container(
                                        alignment: Alignment.center,
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex:2,
                                                child: Container(
                                                  child: Text(stateSalesTerm.termList[index].pTDesc,style: TextStyle(fontSize: 14.0),),
                                                )),

                                            Expanded(
                                                flex:1,
                                                child: Container (
                                                  child: TextFormField(
                                                    maxLength: 2,
                                                    controller: _controllers[index],
                                                    onTap: () {

                                                    },

                                                    onChanged: (value) {
                                                      state.orderFormKey.currentState!
                                                          .validate();

                                                      if(index == 0)
                                                      {
                                                        if(stateSalesTerm.termList[index].sign == "-"){
                                                          double netTotalAmount = 0.00;
                                                          String disValue = value;
                                                          netTotalAmount = state.totalProductPrice;
                                                          if(value == ""){
                                                            disValue ="0";
                                                          }
                                                          double disAmt = (netTotalAmount * double.parse(disValue) /100);
                                                          double totalAmt = netTotalAmount - disAmt;
                                                          double netAmt =  netTotalAmount - totalAmt;
                                                          _controllersAmount[0].text = netAmt.toStringAsFixed(2);
                                                          state.getPTerm1Rate = double.parse(disValue);
                                                          if(state.PTerm1Rate == 0.0) {
                                                            state.getPTerm1Amount =  double.parse(_controllersAmount[0].text);
                                                          }else{
                                                            state.getPTerm1Amount = netAmt;
                                                          }
                                                          state.getPTerm1Code = stateSalesTerm.termList[index].pTCode;
                                                          state.getSign1 = stateSalesTerm.termList[index].sign;
                                                        }else  if(stateSalesTerm.termList[index].sign == "+"){
                                                          double netTotalAmount = 0.00;
                                                          String disValue = value;
                                                          netTotalAmount = state.totalProductPrice;
                                                          if(value == ""){
                                                            disValue ="0";
                                                          }
                                                          double disAmt = (netTotalAmount * double.parse(disValue) /100);
                                                          double totalAmt = netTotalAmount - disAmt;
                                                          double netAmt =  netTotalAmount - totalAmt;
                                                          _controllersAmount[0].text = netAmt.toStringAsFixed(2);
                                                          state.getPTerm1Rate = double.parse(disValue);
                                                          state.getPTerm1Amount = netAmt;
                                                          state.getPTerm1Code = stateSalesTerm.termList[index].pTCode;
                                                          state.getSign1 = stateSalesTerm.termList[index].sign;
                                                        }



                                                      } else if(index == 1){
                                                     //   state.calculate();

                                                        if(stateSalesTerm.termList[index].sign == "-"){
                                                          double netTotalAmount = 0.00;
                                                          String disValue = value;
                                                          netTotalAmount = state.totalProductPrice;
                                                          if(value == ""){
                                                            disValue ="0";
                                                          }
                                                          double disAmt = (netTotalAmount * double.parse(disValue) /100);
                                                          double totalAmt = netTotalAmount - disAmt;
                                                          double netAmt =  netTotalAmount - totalAmt;
                                                          _controllersAmount[1].text = netAmt.toStringAsFixed(2);
                                                          state.getPTerm2Rate = double.parse(disValue);
                                                          if(state.PTerm2Rate == 0.0) {
                                                            state.getPTerm2Amount =  double.parse(_controllersAmount[1].text);
                                                          }else{
                                                            state.getPTerm2Amount = netAmt;
                                                          }
                                                          state.getPTerm2Code = stateSalesTerm.termList[index].pTCode;
                                                          state.getSign2 = stateSalesTerm.termList[index].sign;
                                                        }else  if(stateSalesTerm.termList[index].sign == "+"){
                                                          double netTotalAmount = 0.00;
                                                          String disValue = value;
                                                          netTotalAmount = state.totalProductPrice;
                                                          if(value == ""){
                                                            disValue ="0";
                                                          }
                                                          double disAmt = (netTotalAmount * double.parse(disValue) /100);
                                                          double totalAmt = netTotalAmount - disAmt;
                                                          double netAmt =  netTotalAmount - totalAmt;
                                                          _controllersAmount[1].text = netAmt.toStringAsFixed(2);
                                                          state.getPTerm2Rate = double.parse(disValue);
                                                          state.getPTerm2Amount = netAmt;
                                                          state.getPTerm2Code = stateSalesTerm.termList[index].pTCode;
                                                          state.getSign2 = stateSalesTerm.termList[index].sign;
                                                        }


                                                      } else if(index == 2){

                                                        if(stateSalesTerm.termList[index].sign == "-"){
                                                          double netTotalAmount = 0.00;
                                                          String disValue = value;
                                                          netTotalAmount = state.totalProductPrice;
                                                          if(value == ""){
                                                            disValue ="0";
                                                          }
                                                          double disAmt = (netTotalAmount * double.parse(disValue) /100);
                                                          double totalAmt = netTotalAmount - disAmt;
                                                          double netAmt =  netTotalAmount - totalAmt;
                                                          _controllersAmount[2].text = netAmt.toStringAsFixed(2);
                                                          state.getPTerm3Rate = double.parse(disValue);
                                                          if(state.PTerm3Rate == 0.0) {
                                                            state.getPTerm3Amount =  double.parse(_controllersAmount[2].text);
                                                          }else{
                                                            state.getPTerm3Amount = netAmt;
                                                          }
                                                          state.getPTerm3Code = stateSalesTerm.termList[index].pTCode;
                                                          state.getSign3 = stateSalesTerm.termList[index].sign;
                                                        } else  if(stateSalesTerm.termList[index].sign == "+"){
                                                          double netTotalAmount = 0.00;
                                                          String disValue = value;
                                                          netTotalAmount = state.totalProductPrice;
                                                          if(value == ""){
                                                            disValue ="0";
                                                          }
                                                          double disAmt = (netTotalAmount * double.parse(disValue) /100);
                                                          double totalAmt = netTotalAmount - disAmt;
                                                          double netAmt =  netTotalAmount - totalAmt;
                                                          _controllersAmount[2].text = netAmt.toStringAsFixed(2);
                                                          state.getPTerm3Rate = double.parse(disValue);
                                                          state.getPTerm3Amount = netAmt;
                                                          state.getPTerm3Code = stateSalesTerm.termList[index].pTCode;
                                                          state.getSign3 = stateSalesTerm.termList[index].sign;
                                                        }


                                                      }
                                                      state.calculate();
                                                      setState(() {

                                                      });
                                                    },
                                                    keyboardType: TextInputType.number,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      counter: const Offstage(),
                                                      isDense: true,
                                                      hintText: "",
                                                      labelStyle: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14.0,
                                                      ),
                                                      contentPadding:
                                                      const EdgeInsets.all(10.0),

                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(5.0),
                                                        borderSide: BorderSide(
                                                          color: primaryColor,
                                                        ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(5.0),
                                                        borderSide: BorderSide(
                                                          color: Colors.grey.shade300,
                                                        ),
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                            SizedBox(width: 10,),
                                            Expanded(
                                                flex:2,
                                                child: Container (
                                                  child: TextFormField(

                                                    controller: _controllersAmount[index],
                                                    onTap: () {},

                                                    validator: (value) {},

                                                    onChanged: (value) {
                                                      state.orderFormKey.currentState!.validate();

                                                      if(index == 0) {
                                                        if(value == ""){
                                                          value ="0";
                                                        }
                                                        state.getPTerm1Amount = double.parse(value);

                                                       // state.getPTerm1Rate = 0.00;
                                                      }else if(index == 1){
                                                          state.getPTerm2Amount = double.parse(value);
                                                          if(value == ""){
                                                            value ="0";
                                                          }
                                                      }else {
                                                          state.getPTerm2Amount = double.parse(value);
                                                          if(value == ""){
                                                            value ="0";
                                                          }
                                                      }
                                                      state.calculate();
                                                      setState(() {

                                                      });
                                                    },
                                                    keyboardType: TextInputType.number,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      counter: const Offstage(),
                                                      isDense: true,
                                                      hintText: "",
                                                      labelStyle: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14.0,
                                                      ),
                                                      contentPadding:
                                                      const EdgeInsets.all(10.0),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(5.0),
                                                        borderSide: BorderSide(
                                                          color: primaryColor,
                                                        ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(5.0),
                                                        borderSide: BorderSide(
                                                          color: Colors.grey.shade300,
                                                        ),
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                            // SizedBox(width: 3,),

                                          ],
                                        ),

                                      );


                                    }
                                ),
                              ),
                            ],
                          ),
                        ):SizedBox(),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Row(children: [
                          const Expanded(
                              flex: 2,
                              child: Text(
                                "Total Amount",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          const Expanded(
                              child: Text(' : ',
                                  textAlign: TextAlign.center)),
                          Expanded(
                              flex: 2,
                              child: Text(
                                state.totalPrice.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ]),

                        Divider(
                          thickness: 1,
                          color: Colors.grey.shade200,
                          height: 10.0,
                        ),

                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: CancleButton(
                                  buttonName: "CANCEL",
                                  onClick: () {
                                    state.getPTerm1Rate = 0.00;
                                    state.getPTerm1Amount = 0.00;
                                    state.getPTerm2Rate = 0.00;
                                    state.getPTerm2Amount = 0.00;
                                    state.getPTerm3Rate = 0.00;
                                    state.getPTerm3Amount = 0.00;
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              horizantalSpace(10.0),
                              Expanded(
                                child: SaveButton(
                                  buttonName: "CONFIRM",
                                  onClick: () async {

                                    if(state.quantity.text.isEmpty){
                                      state.quantity.text = "0.00";
                                    }
                                    if(double.parse(state.quantity.text) > 0) {

                                      await state.saveTempProduct();
                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft,
                                        child: const OrderListSection(),),);
                                    }else{
                                      Fluttertoast.showToast(msg: "Please enter quantity!");
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }


}

class OrderProductShowList extends StatefulWidget {
  final String titleText, detailsText;
  final TextStyle? titleStyle, detailStyle;

  const OrderProductShowList({
    super.key,
    required this.titleText,
    required this.detailsText,
    this.titleStyle,
    this.detailStyle,
  });

  @override
  State<OrderProductShowList> createState() => _OrderProductShowListState();
}

class _OrderProductShowListState extends State<OrderProductShowList> {
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    );
    return widget.detailsText.isEmpty
        ? verticalSpace(0)
        : Container(
            margin: const EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(widget.titleText, style: cardTextStyleProductHeader),
                ),
                Expanded(
                  child: Text(":", style: widget.titleStyle ?? textStyle),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    widget.detailsText.toString(),
                    style: cardTextStyleProductHeader,
                  ),
                ),
              ],
            ),
          );


  }



}
