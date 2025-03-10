import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retail_app/src/ledger_master/api/ledger_master_api.dart';
import 'package:retail_app/src/ledger_master/model/ledger_master_model.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/master/api/master_api.dart';
import 'package:retail_app/src/master/model/group_model.dart';
import '../../model/basic_model.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';
import '../purchase/api/purchase_api.dart';
import '../purchase/db/account_group_list_db.dart';
import '../purchase/model/account_group_model.dart';

class LedgerMasterState extends ChangeNotifier {
  LedgerMasterState();

  late BuildContext _context;

  BuildContext get context => _context;
  late NavigatorState navigator;

  set getContext(BuildContext value) {
    _context = value;
    navigator = Navigator.of(_context);
    init();
  }
  late bool _mappingInsert = false;

  bool get mappingInsert => _mappingInsert;

  set setMappingInsert(bool value) {
    _mappingInsert = value;
    notifyListeners();
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
    getAccountGroup = null;
  }

  checkConnection() async {
    CheckNetwork.check().then((network) async {
      getCompanyDetail = await GetAllPref.companyDetail();

      if (network) {
          await networkSuccess();
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
    _outletName.clear();
    _address.clear();
    _panNo.clear();
    _phone.clear();
    _email.clear();
    _contactPerson.clear();
  }

  clean() async {

    _isLoading = false;
    _companyDetail = await GetAllPref.companyDetail();

  }

  set companyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  late final TextEditingController _outletName =
  TextEditingController(text: "");

  TextEditingController get outletName => _outletName;
  late double _outletNameData = 0.0;

  double get outletNameData => _outletNameData;

  set getOutletNameDataField(double value) {
    _outletNameData = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_outletNameData");
    notifyListeners();
  }

  late final TextEditingController _panNo = TextEditingController(text: "");

  TextEditingController get panNo => _panNo;
  late double _panNoData = 0.0;

  double get panNoData => _panNoData;

  set getPanNoDataField(double value) {
    _panNoData = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_panNoData");
    notifyListeners();
  }

  late final TextEditingController _phone = TextEditingController(text: "");

  TextEditingController get phone => _phone;
  late double _phoneData = 0.0;

  double get phoneData => _phoneData;

  set getPhoneDataField(double value) {
    _phoneData = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_phoneData");
    notifyListeners();
  }

  late final TextEditingController _address = TextEditingController(text: "");

  TextEditingController get address => _address;
  late double _addressData = 0.0;

  double get addressData => _addressData;

  set getAddressDataField(double value) {
    _addressData = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_addressData");
    notifyListeners();
  }

  late final TextEditingController _email = TextEditingController(text: "");

  TextEditingController get email => _email;
  late double _emailData = 0.0;

  double get emailData => _emailData;

  set getEmailDataField(double value) {
    _emailData = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_emailData");
    notifyListeners();
  }

  late final TextEditingController _contactPerson =
  TextEditingController(text: "");

  TextEditingController get contactPerson => _contactPerson;
  late double _contactPersonData = 0.0;

  double get contactPersonData => _contactPersonData;

  set getContactPersonDataField(double value) {
    _contactPersonData = value;
    CustomLog.actionLog(value: "CUSTOM LOG => $_contactPersonData");
    notifyListeners();
  }

  late List<LedgerMasterModel> _ledgerMasterList = [];

  List<LedgerMasterModel> get ledgerMasterList => _ledgerMasterList;

  set postDataList(List<LedgerMasterModel> value) {
    _ledgerMasterList = value;
    notifyListeners();
  }


  Future<List<AccountGroupListDataModel>> getAccountGroupList() async {
    ResponseModel outletData = await ListAccountGroup.accountGroupList(
      dbName: _companyDetail.dbName,
    );
    if (outletData.statusCode == 200) {
      await onSuccessAccountGroupList(dataModel: outletData.data);
      return outletData.data;
    } else {
      // ShowToast.errorToast(msg: "ads  "+_companyDetail.dbName +" Failed to get data" );
      return [];
    }
  }

  onSuccessAccountGroupList({required List<AccountGroupListDataModel> dataModel}) async {
    await AccountGroupListDatabase.instance.deleteData();

    for (var element in dataModel) {
      await AccountGroupListDatabase.instance.insertData(element);
    }
    await getAccountGroupListFromDB();

    notifyListeners();
  }

  getAccountGroupListFromDB() async {
    await AccountGroupListDatabase.instance.getAccountGroupList().then((value) {
      getAccountList = value;
    });
    notifyListeners();
  }


  late List<AccountGroupListDataModel> _accountGroupList = [];
  List<AccountGroupListDataModel> get accountGroupList => _accountGroupList;

  set getAccountList(List<AccountGroupListDataModel> value) {
    _accountGroupList = value;
    notifyListeners();
  }

  late String? _accountGroup;
  String?  get accountGroup => _accountGroup;

  set getAccountGroup(String? accountGroup) {
    _accountGroup = accountGroup;
    notifyListeners();
  }

  String? selectedGrpCode;
  String?
  selectedAccountGrpCode;

  Future<void> networkSuccess() async {
    _isLoading = true;
    await getAccountGroupList();
   // await sendPostRequest();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendPostRequest() async {
    try {

     // Fluttertoast.showToast(msg: selectedAccountGrpCode.toString());
      var ledgerMasterDetails = LedgerMasterModel(
        longitude: '',
        outletName: outletName.text,
        panNo: panNo.text,
        tag: '',
        phoneNo: phone.text,
        route: '',
        agentCode: '',
        address: address.text,
        mobileNo: '',
        email: email.text,
        latitude: '',
        outletCode: '',
        contactPerson: contactPerson.text,
        priceTag: '',
        dbName: _companyDetail.dbName,
        catagory: selectedGrpCode.toString(),
        grpCode: selectedAccountGrpCode.toString(),
      );
      try {
        BasicModel modelData = await LedgerMasterAPI.saveMasterLedger(
            ledgerMasterModel: ledgerMasterDetails);
        if(modelData.status == true){
          ShowToast.successToast(msg: modelData.message);
          setMappingInsert = true;
          navigator.pop();
        }else{
          ShowToast.successToast(msg: modelData.message);
        }
      }catch(e){
        debugPrint('The error is the $e');
      }
    } catch (e) {
      ShowToast.errorToast(msg: "An error occurred!");
      debugPrint('An error occurred while creating ledger: $e');
    }
  }
}

// {
// "objLedgerDetails": [
// {
// "Longitude": "",
// "OutletName": "TEKuUyuu",
// "PanNo": "461452",
// "Tag": "New1",
// "PhoneNo": "944444443",
// "Route": "",
// "AgentCode": "",
// "Address": "dhddD",
// "MobileNo": "5547646465",
// "Email": "tekukalimati112@gmail.com",
// "Latitude": "",
// "OutletCode": "",
// "ContactPerson": "hhdddddd",
// "PriceTag": "Wholedsaleee",
// "DbName": "MOBILEAP01"
// }
// ]
// }