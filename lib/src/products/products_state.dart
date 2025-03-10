import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retail_app/services/router/router_name.dart';
import 'package:retail_app/services/sharepref/get_all_pref.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/products/db/prduct_db.dart';
import 'package:retail_app/utils/connection_status.dart';
import 'package:retail_app/utils/show_toast.dart';
import 'api/product_api.dart';
import 'model/product_model.dart';

class ProductState extends ChangeNotifier {
  ProductState();

  late BuildContext _context;

  BuildContext get context => _context;
  late final NavigatorState navigator = Navigator.of(_context);

  set getContext(BuildContext value) {
    _context = value;


    init();
  }

  init() async {
    await clear();
    await getGroupProductListFromDB();
    await checkConnection();
  }

  late CompanyDetailsModel _companyDetail = CompanyDetailsModel.fromJson({});
  CompanyDetailsModel get companyDetail => _companyDetail;
  set getCompanyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  clear() async {
    _isLoading = false;
  //  _filterGroupList = [];
   // _groupList = [];
  }

  late bool _isLoading = false;
  bool get isLoading => _isLoading;
  set getLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  checkConnection() async {
    CheckNetwork.check().then((network) async {

      getCompanyDetail = await GetAllPref.companyDetail();
      if(_filterGroupList.isEmpty){
        if (network) {
          await networkSuccess();
        } else {
          await getGroupProductListFromDB();
        }
      }else{
        await getGroupProductListFromDB();
      }


    });
  }

  networkSuccess() async {
    ///
    getLoading = true;
    await getDataFromAPI();
    getLoading = false;
  }

  late List<ProductDataModel> _groupList = [], _filterGroupList = [],_unitList = [];
  List<ProductDataModel> get groupList => _groupList;
  List<ProductDataModel> get unitList => _unitList;
  List<ProductDataModel> get filterGroupList => _filterGroupList;


  late List<ProductDataModel> _productList = [], _filterProductList = [];
  List<ProductDataModel> get productList => _productList;
  List<ProductDataModel> get filterProductList => _filterProductList;

  set getProductGroupList(List<ProductDataModel> value) {
    _groupList = value;
    _filterGroupList = _groupList;
    notifyListeners();
  }

  set getProductUnit(List<ProductDataModel> value) {
    _unitList = value;
    notifyListeners();
  }

  set filterGroupProductList(value) {
    _filterGroupList = _groupList
        .where((u) => (u.pDesc.toLowerCase().contains(value.toLowerCase())))
        .toList();
    notifyListeners();
  }

  set getProductList(List<ProductDataModel> value) {
    _productList = value;
    _filterProductList = _productList;
    notifyListeners();
  }

  set filterProduct(value) {
    _filterProductList = _productList
        .where((u) => (u.pDesc.toLowerCase().contains(value.toLowerCase())))
        .toList();
    notifyListeners();
  }

  getDataFromAPI() async {
    getLoading = true;
    ProductModel productData = await ProductAPI.getProduct(
      dbName: _companyDetail.dbName, unitCode: await GetAllPref.unitCode(),
    );
    if (productData.statusCode == 200) {
      await onSuccess(dataModel: productData.data);
      getLoading = false;
    } else {
      ShowToast.errorToast(msg: "Faild to get data");
      getLoading = false;
    }

    notifyListeners();
  }

  onSuccess({required List<ProductDataModel> dataModel}) async {
    await ProductDatabase.instance.deleteData();

    for (var element in dataModel) {
      await ProductDatabase.instance.insertData(element);
    }

    await getGroupProductListFromDB();

    notifyListeners();
  }

  getGroupProductListFromDB() async {
    await ProductDatabase.instance.getProductGroupData().then((value) {
      getProductGroupList = value;
    });
    getProductUnitListFromDB();
    notifyListeners();
  }

  getProductUnitListFromDB() async {
    await ProductDatabase.instance.getProductUnit().then((value) {
      getProductUnit = value;
    });
    notifyListeners();
  }

  set filterProductGroup(value) {
    _filterGroupList = _groupList
        .where((u) => (u.groupName.toLowerCase().contains(value.toLowerCase())))
        .toList();
    notifyListeners();
  }

  set filterProductList(value) {
    _filterGroupList = _groupList
        .where((u) => (u.pDesc.toLowerCase().contains(value.toLowerCase())))
        .toList();
    notifyListeners();
  }

  getProductListFromDB({required String groupName}) async {
    await ProductDatabase.instance
        .getProductList(groupName: groupName)
        .then((value) {
      getProductList = value;
    });
    notifyListeners();
  }

  late ProductDataModel _selectedGroup = ProductDataModel.fromJson({});

  ProductDataModel get selectedGroup => _selectedGroup;

  set getSelectedGroup(ProductDataModel value) {
    _selectedGroup = value;
    notifyListeners();
  }

  groupSelected() async {
    await getProductListFromDB(groupName: _selectedGroup.groupName);

    navigator.pushNamed(productListPath);
    notifyListeners();
  }
  late List<ProductDataModel> _qrProductList = [];

  List<ProductDataModel> get qrProductList => _qrProductList;

  set getQrProductList(List<ProductDataModel> value) {
    _qrProductList = value;
    notifyListeners();
  }
  getQRProductListFromDB({code}) async {
    await ProductDatabase.instance.getQRProduct(qrCode:code).then((value) {
      getQrProductList = value;
    });
    notifyListeners();
  }

  getQRTempProductListFromDB({code}) async {
    String qrCode = await GetAllPref.getQRData();

    await ProductDatabase.instance.getQRProduct(qrCode:code).then((value) {
      getQrProductList = value;
    });

    notifyListeners();
  }
}
