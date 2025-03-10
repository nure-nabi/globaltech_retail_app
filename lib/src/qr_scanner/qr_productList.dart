
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../services/router/router_name.dart';
import '../../services/sharepref/set_all_pref.dart';
import '../../themes/colors.dart';
import '../../widgets/alert/confirmation_alert.dart';
import '../../widgets/alert/custom_alert.dart';
import '../../widgets/alert/show_alert.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/space.dart';
import '../product_order/db/product_order_db.dart';
import '../product_order/model/product_order_model.dart';
import '../product_order/prodcut_order_screen.dart';
import '../product_order/product_order_state.dart';
import '../products/products_state.dart';
import 'edit_product.dart';
import 'dart:async';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class QRProductListScreen extends StatefulWidget {
   QRProductListScreen({super.key});

  @override
  State<QRProductListScreen> createState() => _QRProductListScreenState();
}

class _QRProductListScreenState extends State<QRProductListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductOrderScanState>(context, listen: false).getContext=context;
  }

  Future<bool> onBackFromTempList() async {
    return await ShowAlert(context).alert(
      child: ConfirmationWidget(
        title: "PLEASE CONFIRM YOUR ORDER !",
        description: "Otherwise all order list will be cleared.",
        onCancel: () async {
          Navigator.pop(context);
        },
        onConfirm: () async {
          await OrderProductDatabase.instance.deleteData().whenComplete(() {
            Navigator.of(context).pushNamedAndRemoveUntil(
              indexPath,
                  (route) => true,
            );
          });
        },
      ),
    );
  }




  String barcode = "value";

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() async {
      barcode = barcodeScanRes;
      await _processQRCode(barcode);
    });
  }

  Future<void> _processQRCode(String code) async {
    final productOrderState = Provider.of<ProductOrderScanState>(context, listen: false);
    productOrderState.checkValue();
    await SetAllPref.setQRData(value: code);
    final state = Provider.of<ProductState>(context, listen: false);

    await state.getQRProductListFromDB(code:code);

    if (!mounted) return;


    if(productOrderState.checkListExits.isNotEmpty){
      _showDialogAlreadyData(context,productOrderState.checkListExits[0].productName);
    }else{
      await sho();
    }

  }

  Future<void> _showOrderAlert(BuildContext context) async {
    final state = Provider.of<ProductState>(context, listen: false);
    final orderState = Provider.of<ProductOrderScanState>(context, listen: false);

    await  orderState.clear();

    final product = state.qrProductList.first;
    orderState.getProductDetails = product;
    orderState.getSalesRate = product.salesRate;
    await ShowAlert(context).alert(child: const ProductOrderScreen());
  }






  sho()async{
    final state = Provider.of<ProductState>(context, listen: false);
    final orderState = Provider.of<ProductOrderScanState>(context, listen: false);

    await  orderState.clear();
    //  await orderState.calculate();
    final product = state.qrProductList.first;
    orderState.getProductDetails = product;
    orderState.getSalesRate = product.salesRate;
    orderState.calculate();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: shooo(),
      ),
    );
  }

  Widget shooo(){
    return Consumer<ProductOrderScanState>(
      builder: (context, state, child) {
        //state.calculate();
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // InkWell(
              //   onTap: () {},
              //   child: Container(
              //     color: Colors.white,
              //     child: Stack(
              //       alignment: Alignment.bottomRight,
              //       children: [
              //         Center(
              //           child: state.productDetail.images.isNotEmpty?Image.network(
              //             state.productDetail.images.first.getImageUrl(),
              //             height: 170.0,
              //             fit: BoxFit.contain,
              //           ):Image.asset('assets/images/ErrorImage.png'),
              //         ),
              //         IconButton(
              //           onPressed: () {},
              //           icon: Icon(
              //             Icons.visibility,
              //             color: successColor,
              //             size: 40.0,
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              StatefulBuilder(
                builder: (context, void Function(void Function()) setState) {
                  return CustomAlertWidget(
                    title: state.productDetail.pDesc,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(5.0),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Form(
                          key: state.orderFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //  verticalSpace(10.0),
                              // RowDataWidget(
                              //   valueFlex: 2,
                              //   title: "PCode",
                              //   titleBold: true,
                              //   valueBold: true,
                              //   value: state.productDetail.pShortName,
                              // ),
                              RowDataWidget(
                                valueFlex: 2,
                                title: "Group",
                                titleBold: true,
                                valueBold: true,
                                value: state.productDetail.groupName,
                              ),
                              RowDataWidget(
                                valueFlex: 2,
                                title: "Sale Rate",
                                titleBold: true,
                                valueBold: true,
                                value: state.productDetail.salesRate,
                              ),
                              if(double.parse(state.productDetail.altQty) > 0)
                                RowDataWidget(
                                  valueFlex: 2,
                                  title: "Unit Code",
                                  titleBold: true,
                                  valueBold: true,
                                  value: '1.00  ${state.productDetail.altUnit} ${state.productDetail.altQty}  ${state.productDetail.unit}',
                                ),

                              Divider(color: hintColor),

                              // alt quantity
                              Container(
                                margin: const EdgeInsets.all(3.0),
                                child: Row(children: [
                                  const Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Alt Qty",
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
                                      controller: state.altQuantity,
                                      onTap: () async {
                                        state.lastEditedField = "altQty";
                                        state.altQuantity.text = "";
                                        state.quantity.text = "0.00";
                                        state.calculate();

                                      },
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            state.altQuantity.text == "0.00") {
                                          return "";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (text) async {

                                        state.lastEditedField = "altQty";
                                        state.orderFormKey.currentState!.validate();
                                        state.calculate();
                                        setState(() {});


                                        // state.calculate();
                                        // state.calculateProductQty();
                                        // setState(() {});
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
                              //quantity
                              Container(
                                margin: const EdgeInsets.all(1.0),
                                child: Row(children: [
                                  const Expanded(
                                    flex: 3,
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
                                      onTap: () {
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
                                      onChanged: (text) {
                                        state.orderFormKey.currentState!
                                            .validate();
                                        state.calculate();
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
                                margin: const EdgeInsets.all(1.0),
                                child: Row(children: [
                                  const Expanded(
                                    flex: 3,
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
                                        state.orderFormKey.currentState!.validate();
                                        state.calculate();
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
                                    flex: 3,
                                    child: Text(
                                      "Amount",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                const Expanded(
                                    child: Text(' : ',
                                        textAlign: TextAlign.center)),
                                Expanded(
                                    flex: 5,
                                    child: Text(
                                      "${state.totalPrice}",
                                      style: const TextStyle(
                                        fontSize: 20.0,
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
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    horizantalSpace(10.0),
                                    Expanded(
                                      child: SaveButton(
                                        buttonName: "CONFIRM",
                                        onClick: () async {
                                          //  Provider.of<ProductOrderState>(context,listen: false).init();
                                          await state.saveTempProduct();
                                          Navigator.pop(context);
                                          setState(() {

                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDialogAlreadyData(BuildContext context,String productName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //  title: Text(productName),
          content: Text('This $productName already exists'),
          actions: <Widget>[
            // Cancel Button
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            // OK Button
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                Navigator.of(context).pop();
                await sho();
                // Close the dialog
                // Additional action can go here, such as navigating to another screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final stateQR = Provider.of<ProductOrderState>(context,listen: true);

    return Consumer<ProductOrderScanState>(builder: (BuildContext context, stateQR, Widget? child) {
      // Fluttertoast.showToast(msg: "Build home");
      stateQR.itemCount = [];
      return WillPopScope(
        onWillPop: (stateQR.allOrderListFromDb.isNotEmpty)
            ? () {
          return onBackFromTempList();
        }
            : null,
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor: primaryColor,

            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'QR Products',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      '${stateQR.allOrderListFromDb.length} items',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const SizedBox(width: 8),
                if (stateQR.allOrderListFromDb.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Tooltip(
                      message: 'Clear All Products',
                      child: IconButton(
                        onPressed: () async {
                          bool? confirmDelete = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: const Text("Clear All Products"),
                                content: const Text(
                                    "Are you sure you want to clear all scanned products?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text("Cancel",
                                        style:
                                        TextStyle(color: Colors.grey[600])),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Yes",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              );
                            },
                          );
                          if (confirmDelete == true) {
                            await stateQR.deleteAllProducts();
                            Fluttertoast.showToast(
                              msg: 'All products cleared',
                              backgroundColor: Colors.red,
                            );
                          }
                        },
                        icon: Icon(EvaIcons.trash2Outline,
                            color: Colors.red[700]),
                      ),
                    ),
                  ),
              ],
            ),
            // actions: [
            //   InkWell(
            //     onTap: (){
            //      // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductGroupsScreen(code: '', name: '', productOrderEmum: ProductOrderEmum.orders,)));
            //     },
            //     child: Row(
            //       children: [
            //         Text("Product",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            //         SizedBox(width: 5,),
            //         Icon(Icons.production_quantity_limits_sharp),
            //       ],
            //     ),
            //   )
            // ],
          ),
          body: stateQR.allOrderListFromDb.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.qr_code_2,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No scanned products yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // ...stateQR.allOrderListFromDb.map((item) =>
                //     _buildProductItem(context, item, stateQR)),
                Expanded(
                  child: ListView.builder(
                    // shrinkWrap: true,
                    itemCount: stateQR.allOrderListFromDb.length,
                    itemBuilder: ( context,  index) {
                      ProductOrderModel item = stateQR.allOrderListFromDb[index];
                      return _buildProductItem(context,item,stateQR,index);
                    },),
                )
              ],
            ),
          ),
          bottomNavigationBar: stateQR.allOrderListFromDb.isEmpty
              ? null
              : _buildBottomBar(stateQR),
          floatingActionButton: FloatingActionButton(

            onPressed: () {

              scanQR();

              //  _processQRCode("55");
              setState(() {

              });

              //stateQR.uiChange();
              //   Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => const QRScanScreen(),
              //     ),
              //   );
            },
            child: const Icon(Icons.qr_code_scanner_rounded),
          ),
        ),
      );
    },);
  }

  Widget _buildProductItem(
      BuildContext context,
      ProductOrderModel item,
      ProductOrderScanState stateQR,
      int index,
      ) {
    stateQR.itemCount.add(int.parse(item.quantity));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 14, color: primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        'Scanned',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    bool? confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: const Text("Remove Product"),
                          content: const Text(
                              "Are you sure you want to remove this product?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Cancel",
                                  style: TextStyle(color: Colors.grey[600])),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Yes",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirmDelete == true) {
                      stateQR.deleteTempOrderProduct(productID: item.productCode,orderId:item.orderId);
                    }
                  },
                  icon: const Icon(
                    EvaIcons.trash2Outline,
                    color: Colors.red,
                  ),
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.productName ?? 'Unknown Product',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Rate. ${item.rate ?? 'No description available'}',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. ${(int.tryParse(item.quantity) ?? 0) * (double.tryParse(item.rate) ?? 0)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: ()async{
                        stateQR.decrementQuantity(index);
                        await stateQR.decreaseCartQuantityByID(productID: item.productCode,index: index,quantity: item.quantity, orderId: item.orderId!);
                      },
                      child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Icon(EvaIcons.minus,size: 15,)),
                    ),
                    SizedBox(width: 5,),
                    Text('${stateQR.itemCount[index]}'),
                    SizedBox(width: 5,),
                    InkWell(
                      onTap: ()async{
                        stateQR.incrementQuantity(index);
                        await stateQR.increaseCartQuantityByID(productID: item.productCode,index: index,quantity:item.quantity,orderId: item.orderId!);
                      },
                      child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Icon(EvaIcons.plus,size: 15,)),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          item.quantity,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          // ShowAlert(context).alert(
                          //   child: EditPendingSyncProductDetails(
                          //       productDetail: item,
                          //       orderId:item.orderId!
                          //   ),
                          // );
                        },
                        icon: const Icon(
                          EvaIcons.edit2Outline,
                          color: Colors.blue,
                        ),
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(ProductOrderScanState stateQR) {
    final double subtotal = stateQR.allOrderListFromDb.fold(
      0,
          (sum, item) =>
      sum +
          (double.tryParse(item.rate) ?? 0) *
              (double.tryParse(item.quantity) ?? 0),
    );
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. $subtotal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${stateQR.allOrderListFromDb.length} items',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              // onPressed: () async {
              //   await stateQR.onFinalOrderSaveToDB().whenComplete(() async {
              //     await stateQR.productOrderAPICall(context);
              //   });
              //   await stateQR.getAllTempProductOrderList();
              // },
              onPressed: () async {
                bool? confirmed = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Order'),
                      content: const Text(
                          'Are you sure you want to place this order?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          child: const Text('Confirm'),
                        ),
                      ],
                    );
                  },
                );
                if (confirmed == true) {
                  await stateQR.onFinalOrderSaveToDB().whenComplete(() async {
                    await stateQR.productOrderAPICall(context);
                  });
                  await stateQR.getAllTempProductOrderList();
                }

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Order Products',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


