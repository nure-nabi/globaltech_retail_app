import 'package:flutter/material.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/master/api/master_api.dart';
import 'package:retail_app/src/master/model/group_model.dart';
import 'package:retail_app/src/master/model/mastermodel.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';

class MaterState extends ChangeNotifier {
  MaterState();

  late BuildContext _context;

  BuildContext get context => _context;
  late NavigatorState navigator;

  set getContext(BuildContext value) {
    _context = value;
    navigator = Navigator.of(_context);
    init();
  }

  late bool _isLoading = false;

  bool get isLoading => _isLoading;

  late bool _mappingInsert = false;

  bool get mappingInsert => _mappingInsert;

  set setMappingInsert(bool value) {
    _mappingInsert = value;
    notifyListeners();
  }

  set getLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  init() async {
    await checkConnection();
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

  late CompanyDetailsModel _companyDetail = CompanyDetailsModel.fromJson({});

  CompanyDetailsModel get companyDetail => _companyDetail;

  set getCompanyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  clear() async {
    _isLoading = false;
    _companyDetail = await GetAllPref.companyDetail();
    _category.clear();
    _customerName.clear();
    _panNo.clear();
    _contactPerson.clear();
    _customerCode.clear();
    _mobileNo.clear();
    _email.clear();
  }

  clean() async {
    _isLoading = false;
    _companyDetail = await GetAllPref.companyDetail();
  }



  set companyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  late final TextEditingController _category = TextEditingController(text: "");

  TextEditingController get category => _category;
  late double _categoryData = 0.0;

  double get categoryData => _categoryData;

  set getcategoryDataField(double value) {
    _categoryData = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_categoryData");
    notifyListeners();
  }

  late final TextEditingController _customerName =
  TextEditingController(text: "");

  TextEditingController get customerName => _customerName;

  late double _customerNameData = 0.0;

  double get customerNameData => _customerNameData;

  set getCustomerNameDataField(double value) {
    _customerNameData = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_customerNameData");
    notifyListeners();
  }

  late final TextEditingController _panNo = TextEditingController(text: "");

  TextEditingController get panNo => _panNo;

  late double _panNoNameData = 0.0;

  double get panNoNameData => _panNoNameData;

  set getpanNoNameDataField(double value) {
    _panNoNameData = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_panNoNameData");
    notifyListeners();
  }

  late final TextEditingController _contactPerson =
  TextEditingController(text: "");

  TextEditingController get contactPerson => _contactPerson;

  late double _contactPersonData = 0.0;

  double get contactPersonData => _contactPersonData;

  set getcontactPersonDataField(double value) {
    _contactPersonData = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_contactPersonData");
    notifyListeners();
  }

  late final TextEditingController _customerCode =
  TextEditingController(text: "");

  TextEditingController get customerCode => _customerCode;

  late double _customerCodeData = 0.0;

  double get customerCodeData => _customerCodeData;

  set getcustomerCodeDataField(double value) {
    _customerCodeData = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_customerCodeData");
    notifyListeners();
  }

  late final TextEditingController _mobileNo = TextEditingController(text: "");

  TextEditingController get mobileNo => _mobileNo;

  late double _mobileNoData = 0.0;

  double get mobileNoData => _mobileNoData;

  set getmobileNoDataField(double value) {
    _mobileNoData = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_mobileNoData");
    notifyListeners();
  }

  late final TextEditingController _email = TextEditingController(text: "");

  TextEditingController get email => _email;

  late double _emailData = 0.0;

  double get emailData => _emailData;

  set getemailDataField(double value) {
    _emailData = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_emailData");
    notifyListeners();
  }

  late List<LedgerDetails> _ledgerList = [];

  List<LedgerDetails> get ledgerList => _ledgerList;

  set postDataList(List<LedgerDetails> value) {
    _ledgerList = value;
    notifyListeners();
  }



  String? selectedGrpCode;

  Future<void> networkSuccess() async {
    _isLoading = true;
    await getDataList();
    await sendPostRequest();
    _isLoading = false;
    notifyListeners();
  }

  String categorydropdownvalue = 'Customer';
  var categoryitems = [
    'Customer',
    'Vendor',
    'Customer/Vendor',
    'Other',
    'Cash Book',
    'Bank Book',
  ];

  Future<List<GroupDataModel>> getDataList() async {
    GroupModel groupData = await LedgerList.getLedgerList(
      dbName: _companyDetail.dbName,
      unitCode: await GetAllPref.unitCode()
    );
    if (groupData.statusCode == 200) {
      return groupData.data;
    } else {
      return [];
    }
  }

  Future<void> sendPostRequest() async {
    try {
      var ledgerDetails = LedgerDetails(
        groupName: selectedGrpCode ?? '',
        dbName: _companyDetail.dbName,
        category: categorydropdownvalue,
        panNo: panNo.text,
        contactPerson: contactPerson.text,
        salesRate: '0',
        customerCode: customerCode.text,
        mobileNo: mobileNo.text,
        email: email.text,
        customerName: customerName.text,
      );

      await LedgerAPI.saveLedger(ledgerDetails: ledgerDetails);
      ShowToast.successToast(msg: "Ledger has been created");
      debugPrint('Ledger created successfully!');
      navigator.pop();
    } catch (e) {
      ShowToast.successToast(msg: "An error occurred!");
      debugPrint('An error occurred while creating ledger: $e');
    }
  }
}