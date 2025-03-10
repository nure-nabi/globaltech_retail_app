import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retail_app/src/product_order/print_bill/pdf.dart';

import '../../model/basic_model.dart';
import '../../services/router/router_name.dart';
import '../../services/sharepref/get_all_pref.dart';
import '../../utils/custom_log.dart';
import '../login/model/login_model.dart';
import '../print_bill/print_bill.dart';
import '../products/model/product_model.dart';
import 'api/product_order_api.dart';
import 'db/post_order_db.dart';
import 'db/product_order_db.dart';
import 'device_info/device_info.dart';
import 'model/all_order_details.dart';
import 'model/order_post_model.dart';
import 'model/product_order_model.dart';

class ProductOrderScanState extends ChangeNotifier {
  ProductOrderScanState();

  late BuildContext _context;

  BuildContext get context => _context;
  late final NavigatorState navigator = Navigator.of(_context);

  set getContext(BuildContext value) {
    _context = value;

    ///
    init();
  }

  late bool _isLoading = false;

  bool get isLoading => _isLoading;

  set getLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  init() async {
    await clear();
    _companyDetail = await GetAllPref.companyDetail();
    await getAllTempProductOrderList();


  }

  clear() async {
    _isLoading = false;
    //_companyDetail = CompanyDetailsModel.fromJson({});
    _quantity = TextEditingController(text: "1");
    _salesRate = TextEditingController(text: salesRate.text.trim());
    _totalPrice = 0.0;
    itemCount = [];
  }

  late CompanyDetailsModel _companyDetail = CompanyDetailsModel.fromJson({});

  CompanyDetailsModel get companyDetail => _companyDetail;

  set getCompanyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  late final _orderFormKey = GlobalKey<FormState>();

  GlobalKey<FormState> get orderFormKey => _orderFormKey;

  late ProductDataModel _productDetail = ProductDataModel.fromJson({});

  ProductDataModel get productDetail => _productDetail;

  set getProductDetails(ProductDataModel value) {
    _productDetail = value;
    notifyListeners();
  }

  late TextEditingController _quantity = TextEditingController(text: "");

  TextEditingController get quantity => _quantity;

  late TextEditingController _altQuantity = TextEditingController(text: "0");

  TextEditingController get altQuantity => _altQuantity;

  late TextEditingController _salesRate = TextEditingController(text: "");

  TextEditingController get salesRate => _salesRate;

  set getSalesRate(String value) {
    _salesRate.text = value;
    notifyListeners();
  }
  late double _totalSalesPrice = 0.0;
  double get totalSalesPrice => _totalSalesPrice;
  set getTotalSalesPrice(double value) {
    _totalSalesPrice = value;
    notifyListeners();
  }
  List<int> itemCount = [];
  late double _totalPrice = 0.0;

  double get totalPrice => _totalPrice;

  set getTotalPrice(double value) {
    _totalPrice = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_totalPrice");
    notifyListeners();
  }

  late String _PTerm1Code = "";
  String get PTerm1Code => _PTerm1Code;
  set getPTerm1Code(String value) {
    _PTerm1Code = value;
    notifyListeners();
  }

  late double _PTerm1Rate = 0.0;
  double get PTerm1Rate => _PTerm1Rate;
  set getPTerm1Rate(double value) {
    _PTerm1Rate = value;

    notifyListeners();
  }

  late double _PTerm1Amount = 0.0;
  double get PTerm1Amount => _PTerm1Amount;
  set getPTerm1Amount(double value) {
    _PTerm1Amount = value;

    notifyListeners();
  }

  late double _PTerm2Rate = 0.0;
  double get PTerm2Rate => _PTerm2Rate;
  set getPTerm2Rate(double value) {
    _PTerm2Rate = value;

    notifyListeners();
  }
  late double _netTotalPrice = 0.0;
  double get netTotalPrice => _netTotalPrice;
  set getNetTotalPrice(double value) {
    _netTotalPrice = value;
    notifyListeners();
  }

  late String _sign1 = "";
  String get sign1 => _sign1;
  set getSign1(String value) {
    _sign1 = value;
    notifyListeners();
  }
  late String _sign2 = "";
  String get sign2 => _sign2;
  set getSign2(String value) {
    _sign2 = value;
    notifyListeners();
  }
  late String _sign3 = "";
  String get sign3 => _sign3;
  set getSign3(String value) {
    _sign3 = value;
    notifyListeners();
  }
  late String _bSign1 = "";
  String get bSign1 => _bSign1;
  set getBSign1(String value) {
    _bSign1 = value;
    notifyListeners();
  }
  late String _bSign2 = "";
  String get bSign2 => _bSign2;
  set getBSign2(String value) {
    _bSign2 = value;
    notifyListeners();
  }
  late String _bSign3 = "";
  String get bSign3 => _bSign3;
  set getBSign3(String value) {
    _bSign3 = value;
    notifyListeners();
  }

