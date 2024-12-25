




import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/sales/api/sales_api.dart';
import 'package:retail_app/src/sales/db/product_sales_db.dart';
import 'package:retail_app/src/sales/db/temp_product_sales_db.dart';
import 'package:retail_app/src/sales/model/outlet_model.dart';
import 'package:retail_app/src/sales/model/post_sales_model.dart';
import 'package:retail_app/src/sales/model/product_sales_model.dart';
import 'package:retail_app/src/sales/model/temp_product_sales_model.dart';
import 'package:retail_app/src/sales/pdf/sales_product_pdf.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import '../../../model/model.dart';
import '../../services/router/router_name.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';
import '../pdf/sales_bill_pdf.dart';
import '../print_bill/print_bill.dart';
import '../products/products.dart';
import 'components/sales_alert_section.dart';

class ProductOrderState extends ChangeNotifier {
  ProductOrderState();

  late BuildContext _context;

  BuildContext get context => _context;
  late final NavigatorState navigator = Navigator.of(_context);

  set getContext(BuildContext value) {
    _context = value;

    ///
    init();
  }

  late CompanyDetailsModel _companyDetail = CompanyDetailsModel.fromJson({});

  CompanyDetailsModel get companyDetail => _companyDetail;

  set getCompanyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  late bool _isLoading = false;

  bool get isLoading => _isLoading;

  set getLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  init() async {

   // await clear2();
    await checkConnection();
   // selectedGlCode = null;
    getCustomer = null;
    // await getOutletInfoState();
  }

  checkConnection() async {
   // Fluttertoast.showToast(msg: "daba");
    CheckNetwork.check().then((network) async {
      getCompanyDetail = await GetAllPref.companyDetail();

      if (network) {
      //  await networkSuccess();
      } else {
       // await getGroupProductListFromDB();
      }
    });
  }
clear2(){
  _companyDetail = CompanyDetailsModel.fromJson({});

  setBillDiscountAmount = 0.00;
  setBillVatAmount = 0.00;
}
  clear() async {
    _isLoading = false;

    _productDetail = ProductDataModel.fromJson({});

    _quantity = TextEditingController(text: "0.00");
    _salesRate = TextEditingController(text: "");
    _discount = TextEditingController(text: "0.00");
    _vatAmount = TextEditingController(text: "0.00");
    _discountRate = TextEditingController(text: "0.00");
    _discountAmt = TextEditingController(text: "0.00");

    // Total Price = Total Amount of the single product (ie rate * quantity)
    _totalPrice = 0.0;

    getvatAmountRate=0.00;
    getDiscountAmount=0.00;
    getVatAmount=0.00;
    getDisAmountRate=0.00;
    getDisAmount=0.00;
  }

  late ProductDataModel _productDetail = ProductDataModel.fromJson({});

  ProductDataModel get productDetail => _productDetail;

  set getProductDetails(ProductDataModel value) {
    _productDetail = value;
    notifyListeners();
  }



  late TextEditingController _discount = TextEditingController(text: "");

  TextEditingController get discount => _discount;

  late TextEditingController _vatAmount = TextEditingController(text: "");
  TextEditingController get vatAmount => _vatAmount;

  late TextEditingController _quantity = TextEditingController(text: "");

  TextEditingController get quantity => _quantity;

  late TextEditingController _salesRate = TextEditingController(text: "");

  TextEditingController get salesRate => _salesRate;

  late   TextEditingController _discountRate = TextEditingController(text: "");
  TextEditingController get  discountRate => _discountRate;

  late  TextEditingController _discountAmt = TextEditingController(text: "");
  TextEditingController get  discountAmt => _discountAmt;

  late  TextEditingController _comment = TextEditingController(text: "");
  TextEditingController get  comment => _comment;

  set getComment(String value) {
    _comment.text = value;
    notifyListeners();
  }

  set getDiscountAmt(String value) {
    _discountAmt.text = value;
    notifyListeners();
  }

  set getDiscountRate(String value) {
    _discountRate.text = value;
    notifyListeners();
  }

  set getSalesRate(String value) {
    _salesRate.text = value;
    notifyListeners();
  }



  // late File? _selectedImage ;
  // File? get selectedImage => _selectedImage!;
  //
  // set setImageFile (File? value){
  //   _selectedImage = value;
  //   notifyListeners();
  // }imageData

  late bool _isChecked = false;
  bool get isChecked => _isChecked;

