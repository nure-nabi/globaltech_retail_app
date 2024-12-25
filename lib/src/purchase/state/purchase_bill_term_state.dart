import 'package:flutter/material.dart';
import 'package:retail_app/services/router/router_name.dart';
import 'package:retail_app/services/sharepref/get_all_pref.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/products/db/prduct_db.dart';
import 'package:retail_app/utils/connection_status.dart';
import 'package:retail_app/utils/show_toast.dart';

import '../../sales_bill_term/api/sales_bill_term_api.dart';
import '../../sales_bill_term/db/sales_bill_term_db.dart';
import '../../sales_bill_term/model/sales_bill_term_model.dart';
import '../db/purchase_term_db.dart';



class PurchaseTermState extends ChangeNotifier {
  PurchaseTermState();

  late BuildContext _context;

  BuildContext get context => _context;
  late final NavigatorState navigator = Navigator.of(_context);

  set getContext(BuildContext value) {
    _context = value;
    init();
  }

  init() async {
    await clear();
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
    _termList = [];
  }

  late bool _isLoading = false;
  bool get isLoading => _isLoading;
  set getLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  late   TextEditingController _discountRate = TextEditingController(text: "");
  TextEditingController get  discountRate => _discountRate;

  late  TextEditingController _discountAmt = TextEditingController(text: "");
  TextEditingController get  discountAmt => _discountAmt;

  set getDiscountAmt(String value) {
    _discountAmt.text = value;
    notifyListeners();
  }

  set getDiscountRate(String value) {
    _discountRate.text = value;
    notifyListeners();
  }

  checkConnection() async {
    CheckNetwork.check().then((network) async {
      getCompanyDetail = await GetAllPref.companyDetail();
      if (network) {
        await networkSuccess();
      } else {
        //  await getGroupProductListFromDB();
      }
    });
  }

  networkSuccess() async {
    ///
    getLoading = true;
    await getDataFromAPI();
    getLoading = false;
  }

  late List<SalesBillTermDataModel> _termList = [];
  List<SalesBillTermDataModel> get termList => _termList;

  set getTermList(List<SalesBillTermDataModel> value) {
    _termList = value;
    notifyListeners();
  }

  getDataFromAPI() async {
    SalesBillTermModel salesTermData = await SalesBillTermApi.getPurchaseTerm(
      dbName: _companyDetail.dbName,
    );
    if (salesTermData.statusCode == 200) {
      await onSuccess(dataModel: salesTermData.data);
    } else {
      ShowToast.errorToast(msg: "Faild to get data");
    }

    notifyListeners();
  }

  onSuccess({required List<SalesBillTermDataModel> dataModel}) async {
    await PurhaseTermDatabase.instance.deleteData();

    for (var element in dataModel) {
      await PurhaseTermDatabase.instance.insertData(element);
    }
    notifyListeners();
  }

  termSelected(String product) async {
    // await getTermListFromDB(salesTermType: product).th;

    await getTermListFromDB(salesTermType: product).then((value) {
      getTermList = value;
    });

    notifyListeners();
  }


  getTermListFromDB({required String salesTermType}) async {
    await PurhaseTermDatabase.instance.getTermList(termType: salesTermType).then((value) {
      getTermList = value;
    });
    notifyListeners();
  }

  late SalesBillTermDataModel _selectedGroup = SalesBillTermDataModel.fromJson({});

  //SalesBillTermDataModel get selectedGroup => _selectedGroup;

  calculateBillTerm() async {
    if (_discountRate.text.isEmpty) {
      getDiscountRate = "0.0";
      getDiscountAmt = "";
    }else{

      // double disc =  (double.parse(calculateTotalAmount()) * double.parse(discountRate.text) ) / 100;
      // double  value = double.parse(calculateTotalAmount());
      //  double tempValue = value - disc;
      getDiscountRate = "0.0";

    }
    notifyListeners();
  }


}