  late double _totalProductPrice = 0.0;
  double get totalProductPrice => _totalProductPrice;
  set getTotalProductPrice(double value) {
    _totalProductPrice = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_totalProductPrice");
    notifyListeners();
  }
  late double _PTerm2Amount = 0.0;
  double get PTerm2Amount => _PTerm2Amount;
  set getPTerm2Amount(double value) {
    _PTerm2Amount = value;

    notifyListeners();
  }
  late String _PTerm2Code = "";
  String get PTerm2Code => _PTerm2Code;
  set getPTerm2Code(String value) {
    _PTerm2Code = value;
    notifyListeners();
  }
  late double _PTerm3Rate = 0.0;
  double get PTerm3Rate => _PTerm3Rate;
  set getPTerm3Rate(double value) {
    _PTerm3Rate = value;
    notifyListeners();
  }

  late double _PTerm3Amount = 0.0;
  double get PTerm3Amount => _PTerm3Amount;
  set getPTerm3Amount(double value) {
    _PTerm3Amount = value;
    notifyListeners();
  }
  late String _PTerm3Code = "";
  String get PTerm3Code => _PTerm3Code;
  set getPTerm3Code(String value) {
    _PTerm3Code = value;

    notifyListeners();
  }
  calculateProductQty() async {
    if (_quantity.text.isEmpty || _salesRate.text.isEmpty) {
      getTotalProductPrice = 0.00;
    }
    else {
      getTotalProductPrice=0.00;
      double tempTotal = double.parse(_quantity.text)*double.parse(_salesRate.text);
      getTotalProductPrice = tempTotal;
    }

    ///
    notifyListeners();
  }
  // Increment the quantity of an item
  incrementQuantity(int index) {
    itemCount[index]++;
    notifyListeners();
  }



  // Increment the quantity of an item
  decrementQuantity(int index) {
    if(itemCount[index] == 1){
    }else {
      itemCount[index]--;
    }
    notifyListeners();
  }
  String lastEditedField = ""; // Track the last edited field
  calculate() async {
    double  quantityFactor = 0.00;
    if (_quantity.text.isEmpty || _salesRate.text.isEmpty) {
      getTotalPrice = 0.00;
      getTotalSalesPrice = 0.00;

    }

    ///
    else {
      if (double.parse(productDetail.altQty) > 0) {
        try {
          if (lastEditedField == "altQty" && _altQuantity.text != '0.00') {
            quantityFactor = double.parse(_altQuantity.text) * double.parse(productDetail.altQty);
            debugPrint('AltQty to Quantity: $quantityFactor');
            _quantity.text = quantityFactor.toStringAsFixed(1);
          } else
          if (lastEditedField == "quantity" && _quantity.text != '0.00') {
            double altQuantityFactor = double.parse(_quantity.text) /
                double.parse(productDetail.altQty);
            debugPrint('Quantity to AltQty: $altQuantityFactor');
            _altQuantity.text = altQuantityFactor.toStringAsFixed(1);
          }
        } catch (e) {
          Fluttertoast.showToast(msg: 'Invalid number format');
          return;
        }
      }


      try {

        getTotalPrice = 0.00;
        double tempTotal = (double.parse(_quantity.text)) * double.parse(_salesRate.text);
        getTotalSalesPrice = tempTotal;
        double vatAmount = (tempTotal * PTerm2Rate) / 100;
        double grand = tempTotal + vatAmount;
        double discount = (grand * PTerm1Rate) / 100;
        double finalPrice = tempTotal + vatAmount - discount;

        getTotalPrice = tempTotal  + vatAmount  - PTerm1Amount;
        getNetTotalPrice = tempTotal  + vatAmount  - PTerm1Amount;
      }catch(e){

      }
      //alt quantity




    }

    ///
    notifyListeners();
  }
  List<ProductOrderModel> _checkListExits = [];
  List<ProductOrderModel> get checkListExits => _checkListExits;