  set setIsChecked (bool value){
    _isChecked = value;
    notifyListeners();
  }

  late String _imageData = "";
  String get imageData => _imageData;

  set setImageData (String value){
    _imageData = value;
    notifyListeners();
  }

  late String _imageName = "";
  String get imageName => _imageName;

  set setimageName (String value){
    _imageName = value;
    notifyListeners();
  }

  late double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;
  set getTotalPrice(double value) {
    _totalPrice = value;
    notifyListeners();
  }

  late double _totalSalesPrice = 0.0;
  double get totalSalesPrice => _totalSalesPrice;
  set getTotalSalesPrice(double value) {
    _totalSalesPrice = value;

    notifyListeners();
  }
  late double _netTotalPrice = 0.0;
  double get netTotalPrice => _netTotalPrice;
  set getNetTotalPrice(double value) {
    _netTotalPrice = value;
    notifyListeners();
  }

  late double _totalProductPrice = 0.0;
  double get totalProductPrice => _totalProductPrice;
  set getTotalProductPrice(double value) {
    _totalProductPrice = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_totalProductPrice");
    notifyListeners();
  }

  late double _discountAmount = 0.0;
  double get discountAmount => _discountAmount;
  set getDiscountAmount(double value) {
    _discountAmount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_discountAmount");
    notifyListeners();
  }

