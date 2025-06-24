import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/products/products_state.dart';
import 'package:retail_app/src/purchase/state/purchase_bill_term_state.dart';
import 'package:retail_app/src/purchase/state/purchase_state.dart';
import 'package:retail_app/src/sales/components/sales_order_list.dart';
import 'package:retail_app/src/sales/model/temp_product_sales_model.dart';
import 'package:retail_app/src/sales/sales_screen.dart';
import 'package:retail_app/src/sales/sales_state.dart';
import 'package:retail_app/src/sales_bill_term/sales_bill_term_state.dart';
import 'package:retail_app/widgets/custom_button.dart';
import 'package:retail_app/widgets/tablewidgets/data_table.dart';
import '../../../constants/text_style.dart';
import '../../../services/sharepref/get_all_pref.dart';
import '../../../themes/themes.dart';
import '../../../widgets/widgets.dart';
import '../../purchase/dialog/purchase_alert_dialog.dart';
import '../../purchase/screen/purchase_order.dart';
import '../../qr_scanner/qr_list_product.dart';
import '../model/product_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class CounterModel extends ValueNotifier<int> {
  CounterModel(super.value);

  void increment() {
    value++;
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  showAlert(context, index) async {
    final state = Provider.of<ProductState>(context, listen: false);
    final orderState = Provider.of<ProductOrderState>(context, listen: false);
    final purchaseOrderState = Provider.of<PurchaseOrderState>(context, listen: false);
    final termState = Provider.of<SalesTermState>(context, listen: false);
    orderState.clear();
    orderState.getProductDetails = state.filterProductList[index];
    //orderState.getSalesRate = state.filterProductList[index].salesRate;
    orderState.getSalesRate = "0.00";
    purchaseOrderState.getProductDetails = state.filterProductList[index];
    purchaseOrderState.getSalesRate = state.filterProductList[index].salesRate;

    if (await GetAllPref.salePurchaseMap() == "purchase") {
      ShowAlert(context).alert(child: const PurchaseAlertDialog());
    } else {
      ShowAlert(context).alert(child: const ProductOrderScreen());
    }
  }

  List<TextEditingController> _controllers = [];

  List<TextEditingController> _controllersAmount = [];

  double value = 0.00;
  String salePurchase = "";

  @override
  void initState() {
    super.initState();
    Provider.of<ProductOrderState>(context, listen: false)
        .getAllTempProductOrderList();
    Provider.of<SalesTermState>(context, listen: false).getContext = context;
    Provider.of<PurchaseTermState>(context, listen: false).getContext = context;
    Provider.of<ProductOrderState>(context, listen: false).getContext = context;
    showPurchaseSaleMap();
  }

  Widget notValid(context,String productName, int index) {
    return Center(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Text(
                    "$productName Out of Stock ",
                    style: titleTextStyle.copyWith(
                      color: Colors.red,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    "Please Contact Head Office",
                    style: titleTextStyle.copyWith(
                      color: Colors.black,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              verticalSpace(10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CancleButton(
                  //     buttonName: "No",
                  //     onClick: () async {
                  //       Navigator.pop(context);
                  //     }
                  // ),
                 Expanded(child:  CancleButton(
                     buttonName: "Cancel",
                     onClick: () async {
                       Navigator.pop(context);
                      // await showAlert(context, index);
                     }
                 ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  showPurchaseSaleMap() async{
    salePurchase =  await  GetAllPref.salePurchaseMap();
  }

  @override
  Widget build(BuildContext context) {
    final stateSalesProduct = context.watch<ProductOrderState>();
    final statePurchaseProduct = context.watch<PurchaseOrderState>();

    final state = context.watch<ProductState>();

    final stateSalesTerm = context.watch<SalesTermState>();
    for (int i = 0; i < stateSalesTerm.termList.length; i++) {
      _controllers.add(TextEditingController());
      _controllersAmount.add(TextEditingController());
    }
    return Scaffold(
      appBar: AppBar(title: Text(state.selectedGroup.groupName,style: cardTextStyleHeader,),
        actions:  [
          InkWell(
              onTap: (){
                //  Navigator.pushNamed(context, qrSectionPath);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>QrProductListSection(scan: 'ScannerQrCode',)));
              },
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      child: AnimatedBorder(),
                    )
                    // Text("Scan",style: TextStyle(fontWeight: FontWeight.bold),),
                    // SizedBox(width: 5,),
                    // const Icon(Icons.qr_code_2_sharp),
                  ],
                ),
              ),)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {


          if (await GetAllPref.salePurchaseMap() == "purchase") {

            if (statePurchaseProduct.allTempOrderList.isNotEmpty) {
              statePurchaseProduct.getBTerm1Amount = 0.00;
              statePurchaseProduct.getBTerm2Amount = 0.00;
              statePurchaseProduct.getBTerm3Amount = 0.00;
              statePurchaseProduct.getTotalBillWise = 0.00;


              statePurchaseProduct.getSign1 = "";
              statePurchaseProduct.getSign2 = "";
              statePurchaseProduct.getSign2 = "";
              statePurchaseProduct.getDiscBill = 0.0;
              statePurchaseProduct.getVatBill = 0.0;


              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft,
                child: const PurchaseOrderList(),),);
            } else {
              Fluttertoast.showToast(msg: "Order item no available");
            }

          }else {
            if (stateSalesProduct.allTempOrderList.isNotEmpty) {
              stateSalesProduct.getBTerm1Amount = 0.00;
              stateSalesProduct.getBTerm2Amount = 0.00;
              stateSalesProduct.getBTerm3Amount = 0.00;
              stateSalesProduct.getTotalBillWise = 0.00;
              stateSalesProduct.getSign1 = "";
              stateSalesProduct.getSign2 = "";
              stateSalesProduct.getSign2 = "";
              stateSalesProduct.getDiscBill = 0.0;
              stateSalesProduct.getVatBill = 0.0;
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft,
                child: const OrderListSection(),),);
            } else {
              Fluttertoast.showToast(msg: "Order item no available");
            }
          }

        },
        child: const Icon(Icons.check),
      ),
      body: Column(
        children: [
          StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  onChanged: (value) {
                    state.filterProduct = value;
                    setState(() {});
                  },
                  decoration: TextFormDecoration.decoration(
                    hintText: "Search Products",
                    hintStyle: hintTextStyle,
                    prefixIcon: Icons.search,
                  ),
                ),
              );
            },
          ),

          ///
          Expanded(
            child: state.filterProductList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.filterProductList.length,
                    itemBuilder: (context, index) {
                      ProductDataModel productModel =
                          state.filterProductList[index];
                      bool isAvailable = double.parse(productModel.stockQty) > 1;

                      return StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return TableDataWidget(
                            onTap: () async {
                              stateSalesProduct.getBTerm1Amount = 0.00;
                              stateSalesProduct.getBTerm2Amount = 0.00;
                              stateSalesProduct.getBTerm3Amount = 0.00;
                              stateSalesProduct.getTotalBillWise = 0.00;

                              statePurchaseProduct.getTotalBillWise = 0.00;
                              statePurchaseProduct.getBTerm1Amount = 0.00;
                              statePurchaseProduct.getBTerm2Amount = 0.00;
                              statePurchaseProduct.getBTerm3Amount = 0.00;
                              debugPrint(productModel.stockQty);
                              await GetAllPref.salePurchaseMap() == "purchase"
                                  ? await showAlert(context, index)
                                  : isAvailable
                                      ? await showAlert(context, index)
                                      : ShowAlert(context).alert(
                                child: notValid(context,productModel.pDesc,index),);
                            },
                            child: Row(
                              children: [
                                // Flexible(
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(
                                //       right: 10.0,
                                //     ),
                                //     child: Image.memory(
                                //       base64Decode(productModel.pImage),
                                //       height: 80.0,
                                //       width: 80.0,
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        productModel.pDesc,
                                        style: cardTextStyleProductHeader,
                                      ),
                                      Text(
                                        "Quantity:${productModel.stockQty}",style: cardTextStyleSalePurchase,
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Container(
                                              decoration: ContainerDecoration
                                                  .decoration(
                                                color: salePurchase == "purchase" ? Colors.white : isAvailable ? successColor : errorColor,
                                                bColor: salePurchase == "purchase" ? Colors.white : isAvailable ? successColor : errorColor,
                                              ),

                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  salePurchase == "purchase" ? "" : isAvailable
                                                          ? "Available"
                                                          : "N/A",
                                                  textAlign: TextAlign.end,
                                                  style: whiteTextStyle
                                                      .copyWith(fontSize: 12.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              "Price => ${productModel.salesRate}",
                                              textAlign: TextAlign.end,
                                              style: cardTextStyleSalePurchase,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  )
                : const NoDataWidget(),
          ),
        ],
      ),
    );
  }

  Table _buildOrderTable() {
    var state2 = context.watch<ProductOrderState>();

    List<TableRow> rows = [];
    rows.add(_buildTableRowHeader());
    double qty = 0;
    double totalAmount = 0;
    double discTotal = 0;
    double vatTotal = 0;

    for (int i = 0; i < state2.allTempOrderList.length; ++i) {
      qty += double.parse(state2.allTempOrderList[i].quantity);
      discTotal += double.parse(state2.allTempOrderList[i].pTerm1Amount);
      totalAmount += double.parse(state2.allTempOrderList[i].rate) *
          double.parse(state2.allTempOrderList[i].quantity);

      rows.add(_buildTableRowProductData(i + 1, state2.allTempOrderList[i]));
      //rows.add(i.toString());
    }

    rows.add(_buildTableRowTotal(qty, totalAmount));
    rows.add(_buildTableRowTotalDiscount(discTotal));
    rows.add(_buildTableRowTotalVat(totalAmount));
    rows.add(_buildTableRowNetTotal(totalAmount, discTotal));
    return Table(
      columnWidths: {
        // 0: FixedColumnWidth(100), // Width of the first column
        // 1: FlexColumnWidth(150),    // Flex ratio of 1 for the second column
        // 2: FixedColumnWidth(100), // Width of the third column
        //  3: FixedColumnWidth(100), // Width of the third column
      },
      border: TableBorder.all(width: 1, color: Colors.black),
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: rows,
    );
  }

  TableRow _buildTableRowHeader() {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.black54),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'S.N',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Product',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Qty',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Rate',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Discount',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Amount',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRowProductData(int index, TempProductOrderModel product) {
    product.pName.toString();
    return TableRow(
      children: [
        // const Padding(padding: EdgeInsets.all(8)),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            index.toString(),
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 12, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            product.pName.toString(),
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 12, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            product.quantity.toString(),
            textAlign: TextAlign.right,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 12, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            product.rate.toString(),
            textAlign: TextAlign.right,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 12, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            product.pTerm1Rate.toString(),
            textAlign: TextAlign.right,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 12, color: Colors.black),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            (double.parse(product.rate) * double.parse(product.quantity))
                .toString(),
            textAlign: TextAlign.right,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 12, color: Colors.black),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRowTotal(double qty, double totalAmount) {
    return TableRow(
      children: [
        const Padding(padding: EdgeInsets.all(8)),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Total :',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            qty.toString(),
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        //  const Padding(padding: EdgeInsets.all(8), child: SizedBox()),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "",
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "",
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            totalAmount.toStringAsFixed(2),
            // salesOrderProvider.orderList
            //     .map((product) => product.netAmount)
            //     .fold(0.0, (p, c) => p + c)
            //     .toStringAsFixed(2),
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRowTotalDiscount(double discTotal) {
    return TableRow(
      children: [
        const Padding(padding: EdgeInsets.all(8)),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            '',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            '',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        //  const Padding(padding: EdgeInsets.all(8), child: SizedBox()),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "",
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "Disc",
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            discTotal.toStringAsFixed(2),
            // salesOrderProvider.orderList
            //     .map((product) => product.netAmount)
            //     .fold(0.0, (p, c) => p + c)
            //     .toStringAsFixed(2),
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRowTotalVat(double totalAmount) {
    return TableRow(
      children: [
        const Padding(padding: EdgeInsets.all(8)),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            '',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            '',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        //  const Padding(padding: EdgeInsets.all(8), child: SizedBox()),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "",
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "Vat",
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            ((totalAmount * 13) / 100).toStringAsFixed(2),
            // salesOrderProvider.orderList
            //     .map((product) => product.netAmount)
            //     .fold(0.0, (p, c) => p + c)
            //     .toStringAsFixed(2),
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRowNetTotal(double totalAmount, double discTotal) {
    return TableRow(
      children: [
        const Padding(padding: EdgeInsets.all(8)),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Net Total :',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            '',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        //  const Padding(padding: EdgeInsets.all(8), child: SizedBox()),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "",
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            "",
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            (totalAmount + ((totalAmount * 13) / 100) - discTotal)
                .toStringAsFixed(2),
            // salesOrderProvider.orderList
            //     .map((product) => product.netAmount)
            //     .fold(0.0, (p, c) => p + c)
            //     .toStringAsFixed(2),
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class AnimatedBorder extends StatefulWidget {
  const AnimatedBorder({super.key});

  @override
  _AnimatedBorderState createState() => _AnimatedBorderState();
}

class _AnimatedBorderState extends State<AnimatedBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: CustomPaint(
        painter: BorderPainter(animation: _controller),
        child:  InkWell(
          onTap: (){
            //  Navigator.pushNamed(context, qrSectionPath);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const QrProductListSection(scan: 'ScannerQrCode',)));
          },
          child:const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text("Scan",style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(width: 5,),
                Icon(Icons.qr_code_2_sharp),
              ],
            ),
          ),),
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  final Animation<double> animation;

  BorderPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final startAngle = animation.value * 2 * 3.14159; // Full circle animation
    const sweepAngle = 3.14159 / 5; // Quarter-circle border

    // Draw the arc border clockwise
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}