  set setCheckListExits(List<ProductOrderModel> value){
    _checkListExits = value;
    notifyListeners();
  }
   checkValue()async{
    await OrderProductDatabase.instance.getProductAlready(pcode: _productDetail.pCode.toString()).then((value){
      if(value.isNotEmpty){
        setCheckListExits = value;
       // Fluttertoast.showToast(msg: 'This ${_productDetail.pDesc} already exists');
      }
    });
    notifyListeners();
  }

  Future<void> saveTempProduct() async {
    if (_orderFormKey.currentState!.validate()) {
      CustomLog.actionLog(value: "VALUE => ${_totalPrice.toStringAsFixed(2)}");
      // await OrderProductDatabase.instance.getProductAlready(pcode: _productDetail.pCode.toString()).then((value){
      //  if(value.length >= 1){
      //    Fluttertoast.showToast(msg: 'This ${_productDetail.pDesc} already exists');
      //  }
      //
      //   });

      ProductOrderModel orderProduct = ProductOrderModel(
        id: _productDetail.pCode.toString(),
        productCode: _productDetail.pCode,
        productName: _productDetail.pDesc,
        quantity: _quantity.text.trim(),
        rate: _salesRate.text.trim(),
        productDescription: _productDetail.pDesc,
        total: _totalPrice.toString(),
        images: _productDetail.unit,
      );
      await OrderProductDatabase.instance.insertData(orderProduct);
      await getAllTempProductOrderList();
      // navigator.pushNamedAndRemoveUntil(
      //   qrScreenPath,
      //   (route) => true,
      // );
      notifyListeners();
    }
  }

  late List<ProductOrderModel> _allOrderListFromDb = <ProductOrderModel>[];

  List<ProductOrderModel> get allOrderListFromDb => _allOrderListFromDb;

  set getAllOrderListFromDb(List<ProductOrderModel> value) {
    _allOrderListFromDb = value;
    notifyListeners();
  }

  getAllTempProductOrderList() async {
    await OrderProductDatabase.instance.getAllProductList().then((value) {
      getAllOrderListFromDb = value;
    });
   // Fluttertoast.showToast(msg: "getValue");
    notifyListeners();
  }

  updatePendingSyncOrderProductDetail(String productID, String rate, String quantity,String orderId ) async {
    await OrderProductDatabase.instance
        .editDataById(productCode: productID, rate: rate, quantity: quantity,orderId:orderId)
        .then((value) {
     // getAllOrderListFromDb = value;
    });
    Fluttertoast.showToast(msg: orderId);
    await getAllTempProductOrderList();
    // navigator.pushNamedAndRemoveUntil(
    //   qrScreenPath,
    //       (route) => true,
    // );
   // await getAllTempProductOrderList();
    notifyListeners();
  }

  deleteTempOrderProduct({required String productID,orderId}) async {
    await OrderProductDatabase.instance.deleteDataByID(productID: productID,orderId:orderId);
    await getAllTempProductOrderList();
    notifyListeners();
  }

  increaseTempQuantityByID({required String productID}) async {
      await OrderProductDatabase.instance
          .increaseQuantityByID(productID: productID);
      await getAllTempProductOrderList();
      notifyListeners();
  }

  decreaseTempQuantityByID({required String productID}) async {
      await OrderProductDatabase.instance
          .decreaseQuantityByID(productID: productID);
      await getAllTempProductOrderList();
      notifyListeners();


  }


  increaseCartQuantityByID({required String productID,required String orderId,index,quantity}) async {

    if(int.parse(quantity) > 1 || int.parse(itemCount[index].toString()) > 1){
      await OrderProductDatabase.instance
          .increaseQuantityByID(productID: productID,orderId:orderId);
      await getAllTempProductOrderList();
      notifyListeners();
    }else{
      Fluttertoast.showToast(msg: "You don't decrease value less than 1");
    }

  }

  decreaseCartQuantityByID({required String productID,required String orderId,index,quantity}) async {
    if(int.parse(quantity) > 1 || int.parse(itemCount[index].toString()) > 1){
      await OrderProductDatabase.instance
          .decreaseQuantityByID(productID: productID,orderId:orderId);
      await getAllTempProductOrderList();
      notifyListeners();
    }else{
      Fluttertoast.showToast(msg: "You don't decrease value less than 1");
    }

  }

  deleteAllProducts() async {
    await OrderProductDatabase.instance.deleteData().then((value) {});
    await getAllTempProductOrderList();
    notifyListeners();
  }

