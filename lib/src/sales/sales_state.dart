import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/sales/api/sales_api.dart';
import 'package:retail_app/src/sales/db/product_sales_db.dart';
import 'package:retail_app/src/sales/db/temp_product_sales_db.dart';
import 'package:retail_app/src/sales/model/godown_model.dart';
import 'package:retail_app/src/sales/model/outlet_model.dart';
import 'package:retail_app/src/sales/model/post_sales_model.dart';
import 'package:retail_app/src/sales/model/product_sales_model.dart';
import 'package:retail_app/src/sales/model/temp_product_sales_model.dart';
import 'package:retail_app/src/sales/pdf/sales_product_pdf.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import '../../../model/model.dart';
import '../../constants/assets_list.dart';
import '../../native_android/native_bridge.dart';
import '../../services/router/router_name.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';
import '../imagepicker/image_picker_state.dart';
import '../pdf/sales_bill_pdf.dart';
import '../print_bill/print_bill.dart';
import '../products/products.dart';
import 'components/sales_alert_section.dart';
import 'model/sale_payment_mode.dart';

class ProductOrderState extends ChangeNotifier {
  ProductOrderState();

  late BuildContext _context;

  BuildContext get context => _context;
  late final NavigatorState navigator = Navigator.of(_context);

  set getContext(BuildContext value) {
    _context = value;
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

  double altCountAltQty = 0.0;

  init() async {
    await AppServiceBridge.initService();
    await AppServiceBridge.bindService();
    await getAllTempProductOrderList();
    await getProductBillWiseOrderList();
    await clear2();
    await checkConnection();
    await salesPaymentModeApiCall();
    await godownListApiCall();
    // selectedGlCode = null;
    getCustomer = null;
    altCountAltQty = 0.0;
    // await getOutletInfoState();
  }

  checkConnection() async {
    // Fluttertoast.showToast(msg: "daba");
    CheckNetwork.check().then((network) async {
      getCompanyDetail = await GetAllPref.companyDetail();
      // await getAllTempProductOrderList();
      // await getProductBillWiseOrderList();
      //  clear2();
      if (network) {
        //  await networkSuccess();
      } else {
        // await getGroupProductListFromDB();
      }
    });
  }

  clear2() {
    _companyDetail = CompanyDetailsModel.fromJson({});

    setBillDiscountAmount = 0.00;
    setBillVatAmount = 0.00;
    _salesPaymentModeCode ="";
    paymentType = "";
    paymentMode = "";
    _referenceId = "";
    _godownCode = "";
  }

  godownClear(){
    _godownCode = "";
    _godownList = [];
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
    _altQuantity = TextEditingController(text: "0.00");
    _totalAmountController = TextEditingController(text: "0.00");

    // Total Price = Total Amount of the single product (ie rate * quantity)
    _totalPrice = 0.0;

    getvatAmountRate = 0.00;
    getDiscountAmount = 0.00;
    getVatAmount = 0.00;
    getDisAmountRate = 0.00;
    getDisAmount = 0.00;
    _isImageAdd = false;
    getTotalSalesPrice = 0.00;
    getTotalPrice = 0.00;
    paymentType = "";
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

  late TextEditingController _altQuantity = TextEditingController(text: "0");

  TextEditingController get altQuantity => _altQuantity;

  late TextEditingController _salesRate = TextEditingController(text: "");

  TextEditingController get salesRate => _salesRate;

  late TextEditingController _totalAmountController = TextEditingController(text: "");

  TextEditingController get totalAmountController => _totalAmountController;

  late TextEditingController _discountRate = TextEditingController(text: "");

  TextEditingController get discountRate => _discountRate;

  late TextEditingController _discountAmt = TextEditingController(text: "");

  TextEditingController get discountAmt => _discountAmt;

  late TextEditingController _comment = TextEditingController(text: "");

  TextEditingController get comment => _comment;
  late TextEditingController _tenderAmount = TextEditingController(text: "0.0");

  TextEditingController get tenderAmount => _tenderAmount;

  set getComment(String value) {
    _comment.text = value;
    notifyListeners();
  }

  set getTenderAmount(String value) {
    _tenderAmount.text = value;
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
  set getTotalAmount(String value) {
    _totalAmountController.text = value;
    notifyListeners();
  }

  // late File? _selectedImage ;
  // File? get selectedImage => _selectedImage!;
  //
  // set setImageFile (File? value){
  //   _selectedImage = value;
  //   notifyListeners();
  // }imageData

  late String paymentType = "";

  late bool _isChecked = false;

  bool get isChecked => _isChecked;

  set setIsChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }

  late String _imageData = "";

  String get imageData => _imageData;

  set setImageData(String value) {
    _imageData = value;
    notifyListeners();
  }

  late String _imageName = "";

  String get imageName => _imageName;

  set setimageName(String value) {
    _imageName = value;
    notifyListeners();
  }

  late double _totalPrice = 0.0;
  late double _subTotal = 0.0;

  double get totalPrice => _totalPrice;
  double get subTotal => _subTotal;

  set getSubTotal(double value) {
    _subTotal = value;
    notifyListeners();
  }

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

  String _scannerQrCode = "ScannerQrCode";

  String get scannerQrCode => _scannerQrCode;

  set setScannerQrCode(String value) {
    _scannerQrCode = value;
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

  String _paymentMode = "Credit";

  String get paymentMode => _paymentMode;

  set paymentMode(String value) {
    _paymentMode = value;
    notifyListeners();
  }

  late bool _dataInserted = false;

  bool get dataInserted => _dataInserted;

  set setDataInserted(bool value) {
    _dataInserted = value;
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

  set setVatAmt(double value) {
    _vatAmt += value;
    notifyListeners();
  }

  late double _billDiscountRate = 0.00;

  double get billDiscountRate => _billDiscountRate;

  set setBillDiscountRate(double value) {
    _billDiscountRate = value;
    notifyListeners();
  }

  late double _billDiscountRateAmount = 0.00;

  double get billDiscountRateAmount => _billDiscountRateAmount;

  set setBillDiscountRateAmount(double value) {
    _billDiscountRateAmount = value;
    notifyListeners();
  }

  late double _billDiscountAmount = 0.00;

  double get billDiscountAmount => _billDiscountAmount;

  set setBillDiscountAmount(double value) {
    _billDiscountAmount = value;
    notifyListeners();
  }

  late double _billVatRate = 0.00;

  double get billVatRate => _billVatRate;

  set setBillVatRate(double value) {
    _billVatRate = value;
    notifyListeners();
  }

  late double _billVatAmount = 0.00;

  double get billVatAmount => _billVatAmount;

  set setBillVatAmount(double value) {
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

  showVatDiscAmount() {
    if (sign1 == "-") {
      getDiscBill = bTerm1Amount;
    } else if (sign1 == "+") {
      getVatBill = bTerm1Amount;
    }
    if (sign2 == "-") {
      getDiscBill = bTerm2Amount;
    } else if (sign2 == "+") {
      getVatBill = bTerm2Amount;
    }
    if (sign3 == "-") {
      getDiscBill = bTerm3Amount;
    } else if (sign3 == "+") {
      getVatBill = bTerm3Amount;
    }
    notifyListeners();
  }

  showVatDiscAmountBill() {
    if (bSign1 == "-") {
      getDiscBill2 = bTerm1Amount;
    } else if (bSign1 == "+") {
      getVatBill2 = bTerm1Amount;
    }
    if (bSign2 == "-") {
      getDiscBill2 = bTerm2Amount;
    } else if (bSign2 == "+") {
      getVatBill2 = bTerm2Amount;
    }
    if (bSign3 == "-") {
      getDiscBill2 = bTerm3Amount;
    } else if (bSign3 == "+") {
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

  late String _isCashOrCredit = "Credit";

  String get isCashOrCredit => _isCashOrCredit;

  set getIsCashOrCredit(String value) {
    _isCashOrCredit = value;
    notifyListeners();
  }

  late bool _isImageAdd = false;

  bool get isImageAdd => _isImageAdd;

  set getIsImageAdd(bool value) {
    _isImageAdd = value;
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

  String lastEditedField = ""; // Track the last edited field
  calculate1() async {
    if (_quantity.text.isEmpty ||
        _salesRate.text.isEmpty ||
        _altQuantity.text.isEmpty) {
      getTotalPrice = 0.00;
      // = 0.00;
//getTotalAlt = 0.00;
      // getTotalPriceWithVat = 0.00;
    } else {
      if (double.parse(productDetail.altQty) > 0) {
        try {
          if (lastEditedField == "altQty" && _altQuantity.text != '0.00') {
            double quantityFactor = double.parse(_altQuantity.text) *
                double.parse(productDetail.altQty);
            debugPrint('AltQty to Quantity: $quantityFactor');
            _quantity.text = quantityFactor.toStringAsFixed(1);
          } else if (lastEditedField == "quantity" && _quantity.text != '0.00') {
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
        double quantity = double.parse(_quantity.text);
        double salesRate = double.parse(_salesRate.text);

        double totalWithVat = (quantity * salesRate * 13) / 100;
        // getTotalVat = totalWithVat;
        // getTotalPriceWithVat = quantity * salesRate;
        getTotalPrice = quantity * salesRate;
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error in calculation');
      }
    }
    notifyListeners();
  }

  calculate({salsesRate}) async {
    double quantityFactor = 0.00;
   // Fluttertoast.showToast(msg: 'Invalid number formatff  $salsesRate');
    if (_quantity.text.isEmpty ||
        _salesRate.text.isEmpty ||
        _altQuantity.text.isEmpty) {
      getTotalPrice = 0.00;
      getTotalSalesPrice = 0.00;
      altCountAltQty = 0.00;
    } else {
      if (double.parse(productDetail.altQty) > 0) {
    //    Fluttertoast.showToast(msg: "msg");
        try {
          if (lastEditedField == "altQty" && _altQuantity.text != '0.00') {
            quantityFactor = double.parse(_altQuantity.text) *
                double.parse(productDetail.altQty);
            debugPrint('AltQty to Quantity: $quantityFactor');
            _quantity.text = quantityFactor.toStringAsFixed(1);

            if(_totalAmountController.text == ""){
             // Fluttertoast.showToast(msg: _salesRate.text);
              _salesRate.text = "0.00";
            }else{
              _salesRate.text = (double.parse(_totalAmountController.text) / double.parse(_quantity.text)).toString();
            }

          //  Fluttertoast.showToast(msg: _salesRate.text);
          } else if (lastEditedField == "quantity" &&
              _quantity.text != '0.00') {
            double altQuantityFactor = double.parse(_quantity.text) /
                double.parse(productDetail.altQty);
            debugPrint('Quantity to AltQty: $altQuantityFactor');
            _altQuantity.text = altQuantityFactor.toStringAsFixed(1);

            altCountAltQty = altQuantityFactor;
            if(_totalAmountController.text == ""){
              _salesRate.text = "0.00";
            }else{
              _salesRate.text = (double.parse(_totalAmountController.text) / double.parse(_quantity.text)).toString();
            }
           // Fluttertoast.showToast(msg: _salesRate.text);
          }
        } catch (e) {
          _salesRate.text = "0.00";
         // Fluttertoast.showToast(msg: 'Invalid number formatff  $salsesRate');
          return;
        }
      } else {
        try {
          if (lastEditedField == "altQty" && _altQuantity.text != '0.00') {
            quantityFactor = double.parse(_altQuantity.text) *
                double.parse(productDetail.altQty);
            debugPrint('AltQty to Quantity: $quantityFactor');
            _quantity.text = quantityFactor.toStringAsFixed(1);

            if(_totalAmountController.text == ""){
              // Fluttertoast.showToast(msg: _salesRate.text);
              _salesRate.text = "0.00";
            }else{
              _salesRate.text = (double.parse(_totalAmountController.text) / double.parse(_quantity.text)).toString();
            }

            //  Fluttertoast.showToast(msg: _salesRate.text);
          } else if (lastEditedField == "quantity" &&
              _quantity.text != '0.00') {
            double altQuantityFactor = double.parse(_quantity.text) /
                double.parse(productDetail.altQty);
            debugPrint('Quantity to AltQty: $altQuantityFactor');
            _altQuantity.text = altQuantityFactor.toStringAsFixed(1);

            altCountAltQty = altQuantityFactor;
            if(_totalAmountController.text == ""){
              _salesRate.text = "0.00";
            }else{
              _salesRate.text = (double.parse(_totalAmountController.text) / double.parse(_quantity.text)).toString();
            }
            // Fluttertoast.showToast(msg: _salesRate.text);
          }
        } catch (e) {
          _salesRate.text = "0.00";
          // Fluttertoast.showToast(msg: 'Invalid number formatff  $salsesRate');
          return;
        }

      }

      try {
        getTotalPrice = 0.00;
        double tempTotal =
            (double.parse(_quantity.text)) * double.parse(_salesRate.text);
        getTotalSalesPrice = tempTotal;
        double vatAmount = (tempTotal * PTerm2Rate) / 100;
        double grand = tempTotal + vatAmount;
        double discount = (grand * PTerm1Rate) / 100;
        double finalPrice = tempTotal + vatAmount - discount;

        getTotalPrice = tempTotal + vatAmount - PTerm1Amount;
        getNetTotalPrice = tempTotal + vatAmount - PTerm1Amount;
      } catch (e) {}
      //alt quantity
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
      getTotalPrice = 0.00;
      double tempTotal =
          double.parse(_quantity.text) * double.parse(_salesRate.text);
      double vatAmount = (tempTotal * PTerm2Rate) / 100;
      double grand = tempTotal + vatAmount;
      double discount = (grand * PTerm1Rate) / 100;
      double finalPrice = tempTotal + vatAmount - discount;

      getTotalPrice = tempTotal + vatAmount - PTerm1Amount;
      getNetTotalPrice = tempTotal + vatAmount - PTerm1Amount;
    }

    ///
    notifyListeners();
  }

  calculateProductQty() async {
    if (_quantity.text.isEmpty || _salesRate.text.isEmpty) {
      getTotalProductPrice = 0.00;
    } else {
      getTotalProductPrice = 0.00;
      double tempTotal =
          double.parse(_quantity.text) * double.parse(_salesRate.text);
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
      pShortName: _productDetail.pShortName,
      pName: _productDetail.pDesc,
      rate: _salesRate.text.trim().isNotEmpty ? _salesRate.text.trim() : "0.0",
      quantity:
          _quantity.text.trim().isNotEmpty ? _quantity.text.trim() : "0.0",
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
      unit: _productDetail.unit,
      altUnit: _productDetail.altUnit,
      altQty: _altQuantity.text.trim(),
     // altQty: _productDetail.altQty,
      hsCode: _productDetail.hsCode,
      factor: _altQuantity.text.trim(),
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
    await getAllTempProductOrderList();
    // navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft,
    //   child: const OrderListSection(),),);
    navigator.pop();
    notifyListeners();
    //  }
  }

  saveTempProductScanSata({required ProductDataModel product}) async {
    // ${DatabaseDetails.unit} TEXT,
    // ${DatabaseDetails.altUnit} TEXT,
    // ${DatabaseDetails.altQty} TEXT,
    // ${DatabaseDetails.hsCode} TEXT,
    //if (_orderFormKey.currentState!.validate()) {
    // final productState = Provider.of<ProductState>(context, listen: false);
    TempProductOrderModel orderProduct = TempProductOrderModel(
      pCode: product.pCode,
      pShortName: product.pShortName,
      pName: product.pDesc,
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
      unit: product.unit,
      altUnit: product.altUnit,
      altQty: product.altQty,
      hsCode: product.hsCode,
      factor: _altQuantity.text.trim() == "" ? "0.0" : _altQuantity.text.trim(),
    );

    await TempProductOrderDatabase.instance.insertData(orderProduct);
    getPTerm1Amount = 0.0;
    getPTerm2Amount = 0.0;
    getPTerm3Amount = 0.0;

    getBTerm1Amount = 0.0;
    getBTerm2Amount = 0.0;
    getBTerm3Amount = 0.0;
    getTotalSalesPrice = 0.0;
    // productState.getProductListFromDB(
    //     groupName: productState.selectedGroup.groupName);

    setScannerQrCode = "ScannerQrCode";
    //  navigator.pop();
    getAllTempProductOrderList();
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

  List<ProductOrderModel> get allProductBillWiseOrderList =>
      _allProductBillWiseList;

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
    await ProductOrderDatabase.instance
        .getAllProductAndBillWiseList()
        .then((value) {
      getAllProductBillWiseOrderList = value;
    });
    notifyListeners();
  }

  List<TempProductOrderModel> _checkListExits = [];

  List<TempProductOrderModel> get checkListExits => _checkListExits;

  set setCheckListExits(List<TempProductOrderModel> value) {
    _checkListExits = value;
    notifyListeners();
  }

  Future<List<TempProductOrderModel>> checkValue(String code) async {
    _checkListExits = [];
    await TempProductOrderDatabase.instance
        .getProductAlready(pcode: code)
        .then((value) {
      if (value.isNotEmpty) {
        setCheckListExits = value;
      }
    });
    notifyListeners();
    return checkListExits;
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
    await TempProductOrderDatabase.instance.deleteDataByID(productID);
    await getAllTempProductOrderList();
    notifyListeners();
  }

  dublicateProduct({required String productID}) async {
    await TempProductOrderDatabase.instance.dublicateExit(productID);
    await getAllTempProductOrderList();
    notifyListeners();
  }

  changeUi() {
    notifyListeners();
  }

   Future<Map<String, dynamic>> callPaymentNativeCode(String saleType) async {
    getCompanyDetail = await GetAllPref.companyDetail();
    Map<String, dynamic> referenceId = await AppServiceBridge.makeTransaction(
      amount: totalBalance, // amount in smallest currency unit
     // amount: double.parse(tenderAmount.text) ?? 0.00, // amount in smallest currency unit
      transType: saleType,
      //remarks: companyDetail.companyName.toString(),
      remarks: await GetAllPref.customerName(),
    );
    notifyListeners();
    return referenceId;
  }
// Helper function with padding and truncation control
  String fixedCol(String text, int width,
      {bool rightPad = false,
        bool truncate = true}) {
    if (text.length > width && truncate) {
      text.substring(0, width);
      return text.substring(0, width+1);
    }
    int v = 0;
    if (rightPad) {
      if(text.length < width){
      v =  width-text.length;
      }
      return text.padRight(width+v);
    }else {
      if(text.length < width){
        v =  width-text.length;
      }
      return text.padLeft(width+v-v);
    }
  }
  printNative(StringBuffer content,double total) async {
    const lineWidth = 70; // Total characters per line
    // ===== FOOTER SECTION =====
    content.writeln('-' * lineWidth);
    content.writeln('${fixedCol('', 40)}${fixedCol('Total:', 10)}${fixedCol(total.toStringAsFixed(2), 12)}');
    content.writeln('-' * lineWidth);
    content.writeln(fixedCol('Remarks: ${comment.text}', lineWidth, rightPad: true));
    content.writeln(fixedCol('Printed Date: ${await MyDate.showDateTime()}', lineWidth, rightPad: true));
    content.writeln(fixedCol('Prepared by: ${await GetAllPref.userName()}', lineWidth, rightPad: true));
    content.writeln();
    content.writeln(fixedCol('** THANK YOU FOR YOUR BUSINESS **', lineWidth, rightPad: true));
    content.writeln('-');
    content.writeln('-');
    content.writeln('-');
    content.writeln('-');
    content.writeln('-');

    await AppServiceBridge.printNative(
        header: "header",
        content: content,
        footer: "footer",
        companyName: "OMS|Retails",
        refrenceId: 'RefrenceNo: 12345678',
        paymentMode: "Fonepay");
  }

  String _salesPaymentModeCode = "";

  String get salesPaymentModeCode => _salesPaymentModeCode;

  List<SalePaymentModel> _salePaymentModeList = [];

  List<SalePaymentModel> get salePaymentModeList => _salePaymentModeList;

  List<GodownModel> _godownList = [];

  List<GodownModel> get godownList => _godownList;

  String _godownCode = "";
  String get godownCode => _godownCode;
  set getGodownCode(String value) {
    _godownCode = value;
    notifyListeners();
  }

  set getSalesPaymentMode(List<SalePaymentModel> value) {
    _salePaymentModeList = value;
    notifyListeners();
  }

  set getGodownList(List<GodownModel> value) {
    _godownList = value;
    notifyListeners();
  }

  set getSalePaymentModeCode(String value) {
    _salesPaymentModeCode = value;
    notifyListeners();
  }

  Future salesPaymentModeApiCall() async {
    getCompanyDetail = await GetAllPref.companyDetail();
    SalePaymentResModel salePaymentResMode =
        await SalePaymentMode.paymentMode(dbName: _companyDetail.dbName);
    if (salePaymentResMode.STATUS_CODE == 200) {
      getSalesPaymentMode = salePaymentResMode.data;
    }
  }

  Future godownListApiCall() async {
    getCompanyDetail = await GetAllPref.companyDetail();
    GodownResModel godownResModel =
    await GodownList.godown(dbName: _companyDetail.dbName);
    if (godownResModel.STATUS_CODE == 200) {
      getGodownList = godownResModel.data;
    }
  }

  String buildPrintableInvoice() {
    final sb = StringBuffer();
    const lineWidth = 62; // Total characters per line

    // Helper function with padding and truncation control
    String fixedCol(String text, int width,
        {bool rightPad = false,
          bool truncate = true}) {
      if (text.length > width && truncate) {
        return text.substring(0, width);
      }
      if (rightPad) {
        return text.padRight(width);
      }
      return text.padLeft(width);
    }

    // ===== HEADER SECTION =====
    sb.writeln(fixedCol('COMPANY NAME', lineWidth, rightPad: true));
    sb.writeln(fixedCol('123 Business Street', lineWidth, rightPad: true));
    sb.writeln(fixedCol('INVOICE', lineWidth, rightPad: true));
    sb.writeln();

    // ===== INVOICE INFO =====
    sb.writeln('${fixedCol('Bill No: KSI00000', 30)}${fixedCol('Date: 2025-05-15', 32, rightPad: true)}');
    sb.writeln('${fixedCol('PAN No: 2323423', 30)}${fixedCol('GSTIN: XXXXXXXXXXX', 32, rightPad: true)}');
    sb.writeln('-' * lineWidth);

    // ===== COLUMN DEFINITIONS =====
    final columns = [
      {'title': 'SN', 'width': 4, 'align': 'left'},
      {'title': 'HSN', 'width': 8, 'align': 'left'},
      {'title': 'ITEM', 'width': 20, 'align': 'left'},
      {'title': 'QTY', 'width': 8, 'align': 'right'},
      {'title': 'RATE', 'width': 10, 'align': 'right'},
      {'title': 'AMOUNT', 'width': 12, 'align': 'right'},
    ];

    // ===== TABLE HEADER =====
    for (var col in columns) {
      sb.write(fixedCol(col['title'].toString(),col['width'] as int,
          rightPad: col['align'] == 'left'
      ));
    }
    sb.writeln();
    sb.writeln('-' * lineWidth);

    // ===== TABLE DATA =====
    final items = [
      ['1', '0407', 'Eggs - Small (Box-1)', '100', '12.00', '1200.00'],
      ['2', '0407', 'Eggs - Medium (Box-2)', '400', '14.00', '5600.00'],

    ];

    for (var item in items) {
      for (int i = 0; i < columns.length; i++) {
        sb.write(fixedCol(
            item[i],
            columns[i]['width'] as int,
            rightPad: columns[i]['align'] == 'left'
        ));
      }
      sb.writeln();
    }

    // ===== FOOTER SECTION =====
    sb.writeln('-' * lineWidth);
    sb.writeln('${fixedCol('', 40)}${fixedCol('Sub Total:', 10)}${fixedCol('28000.00', 12)}');
    sb.writeln('${fixedCol('', 40)}${fixedCol('Tax (5%):', 10)}${fixedCol('1400.00', 12)}');
    sb.writeln('${fixedCol('', 40)}${fixedCol('Total:', 10)}${fixedCol('29400.00', 12, rightPad: true)}');
    sb.writeln('-' * lineWidth);
    sb.writeln(fixedCol('Payment Terms: 15 Days', lineWidth, rightPad: true));
    sb.writeln(fixedCol('Printed: 2025-05-15 14:30', lineWidth, rightPad: true));
    sb.writeln(fixedCol('Prepared by: Tahesh', lineWidth, rightPad: true));
    sb.writeln();
    sb.writeln(fixedCol('** THANK YOU FOR YOUR BUSINESS **', lineWidth, rightPad: true));
    sb.writeln();
    sb.writeln();
    return sb.toString();
  }

  String _referenceId = "";
  String get referenceId => _referenceId;

  set getReferenceId(String value){
    _referenceId = value;
    notifyListeners();
  }


  Future productOrderAPICall(BuildContext ctx) async {
    if (PrintOrNot == "pdf") {
      if (salesPaymentModeCode == "Card Payment" || salesPaymentModeCode == "PhonePay" || salesPaymentModeCode == "QR Payment") {
        if (salesPaymentModeCode == "Card Payment") {
          getSalePaymentModeCode = "Sale";
        }
        if (salesPaymentModeCode == "PhonePay") {
            getSalePaymentModeCode = "Fonepay";
        }
        setDataInserted = false;

        Map<String, dynamic> response = await callPaymentNativeCode(salesPaymentModeCode);
        getReferenceId = response['referenceId'];

        if (referenceId.isNotEmpty && referenceId != null) {
         await onFinalOrderSaveToDB();
          try {
            getLoading = true;
            getCompanyDetail = await GetAllPref.companyDetail();
            BasicModel modelData = await OrderProductAPI.postOrder(
              bodyData: await getFormatPOSTDATA(),
            );
            int i = 0;
            if (modelData.status == true) {
              await SetAllPref.setVoucherNo(value: modelData.message);
              await ProductOrderDatabase.instance.deleteData();
              await TempProductOrderDatabase.instance.deleteData();
              await productOrderComplete(ctx, true, "Sales successfully !!!");
              setDataInserted = false;
              onPrint(name: "name", paymentMode: paymentMode);
              StringBuffer content = StringBuffer();
              //  ===== HEADER SECTION =====
              content.writeln(fixedCol('${fixedCol('', 10)}${_companyDetail.aliasName}',62, rightPad: true));
              content.writeln(fixedCol('${fixedCol('', 10)} ${_companyDetail.companyAddress}', 62, rightPad: true));
              if (_companyDetail.vatNo.isNotEmpty) {
                content.writeln(fixedCol('${fixedCol('', 23)}PAN No : ${_companyDetail.vatNo}', 62, rightPad: true));
              }
              content.writeln(fixedCol('${fixedCol('', 32)} INVOICE', 62, rightPad: true));
              content.writeln();
              content.writeln(fixedCol('Branch      :${await GetAllPref.unitCode()}', 62, rightPad: true));
              content.writeln(fixedCol('Bill No     : ${await GetAllPref.getVoucher()}', 62, rightPad: true));
              content.writeln(fixedCol('Date        : ${await MyDate.showDateTime2()}(${await MyDate.showDateTimeNepali2()})', 62, rightPad: true));
              content.writeln(fixedCol('Name        : ${await GetAllPref.customerName()}', 62, rightPad: true));
              content.writeln(fixedCol('Address     : ${await GetAllPref.customerAddress()}', 62, rightPad: true));
              content.writeln(fixedCol('Pan No      : ${await GetAllPref.customerpanno()}', 62, rightPad: true));
              content.writeln(fixedCol('Payment Mode: $salesPaymentModeCode', 62, rightPad: true));
              content.writeln(fixedCol('ReferenceId : $referenceId', 62, rightPad: true));
              content.writeln();

              //  ===== HEADER INFO =====
              content.writeln('Sn.'.padRight(5) +
                  'HSN Item'.padRight(10) +
                  'AltQty'.padRight(8) +
                  'Qty'.padRight(8) +
                  'Rate'.padRight(6) +
                  'Total'.padRight(10));
              content.writeln('-'*69);
              double grandTotal = 0.0;
              for (var item in allProductBillWiseOrderList) {
                i++;
                // ===== INVOICE INFO =====
                content.writeln(
                    '$i'.padRight(5).substring(0, 5)+
                       // fixedCol('${item.pName} (${item.altUnit}-${item.altQty.split('.')[0]}) ',17,rightPad: true)+
                        fixedCol('${item.pName} ',10,rightPad: true)+
                        fixedCol('${item.altUnit}',3,rightPad: true)+
                        fixedCol('-',1,rightPad: true)+
                        fixedCol('${item.altQty.split('.')[0]} ',3,rightPad: true)+
                        fixedCol('${item.qty.split('.')[0]}',6,rightPad: true)+
                        fixedCol('${item.rate.length >=5 ? item.rate.substring(0,5) : item.rate.length <=3 ?  item.rate.substring(0,3) : item.rate.substring(0,4)} ',item.rate.length >=5 ? 5 :item.rate.length <=3 ?3: 4,rightPad: false)+
                        fixedCol('${item.totalAmt}',9,rightPad: true)

                );
                // content.writeln(
                //     fixedCol('$i',5,rightPad: true)+
                //         fixedCol('1234567891123',14,rightPad: true)+
                //         fixedCol('12345',6,rightPad: true)+
                //         fixedCol('1234',5,rightPad: true)+
                //         fixedCol('12345678',9,rightPad: true)
                //
                // );
                // content.writeln('$i'.padRight(5).substring(0, 5) +
                //     '${item.pName} ${item.altUnit}1234567891234567'.padRight(18).substring(0, 18) + // Truncate if too long
                //     '${item.qty}----------'.padRight(10).substring(0, 10) +
                //     '${item.rate}'.padRight(6).substring(0, 6) +
                //     '${item.totalAmt}'.padRight(12).substring(0, 12));

                // content.writeln(
                //     fixedWidth(i.toString(), 5) +
                //         fixedWidth('${item.pName} ${item.altUnit}', 16) +
                //         fixedWidth('${item.qty}', 7) +
                //         fixedWidth(item.rate.toString(), 7) +
                //         fixedWidth(item.totalAmt.toString(), 12)
                // );

                grandTotal += double.parse(item.totalAmt);
                if (i == allProductBillWiseOrderList.length) {
                  await printNative(content,grandTotal);
                }
              }
              Navigator.pushNamedAndRemoveUntil(
                  context, indexPath, (route) => false);
              printReceipt(value: allProductBillWiseOrderList);

              _isImageAdd = false;
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
      } else {
        try {
          await onFinalOrderSaveToDB();
          getLoading = true;
          getCompanyDetail = await GetAllPref.companyDetail();
          BasicModel modelData = await OrderProductAPI.postOrder(
            bodyData: await getFormatPOSTDATA(),
          );
          int i = 0;
          if (modelData.status == true) {
            await SetAllPref.setVoucherNo(value: modelData.message);
            await ProductOrderDatabase.instance.deleteData();
            await TempProductOrderDatabase.instance.deleteData();
            await productOrderComplete(ctx, true, "Sales successfully !!!");
            setDataInserted = false;
            onPrint(name: "name", paymentMode: paymentMode);
            StringBuffer content = StringBuffer();
            //  ===== HEADER SECTION =====
            content.writeln(fixedCol('${fixedCol('', 10)}${_companyDetail.aliasName}',62, rightPad: true));
            content.writeln(fixedCol('${fixedCol('', 10)} ${_companyDetail.companyAddress}', 62, rightPad: true));
            if (_companyDetail.vatNo.isNotEmpty) {
              content.writeln(fixedCol('${fixedCol('', 23)}PAN No : ${_companyDetail.vatNo}', 62, rightPad: true));
            }
            content.writeln(fixedCol('${fixedCol('', 32)} INVOICE', 62, rightPad: true));
            content.writeln();
            content.writeln(fixedCol('Branch      :${await GetAllPref.unitCode()}', 62, rightPad: true));
            content.writeln(fixedCol('Bill No     : ${await GetAllPref.getVoucher()}', 62, rightPad: true));
            content.writeln(fixedCol('Date        : ${await MyDate.showDateTime2()}(${await MyDate.showDateTimeNepali2()})', 62, rightPad: true));
            content.writeln(fixedCol('Name        : ${await GetAllPref.customerName()}', 62, rightPad: true));
            content.writeln(fixedCol('Address     : ${await GetAllPref.customerAddress()}', 62, rightPad: true));
            content.writeln(fixedCol('Pan No      : ${await GetAllPref.customerpanno()}', 62, rightPad: true));
            content.writeln(fixedCol('Payment Mode: $paymentType', 62, rightPad: true));
            content.writeln();

            //  ===== HEADER INFO =====
            content.writeln('Sn.'.padRight(5) +
                'HSN Item'.padRight(10) +
                'AltQty'.padRight(8) +
                'Qty'.padRight(8) +
                'Rate'.padRight(6) +
                'Total'.padRight(10));
            content.writeln('-'*69);
            double grandTotal = 0.0;
            for (var item in allProductBillWiseOrderList) {
              i++;
              // ===== INVOICE INFO =====
              content.writeln(
                  '$i'.padRight(5).substring(0, 5)+
                      //fixedCol('${item.pName} (${item.altUnit}-${item.altQty.split('.')[0]}) ',17,rightPad: true)+
                      fixedCol('${item.pName} ',10,rightPad: true)+
                      fixedCol('${item.altUnit}',3,rightPad: true)+
                      fixedCol('-',1,rightPad: true)+
                      fixedCol('${item.altQty.split('.')[0]} ',3,rightPad: true)+
                      fixedCol('${item.qty.split('.')[0]}',6,rightPad: true)+
                      fixedCol('${item.rate.length >=5 ? item.rate.substring(0,5) : item.rate.length <=3 ?  item.rate.substring(0,3) : item.rate.substring(0,4)} ',item.rate.length >=5 ? 5 :item.rate.length <=3 ?3: 4,rightPad: false)+
                      fixedCol('${item.totalAmt}',9,rightPad: true)

              );
              // content.writeln(
              //     fixedCol('$i',5,rightPad: true)+
              //         fixedCol('1234567891123',14,rightPad: true)+
              //         fixedCol('12345',6,rightPad: true)+
              //         fixedCol('1234',5,rightPad: true)+
              //         fixedCol('12345678',9,rightPad: true)
              //
              // );
              // content.writeln('$i'.padRight(5).substring(0, 5) +
              //     '${item.pName} ${item.altUnit}1234567891234567'.padRight(18).substring(0, 18) + // Truncate if too long
              //     '${item.qty}----------'.padRight(10).substring(0, 10) +
              //     '${item.rate}'.padRight(6).substring(0, 6) +
              //     '${item.totalAmt}'.padRight(12).substring(0, 12));

              // content.writeln(
              //     fixedWidth(i.toString(), 5) +
              //         fixedWidth('${item.pName} ${item.altUnit}', 16) +
              //         fixedWidth('${item.qty}', 7) +
              //         fixedWidth(item.rate.toString(), 7) +
              //         fixedWidth(item.totalAmt.toString(), 12)
              // );

              grandTotal += double.parse(item.totalAmt);
              if (i == allProductBillWiseOrderList.length) {
                await printNative(content,grandTotal);
              }
            }
            Navigator.pushNamedAndRemoveUntil(
                context, indexPath, (route) => false);
            _isImageAdd = false;
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
    } else if (PrintOrNot == "print") {

      // if (paymentType == "Card" || paymentType == "Fonepay") {
      //   if (paymentType == "Card") {
      //     paymentType = "Sale";
      //   }

      if (salesPaymentModeCode == "Card Payment" || salesPaymentModeCode == "PhonePay" || salesPaymentModeCode == "QR Payment") {
        if (salesPaymentModeCode == "Card Payment") {
          getSalePaymentModeCode = "Sale";
        }
        if (salesPaymentModeCode == "PhonePay") {
          getSalePaymentModeCode = "Fonepay";
        }
        setDataInserted = false;
        Map<String, dynamic> response = await callPaymentNativeCode(salesPaymentModeCode);
        getReferenceId = response['referenceId'];
        int i = 0;
         if(referenceId.isNotEmpty && referenceId != "N/A"){
           await onFinalOrderSaveToDB();
      //  if (referenceId.isEmpty) {
          try {
            getLoading = true;
            getCompanyDetail = await GetAllPref.companyDetail();
            BasicModel modelData = await OrderProductAPI.postOrder(
              bodyData: await getFormatPOSTDATA(),
            );
            int i = 0;
            if (modelData.status == true) {
              await SetAllPref.setVoucherNo(value: modelData.message);
              await ProductOrderDatabase.instance.deleteData();
              await TempProductOrderDatabase.instance.deleteData();
              await productOrderComplete(
                  ctx, true, "Sales successfully!!!");
              setDataInserted = false;
              // .printNative
              StringBuffer content = StringBuffer();
              //  ===== HEADER SECTION =====
              content.writeln(fixedCol('${fixedCol('', 10)}${_companyDetail.aliasName}',62, rightPad: true));
              content.writeln(fixedCol('${fixedCol('', 10)} ${_companyDetail.companyAddress}', 62, rightPad: true));
              if (_companyDetail.vatNo.isNotEmpty) {
                content.writeln(fixedCol('${fixedCol('', 23)}PAN No : ${_companyDetail.vatNo}', 62, rightPad: true));
              }
              content.writeln(fixedCol('${fixedCol('', 32)} INVOICE', 62, rightPad: true));
              content.writeln();
              content.writeln(fixedCol('Branch    :${await GetAllPref.unitCode()}', 62, rightPad: true));
              content.writeln(fixedCol('Bill No     : ${await GetAllPref.getVoucher()}', 62, rightPad: true));
              content.writeln(fixedCol('Date        : ${await MyDate.showDateTime2()}(${await MyDate.showDateTimeNepali2()})', 62, rightPad: true));
              content.writeln(fixedCol('Name      : ${await GetAllPref.customerName()}', 62, rightPad: true));
              content.writeln(fixedCol('Address   : ${await GetAllPref.customerAddress()}', 62, rightPad: true));
              content.writeln(fixedCol('Pan No      : ${await GetAllPref.customerpanno()}', 62, rightPad: true));
              content.writeln(fixedCol('Payment Mode: $salesPaymentModeCode', 62, rightPad: true));
              content.writeln(fixedCol('ReferenceId : $referenceId', 62, rightPad: true));
              content.writeln();

              //  ===== HEADER INFO =====
              content.writeln('Sn.'.padRight(5) +
                  'HSN Item'.padRight(10) +
                  'AltQty'.padRight(8) +
                  'Qty'.padRight(8) +
                  'Rate'.padRight(6) +
                  'Total'.padRight(10));
              content.writeln('-'*69);
              double grandTotal = 0.0;
              for (var item in allProductBillWiseOrderList) {
                i++;
                // ===== INVOICE INFO =====
                content.writeln(
                    '$i'.padRight(5).substring(0, 5)+
                      //  fixedCol('${item.pName} (${item.altUnit}-${item.altQty.split('.')[0]}) ',17,rightPad: true)+
                        fixedCol('${item.pName} ',10,rightPad: true)+
                        fixedCol('${item.altUnit}',3,rightPad: true)+
                        fixedCol('-',1,rightPad: true)+
                        fixedCol('${item.altQty.split('.')[0]} ',3,rightPad: true)+
                        fixedCol('${item.qty.split('.')[0]}',6,rightPad: true)+
                        fixedCol('${item.rate.length >=5 ? item.rate.substring(0,5) : item.rate.length <=3 ?  item.rate.substring(0,3) : item.rate.substring(0,4)} ',item.rate.length >=5 ? 5 :item.rate.length <=3 ?3: 4,rightPad: false)+
                        fixedCol('${item.totalAmt}',9,rightPad: true)

                );
                // content.writeln(
                //     fixedCol('$i',5,rightPad: true)+
                //         fixedCol('1234567891123',14,rightPad: true)+
                //         fixedCol('12345',6,rightPad: true)+
                //         fixedCol('1234',5,rightPad: true)+
                //         fixedCol('12345678',9,rightPad: true)
                //
                // );
                // content.writeln('$i'.padRight(5).substring(0, 5) +
                //     '${item.pName} ${item.altUnit}1234567891234567'.padRight(18).substring(0, 18) + // Truncate if too long
                //     '${item.qty}----------'.padRight(10).substring(0, 10) +
                //     '${item.rate}'.padRight(6).substring(0, 6) +
                //     '${item.totalAmt}'.padRight(12).substring(0, 12));

                // content.writeln(
                //     fixedWidth(i.toString(), 5) +
                //         fixedWidth('${item.pName} ${item.altUnit}', 16) +
                //         fixedWidth('${item.qty}', 7) +
                //         fixedWidth(item.rate.toString(), 7) +
                //         fixedWidth(item.totalAmt.toString(), 12)
                // );

                grandTotal += double.parse(item.totalAmt);
                if (i == allProductBillWiseOrderList.length) {
                  await printNative(content,grandTotal);
                }
              }

              printReceipt(value: allProductBillWiseOrderList);

              _isImageAdd = false;
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
      }
      else {
        try {
          await onFinalOrderSaveToDB();
          getLoading = true;
          getCompanyDetail = await GetAllPref.companyDetail();
          BasicModel modelData = await OrderProductAPI.postOrder(
            bodyData: await getFormatPOSTDATA(),
          );
          int i = 0;
          if (modelData.status == true) {
            await SetAllPref.setVoucherNo(value: modelData.message);
            await ProductOrderDatabase.instance.deleteData();
            await TempProductOrderDatabase.instance.deleteData();
            await productOrderComplete(ctx, true, "Sales successfully !!!");
            setDataInserted = false;
            ///

            String fixedWidth(String s, int width) => s.padRight(width).substring(0, width);

            StringBuffer content = StringBuffer();
          //  ===== HEADER SECTION =====
            content.writeln(fixedCol('${fixedCol('', 10)}${_companyDetail.aliasName}',62, rightPad: true));
            content.writeln(fixedCol('${fixedCol('', 10)} ${_companyDetail.companyAddress}', 62, rightPad: true));
            if (_companyDetail.vatNo.isNotEmpty) {
              content.writeln(fixedCol('${fixedCol('', 23)}PAN No : ${_companyDetail.vatNo}', 62, rightPad: true));
            }
            content.writeln(fixedCol('${fixedCol('', 32)} INVOICE', 62, rightPad: true));
            content.writeln();
            content.writeln(fixedCol('Branch      :${await GetAllPref.unitCode()}', 62, rightPad: true));
            content.writeln(fixedCol('Bill No     : ${await GetAllPref.getVoucher()}', 62, rightPad: true));
            content.writeln(fixedCol('Date        : ${await MyDate.showDateTime2()}(${await MyDate.showDateTimeNepali2()})', 62, rightPad: true));
            content.writeln(fixedCol('Name      : ${await GetAllPref.customerName()}', 62, rightPad: true));
            content.writeln(fixedCol('Address   : ${await GetAllPref.customerAddress()}', 62, rightPad: true));
            content.writeln(fixedCol('Pan No    : ${await GetAllPref.customerpanno()}', 62, rightPad: true));
            content.writeln(fixedCol('Payment Mode: ${paymentType}', 62, rightPad: true));
            content.writeln();
          //
          // //  ===== HEADER INFO =====
            content.writeln('Sn.'.padRight(5) +
                'HSN Item'.padRight(10) +
                'AltQty'.padRight(8) +
                'Qty'.padRight(8) +
                'Rate'.padRight(6) +
                'Total'.padRight(10));
            content.writeln('-'*69);
            double grandTotal = 0.0;
            for (var item in allProductBillWiseOrderList) {
              i++;
              // ===== INVOICE INFO =====
              content.writeln(
                  '$i'.padRight(5).substring(0, 5)+
                     // fixedCol('${item.pName} (${item.altUnit}-${item.altQty.split('.')[0]}) ',17,rightPad: true)+
                      fixedCol('${item.pName} ',10,rightPad: true)+
                      fixedCol('${item.altUnit}',3,rightPad: true)+
                      fixedCol('-',1,rightPad: true)+
                      fixedCol('${item.altQty.split('.')[0]} ',3,rightPad: true)+
                      fixedCol('${item.qty.split('.')[0]}',6,rightPad: true)+
                      fixedCol('${item.rate.length >=5 ? item.rate.substring(0,5) : item.rate.length <=3 ?  item.rate.substring(0,3) : item.rate.substring(0,4)} ',item.rate.length >=5 ? 5 :item.rate.length <=3 ?3: 4,rightPad: false)+
                      fixedCol('${item.totalAmt}',9,rightPad: true)

              );
              // content.writeln(
              //     fixedCol('$i',5,rightPad: true)+
              //         fixedCol('1234567891123',14,rightPad: true)+
              //         fixedCol('12345',6,rightPad: true)+
              //         fixedCol('1234',5,rightPad: true)+
              //         fixedCol('12345678',9,rightPad: true)
              //
              // );
              // content.writeln('$i'.padRight(5).substring(0, 5) +
              //     '${item.pName} ${item.altUnit}1234567891234567'.padRight(18).substring(0, 18) + // Truncate if too long
              //     '${item.qty}----------'.padRight(10).substring(0, 10) +
              //     '${item.rate}'.padRight(6).substring(0, 6) +
              //     '${item.totalAmt}'.padRight(12).substring(0, 12));

              // content.writeln(
              //     fixedWidth(i.toString(), 5) +
              //         fixedWidth('${item.pName} ${item.altUnit}', 16) +
              //         fixedWidth('${item.qty}', 7) +
              //         fixedWidth(item.rate.toString(), 7) +
              //         fixedWidth(item.totalAmt.toString(), 12)
              // );

              grandTotal += double.parse(item.totalAmt);
              if (i == allProductBillWiseOrderList.length) {
                await printNative(content,grandTotal);
              }
            }
            Navigator.pushNamedAndRemoveUntil(
                context, indexPath, (route) => false);
            printReceipt(value: allProductBillWiseOrderList);

            _isImageAdd = false;
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
    }

  }

  Future productOrderAPICall2(BuildContext ctx) async {
    // getBillImage = Provider.of<ImagePickerState>(context, listen: false).myPickedImage;
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
        await TempProductOrderDatabase.instance.deleteData();
        await productOrderComplete(ctx, true, "Sales successfully !!!");
        setDataInserted = false;
        //   Navigator.pushNamedAndRemoveUntil(context, indexPath, (route) => false);
        _isImageAdd = false;
        if (PrintOrNot == "pdf") {
          if (paymentType == "Card" || paymentType == "Fonepay") {
            if (paymentType == "Card") {
              paymentType = "Sale";
            }
            callPaymentNativeCode(paymentType);
          }
          onPrint(name: "name", paymentMode: paymentMode);
        } else if (PrintOrNot == "print") {
          if (paymentType == "Card" || paymentType == "Fonepay") {
            if (paymentType == "Card") {
              paymentType = "Sale";
            }
          //  String referenceId = await callPaymentNativeCode(paymentType);
          //  Fluttertoast.showToast(msg: 'ReferenceId : ${referenceId}');
          }

          printReceipt(value: allProductBillWiseOrderList);
        } else {
          await TempProductOrderDatabase.instance.deleteData();
        }
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
    Navigator.pushNamedAndRemoveUntil(
        context, indexPath, (route) => false);
    notifyListeners();
  }

  getIndexTotalAmount({required String rate}) {
    double vatAmount = (double.parse(rate) * 0.13);
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
    showVatDiscAmountBill();
    return _totalBalance.toStringAsFixed(2);
  }

  late double _balanceAmount = 0.00;
  double get balanceAmount => _balanceAmount;

  set getBalanceAmount(double value) {
    _balanceAmount = value;
    notifyListeners();
  }

  calculateCash(double totalAmount, double enterAmount) {
    getBalanceAmount = totalAmount - enterAmount;
    if (enterAmount == 0.0) {
      getBalanceAmount = 0.0;
    }
    if (enterAmount > totalAmount) {
      tenderAmount.text = "";
      getBalanceAmount = 0.0;
    }
    notifyListeners();
  }

  calculateBillTerm() {
    double net = 0.00;
    getTotalBillWise = 0.00;

    if (bSign1 == "-") {
      getDiscBill = bTerm1Amount;
    } else if (bSign1 == "+") {
      getVatBill = bTerm1Amount;
    }
    if (bSign2 == "-") {
      getDiscBill = bTerm2Amount;
    } else if (bSign2 == "+") {
      getVatBill = bTerm2Amount;
    }
    if (bSign3 == "-") {
      getDiscBill = bTerm3Amount;
    } else if (bSign3 == "+") {
      getVatBill = bTerm3Amount;
    }

    double netAmount = double.parse(calculateTotalAmount());
    net += netAmount - discBill + vatBill;
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

  List<OutletDataModel> get listCustomer => _listCustomer;

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
   // Fluttertoast.showToast(msg: salesPaymentModeCode);
    CustomLog.actionLog(
        value: "TEMP ORDER COUNT  => ${_allTempOrderList.length}");
    for (var element in _allTempOrderList) {
      ProductOrderModel finalOrder = ProductOrderModel(
          itemCode: element.pCode,
          pName: element.pName,
          qty: element.quantity,
          rate: element.rate,
          totalAmt: element.totalAmount,
         // totalAmt: tenderAmount.text == "" ? element.totalAmount :,
          netTotalAmt:
              (double.parse(element.quantity) * double.parse(element.rate))
                  .toString(),
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
          godownCode: godownCode,
          dbName: _companyDetail.dbName,
          salesImage: '',
          imagePath: '',
          outletCode: await GetAllPref.outLetCode() ?? '',
          unit: await GetAllPref.unitCode(),
          sign1: element.sign1,
          sign2: element.sign2,
          sign3: element.sign3,
          altUnit: element.altUnit,
          altQty: element.altQty,
          hsCode: element.hsCode,
          factor: element.factor,
        //  payAmount: tenderAmount.text.isNotEmpty ? tenderAmount.text : "0.0",
          payAmount: subTotal.toString(),
          billNetAmt: element.totalAmount,
          userCode: await GetAllPref.userName(),
          cashGlCode: salesPaymentModeCode != "" ? salesPaymentModeCode :  paymentType,
          remarks: comment.text == "" ? "N/A" : comment.text);
      // "BillNetAmt": "5250.00",
      // "UserCode": "ABCD",
      await ProductOrderDatabase.instance.insertData(finalOrder);
      await getProductBillWiseOrderList();
    }
  }

  Future<List<OutletDataModel>> getDataList() async {
    // getCompanyDetail = await GetAllPref.companyDetail();
    OutletModel outletData = await OutletList.partyList(
      dbName: _companyDetail.dbName,
      unitCode: await GetAllPref.unitCode(),
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

  late String? _customer;

  String? get customer => _customer;

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

  late String _myContainImage = "";

  String get myContainImage => _myContainImage;

  set getBillImage(String value) {
    _myContainImage = "";
    _myContainImage = value;
    notifyListeners();
  }

  getFormatPOSTDATA() async {
    // getBillImage = Provider.of<ImagePickerState>(context, listen: false).myPickedImage;
    return await ProductOrderDatabase.instance.getPostDataASFormatNeeded(
      dbName: _companyDetail.dbName,
      unitCode: await GetAllPref.unitCode(),
      salesImage: "",
      imagePath: await GetAllPref.baseImageURL(),
      companyInitial: await GetAllPref.companyInitial(),
    );
  }

  late List<ProductOrderModel> _qrProductList = [];

  List<ProductOrderModel> get qrProductList => _qrProductList;

  set getQrProductList(List<ProductOrderModel> value) {
    _qrProductList = value;
    notifyListeners();
  }

  getQRProductListFromDB({code}) async {
    String qrCode = await GetAllPref.getQRData();
    await ProductOrderDatabase.instance
        .getQRProduct(qrCode: code)
        .then((value) {
      getQrProductList = value;
    });

    notifyListeners();
  }

  onPrint({required String name, paymentMode}) async {
    double quantity = 0;
    double rate = 0.00;
    double totalAMT = 0.00;
    double termDisc = 0.00;
    double termVatAmt = 0.00;
    double termAdditionalAmt = 0.00;
    double bterm1Disc = 0.00;
    double bterm2VatAmt = 0.00;
    int i = 1;
    String sign1 = "";
    String sign2 = "";
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
          pTermDic: termDisc,
          pTermVat: termVatAmt,
          pTermAdditional: termAdditionalAmt,
          bTermDisc1: bterm1Disc,
          bTermVat2: bterm2VatAmt,
          customerName: await GetAllPref.customerName(),
          productList: allProductBillWiseOrderList,
          totalAmount: totalAMT,
          sign1: sign1,
          sign2: sign2,
          sign3: sign3,
          voucherNo: await GetAllPref.getVoucher(),
          paymentMode: paymentMode);

      ////  opening the pdf file

      FileHandleApiSalesProduct.openFile(pdfFile);
    }

    await TempProductOrderDatabase.instance.deleteData();
    // await ProductOrderDatabase.instance.deleteData();
    notifyListeners();
  }

  Future<void> printReceipt({required List<ProductOrderModel> value}) async {
    //
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
    await SunmiPrinter.printText('SALES INVOICE');
    await SunmiPrinter.setCustomFontSize(20);
    await SunmiPrinter.printText('${await GetAllPref.unitCode()}');
    await SunmiPrinter.setCustomFontSize(19);
    await SunmiPrinter.printText('Bill No : ${await GetAllPref.getVoucher()}');
    await SunmiPrinter.setCustomFontSize(19);
    await SunmiPrinter.printText(
        'Date    : ${await MyDate.showDateTime2()}(${await MyDate.showDateTimeNepali2()})');
    // await SunmiPrinter.setCustomFontSize(19);
    // await SunmiPrinter.printText('Miti : ${await MyDate.showDateTimeNepali()}');
    await SunmiPrinter.setCustomFontSize(19);
    await SunmiPrinter.printText(
        'Name    : ${await GetAllPref.customerName()}');
    await SunmiPrinter.setCustomFontSize(19);
    await SunmiPrinter.printText(
        'Address : ${await GetAllPref.customerAddress()}');
    await SunmiPrinter.setCustomFontSize(19);
    await SunmiPrinter.printText(
        'Pan No  : ${await GetAllPref.customerpanno()}');

    await SunmiPrinter.line();
    await SunmiPrinter.setCustomFontSize(19);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Sn.",
        width: 4,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "HSN Item",
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
    double grandTotal = 0.00;
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
        if (item.altUnit.isNotEmpty) ...[
          ColumnMaker(
            text:
                '${adjustStringLength(item.pName)}${item.hsCode} ${item.altUnit == "" ? "" : " ${item.altUnit}"}',
            //  text: '                HSN${item.hsCode} ${item.altUnit == "" ? "" : " ${item.altUnit}"}',
            // text: '${item.pName}    HSN ${item.altUnit} ${item.factor}',
            width: 15,
            align: SunmiPrintAlign.LEFT,
          ),
        ] else ...[
          ColumnMaker(
            text: '${adjustStringLength(item.pName)}',
            //  text: '                HSN${item.hsCode} ${item.altUnit == "" ? "" : " ${item.altUnit}"}',
            // text: '${item.pName}    HSN ${item.altUnit} ${item.factor}',
            width: 15,
            align: SunmiPrintAlign.LEFT,
          ),
        ],
        ColumnMaker(
          text: item.factor != "0.00"
              ? '${item.qty.replaceAll('.0', '')}  ${item.factor}'
              : item.qty.replaceAll('.0', ''),
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
    await SunmiPrinter.setAlignment(SunmiPrintAlign.RIGHT);
    await SunmiPrinter.printText(
        "Grand Total: ${grandTotal.toStringAsFixed(2)}");
    // await SunmiPrinter.setAlignment(SunmiPrintAlign.RIGHT);
    // await SunmiPrinter.printText(grandTotal.toStringAsFixed(2));
    //    await SunmiPrinter.printRow(cols: [
    //   ColumnMaker(
    //     text: "Grand Total:",
    //     width: 20,
    //     align: SunmiPrintAlign.LEFT,
    //   ),
    //      ColumnMaker(
    //        text: "",
    //        width: 10,
    //        align: SunmiPrintAlign.LEFT,
    //      ),
    //   ColumnMaker(
    //     text: grandTotal.toStringAsFixed(2),
    //     width: 10,
    //     align: SunmiPrintAlign.RIGHT,
    //   ),
    // ]);
    await SunmiPrinter.line();
    await SunmiPrinter.setCustomFontSize(18);
    await SunmiPrinter.printText(
        'Print Date & Time : ${await MyDate.showDateTime()}');
    await SunmiPrinter.printText(
        'Prepared by : ${await GetAllPref.userName()}');
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText("Thank you");

    await SunmiPrinter.submitTransactionPrint();
    await SunmiPrinter.lineWrap(3);
    await SunmiPrinter.exitTransactionPrint(true);
  }

  String adjustStringLength(String input) {
    if (input.length < 15) {
      return input.padRight(15, ' '); // Pad with spaces if it's shorter than 15
    } else {
      return input.substring(0, 15); // Truncate if it's longer than 15
    }
  }
}
