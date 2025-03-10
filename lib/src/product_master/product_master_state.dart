import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/product_master/api/product_master_api.dart';
import 'package:retail_app/src/product_master/model/product_master_model.dart';
import 'package:retail_app/src/products/api/product_api.dart';
import 'package:retail_app/src/products/model/product_model.dart';
import '../../model/basic_model.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';

class ProductMaterState extends ChangeNotifier {
  ProductMaterState();

  late BuildContext _context;

  BuildContext get context => _context;
  late NavigatorState navigator;

  set getContext(BuildContext value) {
    _context = value;
    navigator = Navigator.of(_context);

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
    await checkConnection();
    selectedGrpCode = null;
    selectedUnit = null;
  }

  checkConnection() async {
    CheckNetwork.check().then((network) async {
      getCompanyDetail = await GetAllPref.companyDetail();

      await  getDataList();
      if (network) {
        //  await networkSuccess();
      } else {
        // await getGroupProductListFromDB();
      }
    });
  }

  late CompanyDetailsModel _companyDetail = CompanyDetailsModel.fromJson({});

  CompanyDetailsModel get companyDetail => _companyDetail;

  set getCompanyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  clear() async {
    _isLoading = false;
    _companyDetail = await GetAllPref.companyDetail();
    _productUnit.clear();
    _productAltUnit.clear();
    _salesRate.clear();
    _purchaseRate.clear();
    _productName.clear();
  }

  clean() async {
    _isLoading = false;
    _companyDetail = await GetAllPref.companyDetail();
  }

  set companyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  late final TextEditingController _productUnit =
  TextEditingController(text: "");

  TextEditingController get productUnit => _productUnit;
  late double _productAmount = 0.0;

  double get productAmount => _productAmount;

  set getproductAmountAmount(double value) {
    _productAmount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_productAmount");
    notifyListeners();
  }

  late final TextEditingController _productAltUnit =
  TextEditingController(text: "");

  TextEditingController get productAltUnit => _productAltUnit;
  late double _productAltAmount = 0.0;

  double get productAltAmount => _productAltAmount;

  set getproductAltAmount(double value) {
    _productAltAmount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_productAltAmount");
    notifyListeners();
  }

  late final TextEditingController _salesRate = TextEditingController(text: "");

  TextEditingController get salesRate => _salesRate;
  late double _salesAmount = 0.0;

  double get salesAmount => _salesAmount;

  set getsalesAmount(double value) {
    _salesAmount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_salesAmount");
    notifyListeners();
  }

  late final TextEditingController _purchaseRate =
  TextEditingController(text: "");

  TextEditingController get purchaseRate => _purchaseRate;
  late double _purchaseAmount = 0.0;

  double get purchaseAmount => _purchaseAmount;

  set getpurchaseAmount(double value) {
    _purchaseAmount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_purchaseAmount");
    notifyListeners();
  }

  // late final TextEditingController _productCode =
  //     TextEditingController(text: "");
  //
  // TextEditingController get productCode => _productCode;
  // late double _productCodeAmount = 0.0;
  //
  // double get productCodeAmount => _productCodeAmount;
  //
  // set getproductCodeAmount(double value) {
  //   _productCodeAmount = value;
  //   CustomLog.actionLog(value: "CUSTOM LOG => $_productCodeAmount");
  //   notifyListeners();
  // }

  late final TextEditingController _productName =
  TextEditingController(text: "");

  TextEditingController get productName => _productName;
  late double _productNameAmount = 0.0;

  double get productNameAmount => _productNameAmount;

  set getproductNameAmount(double value) {
    _productNameAmount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_productNameAmount");
    notifyListeners();
  }

  late final TextEditingController _productGroup =
  TextEditingController(text: "");

  TextEditingController get productGroup => _productGroup;
  late double _productGroupAmount = 0.0;

  double get productGroupAmount => _productGroupAmount;

  set getproductGroupAmount(double value) {
    _productGroupAmount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_productGroupAmount");
    notifyListeners();
  }

  late final TextEditingController _productSubGroup =
  TextEditingController(text: "");

  TextEditingController get productSubGroup => _productSubGroup;
  late double _productSubGroupAmount = 0.0;

  double get productSubGroupAmount => _productSubGroupAmount;

  set getproductSubGroupAmount(double value) {
    _productSubGroupAmount = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_productSubGroupAmount");
    notifyListeners();
  }

  late List<ProductMasterModel> _productList = [];

  List<ProductMasterModel> get productList => _productList;

  set postDataList(List<ProductMasterModel> value) {
    _productList = value;
    notifyListeners();
  }

  String? selectedGrpCode;
  String? selectedSubGrpCode;
  String? selectedUnit;

  Future<void> networkSuccess() async {
    _isLoading = true;
    await getDataList();
    await sendPostRequest();
    _isLoading = false;
  }


  Future<List<ProductDataModel>> getDataList() async {
    ProductModel groupData = await ProductAPI.getProduct(
      dbName: _companyDetail.dbName, unitCode: await GetAllPref.unitCode(),
    );
    if (groupData.statusCode == 200) {
      return groupData.data;
    } else {
      return [];
    }
  }


  List<ProductDataModel> _productGroupDropDown = [];
  List<ProductDataModel> get productGroupDropDown => _productGroupDropDown;

  set setProductGroup(List<ProductDataModel> value){
    _productGroupDropDown = value;
  }



  Future<List<ProductDataModel>> getDataUnitList() async {
    ProductModel unitData = await UnitList.unitList(
      dbName: _companyDetail.dbName,
    );
    if (unitData.statusCode == 200) {
      return unitData.data;
    } else {
      // ShowToast.errorToast(msg: "ads  "+_companyDetail.dbName +" Failed to get data" );
      return [];
    }
  }

  Future<void> sendPostRequest() async {
    String purchase = "";
    String sales = "";
    try {
      if(purchaseRate.text.isEmpty){
        purchase = "0";
      }else {
        purchase = purchaseRate.text;
      }
      if(salesRate.text.isEmpty){
        sales = "0";
      }else {
        sales = salesRate.text;
      }
      var productDetails = ProductMasterModel(
        groupName: selectedGrpCode ?? '',
        dbName: _companyDetail.dbName,
        subGroupName: selectedSubGrpCode ?? '',
        productUnit: selectedUnit ?? '',
        productAltUnit: '',
        salesRate: sales,
        purchaseRate: purchase,
        productCode: '',
        productName: productName.text,
      );
      BasicModel modelData =await ProductCreate.createProduct(productDetails: productDetails);
      if(modelData.status == true){
        ShowToast.successToast(msg: modelData.message);
        navigator.pop();
      }else{
        ShowToast.successToast(msg: "Product already exit!");
      }
    } catch (e) {
      debugPrint('An error occurred while creating ledger: $e');
      ShowToast.successToast(msg: "An error occurred while creating ledger");
    }
  }
}