  Future productOrderAPICall(ctx) async {
    getLoading = true;
    BasicModel modelData = await OrderProductAPI.postOrder(
      bodyData: await getFormatPOSTDATA(),
    );
    if (modelData.statusCode == 200) {


      await OrderPostDatabase.instance.deleteData();
     // if (await DeviceTypeChecker.isPOSDevice()) {
      //  final sunmiPrinter = SunmiPrinterService();
        // await sunmiPrinter.printProductOrder(
        //   allOrderListFromDb,
        //   modelData.message,
        //   await GetAllPref.outLetCode(),
        //   await GetAllPref.companyInitial(),
        //   await GetAllPref.customerAddress(),
        // );
     // } else {
     //   await shareLedger(vNo: modelData.message);
    //  }
      await OrderProductDatabase.instance.deleteData();
     // Fluttertoast.showToast(msg: "clean data");
      _checkListExits = [];
      await navigator.pushNamedAndRemoveUntil(
        indexPath,
        (route) => false,
      );
    } else {
      await OrderPostDatabase.instance.deleteData();
      Fluttertoast.showToast(msg: 'some error occured');
      _checkListExits = [];
      await OrderProductDatabase.instance.deleteData();
      // await productOrderComplete(ctx, false, modelData.message);
    }
    notifyListeners();
  }

  productOrderComplete(BuildContext ctx, bool isSuccess, String message) async {
    getLoading = false;
    Fluttertoast.showToast(msg: 'Product order successfully');
    notifyListeners();
  }

  getIndexTotalAmount({required String rate}) {
    double vatAmount = (double.parse(rate) * 0.13);
    CustomLog.actionLog(value: "TOTAL AMOUNT CHECK => $rate");
    return vatAmount + double.parse(rate);
  }

  late double _totalBalance = 0.00;

  double get totalBalance => _totalBalance;

  set getTotalBalance(double value) {
    _totalBalance = value;
    notifyListeners();
  }

  calculateTotalAmount() {
    _totalBalance = 0.00;
    for (var element in _allOrderListFromDb) {
      _totalBalance += getIndexTotalAmount(rate: element.rate);
    }
    return _totalBalance.toStringAsFixed(2);
  }




  Future onFinalOrderSaveToDB() async {
    CustomLog.actionLog(
        value: "TEMP ORDER COUNT  => ${_allOrderListFromDb.length}");

    _allOrderListFromDb.asMap().forEach((index, element) async {
      AllOrderDetailsModel finalOrder = AllOrderDetailsModel(
          dbName: _companyDetail.dbName.toString(),
          glCode: await GetAllPref.outLetCode(),
          userCode: await GetAllPref.userName(),
      pcode: element.productCode,
      rate: element.rate,
      qty: itemCount[index].toString(),
      totalAmt: element.total,
      comment: 'test comment',
      );
      await OrderPostDatabase.instance.insertData(finalOrder);
    });

    // for (var element in _allOrderListFromDb) {
    //
    //   AllOrderDetailsModel finalOrder = AllOrderDetailsModel(
    //     dbName: _companyDetail.dbName.toString(),
    //     glCode: await GetAllPref.getOutLetCode(),
    //     userCode: await GetAllPref.getUserName(),
    //     pcode: element.productCode,
    //     rate: element.rate,
    //     qty: itemCount[].toString(),
    //     totalAmt: element.total,
    //     comment: 'test comment',
    //   );
    //   await OrderPostDatabase.instance.insertData(finalOrder);
    // }
    await OrderProductDatabase.instance.deleteData();
  }

  late List<BToBOrderModel> _orderPostDataList = [];

  List<BToBOrderModel> get orderPostDataList => _orderPostDataList;

  set getOrderPostData(List<BToBOrderModel> value) {
    _orderPostDataList.clear();
    _orderPostDataList = value;
    notifyListeners();
  }

  getFormatPOSTDATA() async {
    await OrderPostDatabase.instance.getFormatPOSTDATA().then((value) {
      getOrderPostData = value;
    });
    CustomLog.actionLog(
        value: "ORDER LIST DATA => ${jsonEncode(_orderPostDataList)}");
    return _orderPostDataList;
  }

  shareLedger({required String vNo}) async {
    CustomLog.log(value: _companyDetail.dbName);
    await generateOrderProduct(
      companyDataDetails: _companyDetail,
      orderProductList: allOrderListFromDb,
      glDesc: await GetAllPref.outLetCode(),
      vNo: vNo,
    );
  }

  uiChange()async{
    notifyListeners();
  }
}