  late double _vatAmountRate = 0.0;
  double get vatAmountRate => _vatAmountRate;
  set getvatAmountRate(double value) {
    _vatAmountRate = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late double _disAmountRate = 0.0;
  double get disAmountRate => _disAmountRate;
  set getDisAmountRate(double value) {
    _disAmountRate = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late double _disAmount = 0.0;
  double get disAmount => _disAmount;
  set getDisAmount(double value) {
    _disAmount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late String _pTCodeDisc = "";
  String get pTCodeDisc => _pTCodeDisc;
  set getPtCodeDisc(String value) {
    _pTCodeDisc = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late String _pTCodeVat = "";
  String get pTCodeVat => _pTCodeVat;
  set getPtCodeVat(String value) {
    _pTCodeVat = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late double _totalBillWise = 0.0;
  double get totalBillWise => _totalBillWise;
  set getTotalBillWise(double value) {
    _totalBillWise = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_totalBillWise");
    notifyListeners();
  }

  //   required this.bTerm1,
  // required this.bTerm1Rate,
  // required this.bTerm1Amount,

  late String _bTerm1 = "";
  String get bTerm1 => _bTerm1;
  set getBTerm1(String value) {
    _bTerm1 = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }
  late double _bTerm1Rate = 0.00;
  double get bTerm1Rate => _bTerm1Rate;
  set getBTerm1Rate(double value) {
    _bTerm1Rate = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late double _bTerm1Amount = 0.00;
  double get bTerm1Amount => _bTerm1Amount;
  set getBTerm1Amount(double value) {
    _bTerm1Amount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late String _bTerm2 = "";
  String get bTerm2 => _bTerm2;
  set getBTerm2(String value) {
    _bTerm2 = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }
  late double _bTerm2Rate = 0.00;
  double get bTerm2Rate => _bTerm2Rate;
  set getBTerm2Rate(double value) {
    _bTerm2Rate = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }
  late double _bTerm2Amount = 0.00;
  double get bTerm2Amount => _bTerm2Amount;
  set getBTerm2Amount(double value) {
    _bTerm2Amount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late String _bTerm3 = "";
  String get bTerm3 => _bTerm3;
  set getBTerm3(String value) {
    _bTerm3 = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }
  late double _bTerm3Rate = 0.00;
  double get bTerm3Rate => _bTerm3Rate;
  set getBTerm3Rate(double value) {
    _bTerm3Rate = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }
  late double _bTerm3Amount = 0.00;
  double get bTerm3Amount => _bTerm3Amount;
  set getBTerm3Amount(double value) {
    _bTerm3Amount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }
  late double _vatAmtTotal = 0.0;
  double get vatAmtTotal => _vatAmtTotal;
  set getVatAmount(double value) {
    _vatAmtTotal = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late double _vatAmt = 0.00;
  double get vatAmt => _vatAmt;

  set setVatAmt (double value){
    _vatAmt += value;
    notifyListeners();
  }

  late double _billDiscountRate = 0.00;
  double get billDiscountRate => _billDiscountRate;

  set setBillDiscountRate (double value){
    _billDiscountRate = value;
    notifyListeners();
  }

  late double _billDiscountRateAmount = 0.00;
  double get billDiscountRateAmount => _billDiscountRateAmount;

  set setBillDiscountRateAmount (double value){
    _billDiscountRateAmount = value;
    notifyListeners();
  }

  late double _billDiscountAmount = 0.00;
  double get billDiscountAmount => _billDiscountAmount;

  set setBillDiscountAmount (double value){
    _billDiscountAmount = value;
    notifyListeners();
  }

  late double _billVatRate = 0.00;
  double get billVatRate => _billVatRate;

  set setBillVatRate (double value){
    _billVatRate = value;
    notifyListeners();
  }

  late double _billVatAmount = 0.00;
  double get billVatAmount => _billVatAmount;

  set setBillVatAmount (double value){
    _billVatAmount = value;
    notifyListeners();
  }

  late String _PTerm1Code = "";
  String get PTerm1Code => _PTerm1Code;
  set getPTerm1Code(String value) {
    _PTerm1Code = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late double _PTerm1Rate = 0.0;
  double get PTerm1Rate => _PTerm1Rate;
  set getPTerm1Rate(double value) {
    _PTerm1Rate = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late double _PTerm1Amount = 0.0;
  double get PTerm1Amount => _PTerm1Amount;
  set getPTerm1Amount(double value) {
    _PTerm1Amount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
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

  late double _discBill = 0.0;
  double get discBill => _discBill;
  set getDiscBill(double value) {
    _discBill = value;
    notifyListeners();
  }

  late double _vatBill = 0.0;
  double get vatBill => _vatBill;
  set getVatBill(double value) {
    _vatBill = value;
    notifyListeners();
  }

  late double _discBill2 = 0.0;
  double get discBill2 => _discBill2;
  set getDiscBill2(double value) {
    _discBill2 = value;
    notifyListeners();
  }

  late double _vatBill2 = 0.0;
  double get vatBill2 => _vatBill2;
  set getVatBill2(double value) {
    _vatBill2 = value;
    notifyListeners();
  }

    showVatDiscAmount(){
    if(sign1 == "-"){
      getDiscBill = bTerm1Amount;
    }else if(sign1 == "+"){
      getVatBill = bTerm1Amount;
    }
    if(sign2 == "-"){
      getDiscBill = bTerm2Amount;
    }else if(sign2 == "+"){
      getVatBill = bTerm2Amount;
    }
    if(sign3 == "-"){
      getDiscBill = bTerm3Amount;
    }else if(sign3 == "+"){
      getVatBill = bTerm3Amount;
    }
    notifyListeners();
  }

  showVatDiscAmountBill(){
    if(bSign1 == "-"){
      getDiscBill2 = bTerm1Amount;
    }else if(bSign1 == "+"){
      getVatBill2 = bTerm1Amount;
    }
    if(bSign2 == "-"){
      getDiscBill2 = bTerm2Amount;
    }else if(bSign2 == "+"){
      getVatBill2 = bTerm2Amount;
    }
    if(bSign3 == "-"){
      getDiscBill2 = bTerm3Amount;
    }else if(bSign3 == "+"){
      getVatBill2 = bTerm3Amount;
    }
    notifyListeners();
  }

  late String _PTerm2Code = "";
  String get PTerm2Code => _PTerm2Code;
  set getPTerm2Code(String value) {
    _PTerm2Code = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late double _PTerm2Rate = 0.0;
  double get PTerm2Rate => _PTerm2Rate;
  set getPTerm2Rate(double value) {
    _PTerm2Rate = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late double _PTerm2Amount = 0.0;
  double get PTerm2Amount => _PTerm2Amount;
  set getPTerm2Amount(double value) {
    _PTerm2Amount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late String _PTerm3Code = "";
  String get PTerm3Code => _PTerm3Code;
  set getPTerm3Code(String value) {
    _PTerm3Code = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late double _PTerm3Rate = 0.0;
  double get PTerm3Rate => _PTerm3Rate;
  set getPTerm3Rate(double value) {
    _PTerm3Rate = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }

  late double _PTerm3Amount = 0.0;
  double get PTerm3Amount => _PTerm3Amount;
  set getPTerm3Amount(double value) {
    _PTerm3Amount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_vatAmountRate");
    notifyListeners();
  }




  calculate() async {
    if (_quantity.text.isEmpty || _salesRate.text.isEmpty) {
      getTotalPrice = 0.00;
      getTotalSalesPrice = 0.00;
    }

    ///
    else {
      getTotalPrice=0.00;
      double tempTotal = double.parse(_quantity.text)*double.parse(_salesRate.text);
      getTotalSalesPrice = tempTotal;
      double vatAmount =(tempTotal * PTerm2Rate)/100;
      double grand = tempTotal+vatAmount;
      double discount = (grand*PTerm1Rate)/100;
      double finalPrice = tempTotal +vatAmount - discount;


      getTotalPrice = tempTotal  + vatAmount  - PTerm1Amount;
      getNetTotalPrice = tempTotal  + vatAmount  - PTerm1Amount;
    }

    ///
    notifyListeners();
  }

  calculateBillWise() async {
    if (_quantity.text.isEmpty || _salesRate.text.isEmpty) {
      getTotalPrice = 0.00;
    }

    ///
    else {
      getTotalPrice=0.00;
      double tempTotal = double.parse(_quantity.text)*double.parse(_salesRate.text);
      double vatAmount =(tempTotal * PTerm2Rate)/100;
      double grand = tempTotal+vatAmount;
      double discount = (grand*PTerm1Rate)/100;
      double finalPrice = tempTotal +vatAmount - discount;


      getTotalPrice = tempTotal  + vatAmount  - PTerm1Amount;
      getNetTotalPrice = tempTotal  + vatAmount  - PTerm1Amount;
    }

    ///
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

  saveTempProduct() async {
    //if (_orderFormKey.currentState!.validate()) {
      final productState = Provider.of<ProductState>(context, listen: false);
      TempProductOrderModel orderProduct = TempProductOrderModel(
        pCode: _productDetail.pCode,
        pName: _productDetail.pDesc,
        rate: _salesRate.text.trim(),
        quantity: _quantity.text.trim(),

        pTerm1Code: PTerm1Code.toString(),
        pTerm1Rate: PTerm1Rate.toString(),
        pTerm1Amount: PTerm1Amount.toString(),
        sign1: sign1.toString(),

        pTerm2Code: PTerm2Code.toString(),
        pTerm2Rate: PTerm2Rate.toString(),
        pTerm2Amount: PTerm2Amount.toString(),
        sign2: sign2.toString(),

        pTerm3Code: PTerm3Code.toString(),
        pTerm3Rate: PTerm3Rate.toString(),
        pTerm3Amount: PTerm3Amount.toString(),
        sign3: sign3.toString(),

        totalAmount: _totalPrice.toStringAsFixed(2),

      );

      await TempProductOrderDatabase.instance.insertData(orderProduct);
      getPTerm1Amount = 0.0;
      getPTerm2Amount = 0.0;
      getPTerm3Amount = 0.0;

      getBTerm1Amount = 0.0;
      getBTerm2Amount = 0.0;
      getBTerm3Amount = 0.0;
      getTotalSalesPrice = 0.0;
      productState.getProductListFromDB(
          groupName: productState.selectedGroup.groupName);
      navigator.pop();
      notifyListeners();
  //  }
  }

  // after this the selected item will go to the list
  /// [ ALL ORDER LIST IS FOR ORDER EDIT AND DELETE ]
  late List<TempProductOrderModel> _allTempOrderList =
      <TempProductOrderModel>[];

  List<TempProductOrderModel> get allTempOrderList => _allTempOrderList;

  set getAllTempOrderList(List<TempProductOrderModel> value) {
    _allTempOrderList.clear();
    _allTempOrderList = value;
    notifyListeners();
  }

  late List<ProductOrderModel> _allProductBillWiseList = <ProductOrderModel>[];

  List<ProductOrderModel> get allProductBillWiseOrderList => _allProductBillWiseList;

  set getAllProductBillWiseOrderList(List<ProductOrderModel> value) {
    _allProductBillWiseList.clear();
    _allProductBillWiseList = value;
    notifyListeners();
  }

  getAllTempProductOrderList() async {
    await TempProductOrderDatabase.instance.getAllProductList().then((value) {
      getAllTempOrderList = value;
    });
    notifyListeners();
  }

  getProductBillWiseOrderList() async {
    await ProductOrderDatabase.instance.getAllProductAndBillWiseList().then((value) {
      getAllProductBillWiseOrderList = value;
    });

    notifyListeners();
  }

  updateTempOrderProductDetail({
    required String productID,
    required String rate,
    required String quantity,
  }) async {
    await TempProductOrderDatabase.instance
        .editDataById(productID: productID, rate: rate, quantity: quantity)
        .then((value) {
      getAllTempOrderList = value;
    });
    await getAllTempProductOrderList();

    notifyListeners();
  }

  deleteTempOrderProduct({required String productID}) async {
    await TempProductOrderDatabase.instance
        .deleteDataByID(productID);
    await getAllTempProductOrderList();

    notifyListeners();
  }
  dublicateProduct({required String productID}) async {
    await TempProductOrderDatabase.instance
        .dublicateExit(productID);
    await getAllTempProductOrderList();

    notifyListeners();
  }



  Future productOrderAPICall(BuildContext ctx) async {
    CustomLog.warningLog(value: "\n\n\n\n");
    CustomLog.warningLog(value: "SASDASDASDASD");
    CustomLog.warningLog(value: "\n\n\n\n");
    try {
      getLoading = true;
      getCompanyDetail = await GetAllPref.companyDetail();
      BasicModel modelData = await OrderProductAPI.postOrder(
        bodyData: await getFormatPOSTDATA(),
      );
      if (modelData.status == true) {
        await SetAllPref.setVoucherNo(value: modelData.message);
        await ProductOrderDatabase.instance.deleteData();
        await productOrderComplete(ctx, true, "Sales successfully !!!");
        Navigator.pushNamedAndRemoveUntil(context, indexPath, (route) => false);


      } else {
        await ProductOrderDatabase.instance.deleteData();
        await TempProductOrderDatabase.instance.deleteData();
        await productOrderComplete(ctx, false, "Something wrong");
        setImageData = "";
        setIsChecked = false;
      }
    } catch (e) {
      debugPrint('The error is the $e');
    }
    notifyListeners();
  }

  productOrderComplete(BuildContext ctx, bool isSuccess, String message) async {
    getLoading = false;
    Fluttertoast.showToast(msg: message);
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
    for (var element in allTempOrderList) {
      _totalBalance += double.parse(element.totalAmount);
     // _totalBalance += vatAmt;
    }
  //  showVatDiscAmount();
    showVatDiscAmountBill();
    return _totalBalance.toStringAsFixed(2);
  }

  calculateBillTerm()  {
    double net = 0.00;
    getTotalBillWise=0.00;

    if(bSign1 == "-"){
      getDiscBill = bTerm1Amount;
    }else if(bSign1 == "+"){
      getVatBill = bTerm1Amount;
    }
    if(bSign2 == "-"){
      getDiscBill = bTerm2Amount;
    }else if(bSign2 == "+"){
      getVatBill = bTerm2Amount;
    }
    if(bSign3 == "-"){
      getDiscBill = bTerm3Amount;
    }else if(bSign3 == "+"){
      getVatBill = bTerm3Amount;
    }

    double netAmount = double.parse(calculateTotalAmount());
    net += netAmount-discBill+vatBill;
    getTotalBillWise = net;
    notifyListeners();

    // double net = 0.00;
    // getTotalBillWise=0.00;
    // double netAmount = double.parse(calculateTotalAmount());
    // net += netAmount-bTerm1Amount+bTerm2Amount;
    // getTotalBillWise = net;
    // notifyListeners();
  }

  List<String> options = ['By Visit', 'By Phone/SMS'];
  late int selectedOption;

  late String _outletCode;

  String get outletCode => _outletCode;

  set outletCode(String value) {
    _outletCode = value;
    notifyListeners();
  }

  onAddCommentInit() async {
    _orderOption = "";
    _comment = TextEditingController(text: "");
    _isLoading = false;
  }



  late String _orderOption = "";

  String get orderOption => _orderOption;

  set getOrderOption(String value) {
    _orderOption = "";
    _orderOption = value;
    notifyListeners();
  }

  String? PrintOrNot = "";

  List<OutletDataModel> _listCustomer = [];
  List<OutletDataModel>  get listCustomer => _listCustomer;

  set getcustomerList(List<OutletDataModel> customerList) {
    _listCustomer = customerList;
    notifyListeners();
  }

  final _commentKey = GlobalKey<FormState>();
  final _orderFormKey = GlobalKey<FormState>();
  final _clientKey = GlobalKey<FormState>();

  GlobalKey<FormState> get commentKey => _commentKey;

  GlobalKey<FormState> get orderFormKey => _orderFormKey;

  GlobalKey<FormState> get clientKey => _clientKey;

  // late TextEditingController _comment = TextEditingController(text: "");
  //
  // TextEditingController get comment => _comment;

  late TextEditingController _customerCode = TextEditingController(text: "");

  TextEditingController get customerCode => _customerCode;

  Future onFinalOrderSaveToDB() async {
    CustomLog.actionLog(
        value: "TEMP ORDER COUNT  => ${_allTempOrderList.length}");
    for (var element in _allTempOrderList) {

      ProductOrderModel finalOrder = ProductOrderModel(
        itemCode: element.pCode,
        pName: element.pName,
        qty: element.quantity,
        rate: element.rate,
        totalAmt: element.totalAmount,
        netTotalAmt: (double.parse(element.quantity) * double.parse(element.rate)).toString(),
        pTerm1Code: element.pTerm1Code,
        pTerm1Rate: element.pTerm1Rate,
        pTerm1Amount: element.pTerm1Amount,
        pTerm2Code: element.pTerm2Code,
        pTerm2Rate: element.pTerm2Rate,
        pTerm2Amount: element.pTerm2Amount,

        pTerm3Code: element.pTerm3Code,
        pTerm3Rate: element.pTerm3Rate,
        pTerm3Amount: element.pTerm3Amount,

        bTerm1: bTerm1.toString(),
        bTerm1Rate: bTerm1Rate.toString(),
        bTerm1Amount: bTerm1Amount.toString(),
        bSign1: bSign1.toString(),
        bTerm2: bTerm2.toString(),
        bTerm2Rate: bTerm2Rate.toString(),
        bTerm2Amount: bTerm2Amount.toString(),
        bSign2: bSign2.toString(),
        bTerm3: bTerm3.toString(),
        bTerm3Rate: bTerm3Rate.toString(),
        bTerm3Amount: bTerm3Amount.toString(),
        bSign3: bSign3.toString(),
        godownCode: '',
        dbName: _companyDetail.dbName,
        salesImage: '',
        imagePath: '',
        outletCode: await GetAllPref.outLetCode() ?? '',
        unit: await GetAllPref.unitCode(),
        sign1: element.sign1,
        sign2: element.sign2,
        sign3: element.sign3,
      );
      await ProductOrderDatabase.instance.insertData(finalOrder);
      await getProductBillWiseOrderList();
    }

    if(PrintOrNot == "pdf") {
      onPrint(name: "name");
    } else if(PrintOrNot == "print") {
      printReceipt(value: allProductBillWiseOrderList);
    }else{
      await TempProductOrderDatabase.instance.deleteData();
    //  await ProductOrderDatabase.instance.deleteData();
    }
  }

  Future<List<OutletDataModel>> getDataList() async {
   // getCompanyDetail = await GetAllPref.companyDetail();
    OutletModel outletData = await OutletList.partyList(
      dbName: _companyDetail.dbName,
    );
    if (outletData.statusCode == 200) {
    //  getcustomerList = outletData.data;
      return outletData.data;
    } else {
     // ShowToast.errorToast(msg: "ads  "+_companyDetail.dbName +" Failed to get data" );
      return [];
    }
  }

  String? selectedGlCode;

  //File selectedImage;


 late String? _customer ;
  String?  get customer => _customer;

  set getCustomer(String? customer) {
    _customer = customer;
    notifyListeners();
  }


  late List<OrderPostModel> _orderPostDataList = [];

  List<OrderPostModel> get orderPostDataList => _orderPostDataList;

  set getOrderPostData(List<OrderPostModel> value) {
    _orderPostDataList = value;
    notifyListeners();
  }

  getFormatPOSTDATA() async {
    return await ProductOrderDatabase.instance.getPostDataASFormatNeeded(
      dbName: _companyDetail.dbName,
      unitCode: await GetAllPref.unitCode(),
      salesImage: imageData,
      imagePath: await GetAllPref.baseImageURL(),
      companyInitial: await GetAllPref.companyInitial(),
    );
  }




  onPrint({required String name}) async {
    double quantity = 0;
    double rate = 0.00;
    double totalAMT = 0.00;
    double termDisc = 0.00;
    double termVatAmt = 0.00;
    double termAdditionalAmt = 0.00;
    double bterm1Disc = 0.00;
    double bterm2VatAmt = 0.00;
    int i = 1;
     String sign1="";
     String sign2="";
     String sign3 = "";

    for (var value in allProductBillWiseOrderList) {
      quantity += double.parse(value.pTerm1Amount);
      rate += double.parse(value.pTerm1Amount);
      totalAMT += double.parse(value.totalAmt);
      termDisc += double.parse(value.pTerm1Amount);
      termVatAmt += double.parse(value.pTerm2Amount);
      termAdditionalAmt += double.parse(value.pTerm3Amount);
      bterm1Disc = double.parse(value.bTerm1Amount);
      bterm2VatAmt = double.parse(value.bTerm2Amount);
      sign1 = value.sign1;
      sign2 = value.sign2;
      sign3 = value.sign3;

      final pdfFile = await PdfInvoiceProductSales.generate(
        indexes: i++,
        companyDetails: _companyDetail,
        qty: quantity,
        rate: rate,
        pTermDic :termDisc,
        pTermVat :termVatAmt,
        pTermAdditional: termAdditionalAmt,
        bTermDisc1 :bterm1Disc,
        bTermVat2 :bterm2VatAmt,
        customerName: await GetAllPref.customerName(),
        productList: allProductBillWiseOrderList,
        totalAmount: totalAMT,
        sign1: sign1,
        sign2: sign2,
        sign3: sign3,
        voucherNo: await GetAllPref.getVoucher(),
      );

      ////  opening the pdf file

      FileHandleApiSalesProduct.openFile(pdfFile);
    }

    await TempProductOrderDatabase.instance.deleteData();
   // await ProductOrderDatabase.instance.deleteData();
    notifyListeners();
  }

  Future<void> printReceipt({required List<ProductOrderModel> value}) async {
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    /// COMPANY NAME
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.setCustomFontSize(21);
    await SunmiPrinter.printText(_companyDetail.aliasName);
    ///
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.setCustomFontSize(19);
    await SunmiPrinter.printText(_companyDetail.companyAddress);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.setCustomFontSize(19);
    if (_companyDetail.vatNo.isNotEmpty) {
      await SunmiPrinter.printText('PAN No. : ${_companyDetail.vatNo}');
    }
    /// BILL TITLE
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    // if (_companyDetail.vatNo.isNotEmpty) {
    // await SunmiPrinter.printText('INVOICE');
    // } else {
    await SunmiPrinter.printText('SALES INVOICE');
    // }
    await SunmiPrinter.setCustomFontSize(19);
    await SunmiPrinter.printText('Invoice No : ${await GetAllPref.getVoucher()}');
    await SunmiPrinter.setCustomFontSize(19);
    await SunmiPrinter.printText('Name : ${await GetAllPref.customerName()}');
    await SunmiPrinter.setCustomFontSize(19);
    await SunmiPrinter.printText('Address : ${await GetAllPref.customerAddress()}');
    await SunmiPrinter.line();
    await SunmiPrinter.setCustomFontSize(19);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Sn.",
        width: 4,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "Item",
        width: 15,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "Qty",
        width: 5,
        align: SunmiPrintAlign.CENTER,
      ),
      ColumnMaker(
        text: "Rate",
        width: 7,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "Total",
        width: 9,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    await SunmiPrinter.line();
    await SunmiPrinter.setCustomFontSize(19);
    double grandTotal = 0.0;
    int i = 0;
    for (var item in value) {
      i++;
      await SunmiPrinter.setFontSize(SunmiFontSize.SM);
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: '${i.toString()}.',
          width: 4,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: item.pName,
          width: 15,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: item.qty,
          width: 5,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          text: item.rate,
          width: 7,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: item.totalAmt,
          width: 9,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
      grandTotal += double.parse(item.totalAmt);
      await SunmiPrinter.lineWrap(0);
    }

    await SunmiPrinter.line();
    await SunmiPrinter.setCustomFontSize(19);
       await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Grand Total:",
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: grandTotal.toStringAsFixed(2),
        width: 10,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    await SunmiPrinter.line();
    await SunmiPrinter.printText('Prepared by : ${ await GetAllPref.userName()}');
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText("Thank you");

     await SunmiPrinter.submitTransactionPrint();
     await SunmiPrinter.lineWrap(3);
    await SunmiPrinter.exitTransactionPrint(true);
  }
}
