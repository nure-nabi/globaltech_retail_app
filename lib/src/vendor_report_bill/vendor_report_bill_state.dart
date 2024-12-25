import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/services/sharepref/get_all_pref.dart';
import 'package:retail_app/src/ledger_report_party_bill/model/cash_Bank_Model.dart';
import 'package:retail_app/src/ledger_report_party_bill/model/ledger_report_model.dart';
import 'package:retail_app/src/ledger_report_party_bill/model/ledger_report_party_model.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/pdf/cash_bank_pdf.dart';
import 'package:retail_app/src/pdf/ledger_report_share_pdf.dart';
import 'package:retail_app/src/vendor_report_bill/api/vendor_report_bill_api.dart';
import 'package:retail_app/src/vendor_report_bill/db/vendor_report_bill_db.dart';
import 'package:retail_app/src/vendor_report_bill/vendor_repert_bill_pdf.dart';
import 'package:retail_app/utils/custom_log.dart';

import '../datepicker/date_picker_state.dart';
import '../pdf/bill_pdf.dart';

class VendorReportBillState extends ChangeNotifier {
  VendorReportBillState();

  late BuildContext _context;

  BuildContext get context => _context;
  late NavigatorState navigator;

  set getContext(BuildContext value) {
    _context = value;
    navigator = Navigator.of(_context);
  }

  late bool _isLoading = false;
  bool get isLoading => _isLoading;
  set getLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  late String _dateMapping = "";

  String get dateMapping => _dateMapping;

  set getDataMappingData(String value) {
    _dateMapping = value;
    notifyListeners();
  }

  init({required String glCode}) async {
    // await clean();
    _companyDetail = await GetAllPref.companyDetail();
    await getVendorReportPartyBillApi(glCode: glCode);
  }

  clean() async {
    _isLoading = false;
    _companyDetail = await GetAllPref.companyDetail();
  }

  late CompanyDetailsModel _companyDetail = CompanyDetailsModel.fromJson({});

  CompanyDetailsModel get companyDetail => _companyDetail;

  set companyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  late List<LedgerPartyReportDataModel> _dataList = [];

  List<LedgerPartyReportDataModel> get dataList => _dataList;

  set getDataList(List<LedgerPartyReportDataModel> value) {
    if (value.isNotEmpty) {
      _dataList = value;
      notifyListeners();
    } else {
      debugPrint('Data list is empty');
    }
  }

  onDatePickerConfirm() async {
    // getDataList = [];
    getFromDate = Provider.of<DatePickerState>(context, listen: false).fromDate;
    getToDate = Provider.of<DatePickerState>(context, listen: false).toDate;
    // await getDataFromDatabase().whenComplete(() {
    //   Navigator.pop(context);
    // });

    getLedgerDateWiseFromDB("","");
    notifyListeners();
  }
  String toDate = "";
  String fromDate = "";
  set getFromDate(String value) {
    fromDate = value.replaceAll("/", "-");
    notifyListeners();
  }

  set getToDate(String value) {
    toDate = value.replaceAll("/", "-");
    notifyListeners();
  }


  getVendorReportPartyBillApi({required String glCode}) async {
    getLoading = true;
    LedgerPartyReportModel model = await VendorReportPartyBillApi.apiCall(
      databaseName: _companyDetail.dbName,
      glCode: glCode,
    );
    if (model.status_code == 200) {
      await onSuccess(modelData: model.data);
      getLoading = false;
    } else {
      getLoading = false;
    }
    notifyListeners();
  }

  Future<List<LedgerPartyReportDataModel>>getVendorReportTotalApi({required String glCode}) async {
    LedgerPartyReportModel model = await VendorReportPartyBillApi.apiCall(
      databaseName: _companyDetail.dbName,
      glCode: glCode,
    );
    if (model.status_code == 200) {
      return model.data;

    } else {
      return [];
    }
    notifyListeners();
  }

  onSuccess({required List<LedgerPartyReportDataModel> modelData}) async {
    await VendorBillReportDatabase.instance.deleteData();
    for (int i=0; i<modelData.length; i++) {
      double drAmt = 0;
      double crAmt = 0;
      for (int j = 0; j <= i; j++) {
        drAmt += double.parse(modelData[j].dr);
        crAmt += double.parse(modelData[j].cr);
      }
      double amt = drAmt - crAmt;
      LedgerReportModel model = LedgerReportModel(
          vno: modelData[i].vno,
          date: modelData[i].date,
          miti: modelData[i].miti,
          source: modelData[i].source,
          dr: modelData[i].dr,
          cr: modelData[i].cr,
          totalAmount: amt.toString(),
          narration: modelData[i].narration,
          remarks: modelData[i].remarks
      );
      await VendorBillReportDatabase.instance.insertData(model);
    }
    //   await getLedgerWiseFromDB();
    await getLedgerDateWiseFromDB(fromDate,toDate);
    notifyListeners();
  }

  getLedgerWiseFromDB() async {
    await VendorBillReportDatabase.instance.getLedgerWiseReport().then((value) {
      //  LedgerWiseList.clear();
      //getLedgerWiseReportList = value;
    });
    notifyListeners();
  }

  getLedgerDateWiseFromDB( String fromDate1, String toDate1,) async {
    await VendorBillReportDatabase.instance.getDateWiseList(fromDate: fromDate, toDate: toDate).then((value) {
      //getLedgerWiseReportList = [];
      toDate="";
      fromDate="";
      getLedgerWiseReportList = value;
    });
    notifyListeners();
  }

  late List<LedgerReportModel> _LedgerWiseList = [];
  List<LedgerReportModel> get LedgerWiseList => _LedgerWiseList;

  set getLedgerWiseReportList(List<LedgerReportModel> value) {
    _LedgerWiseList = value;
    notifyListeners();
  }

  shareLedger() async {
    CustomLog.log(value: _companyDetail.ledgerCode);
    await generateVendorLedgerReport(
      companyDataDetails: _companyDetail,
      purchaseLedgerReport: LedgerWiseList,
      vno: '',
      date: '',
      miti: '',
      source: '',
      dr: '',
      cr: '',
      narration: '',
      remarks: '',
      showEnglishDate: true,
    );
  }

  late List<CashBankPrintDataModel> _cashBankDataList = [];
  List<CashBankPrintDataModel> get cashBankDataList => _cashBankDataList;
  set getCashBankDataList(List<CashBankPrintDataModel> value) {
    _cashBankDataList = [];
    _cashBankDataList = value;
    notifyListeners();
  }

  getCashBankPrintFromAPI({required String vno}) async {
    getLoading = true;
    _companyDetail = await GetAllPref.companyDetail();
    CashBankPrintModel reportModel = await VendorReportPartyBillApi.cashBankPrint(
      databaseName: _companyDetail.dbName,
      vNo: vno,
    );

    // CB-0022

    if (reportModel.statusCode == 200) {
      getCashBankDataList = reportModel.data;
      getLoading = false;
      await onPrint();
    } else {
      getLoading = false;
    }
    notifyListeners();
  }

  onPrint() async {
    for (var value in _cashBankDataList) {
      final pdfFile = await CashBankPdfInvoiceApi.generate(
        companyDetails: _companyDetail,
        billTitleName:
        value.reclocalAmt == 0.00 ? "Payment Voucher" : "Receipt Voucher",
        receivedNo: value.vNo,
        date: value.vmiti,
        receivedFrom: value.detailsLedger,
        recAmount: value.reclocalAmt,
        payAmount: value.payLocalAmt,
        remarks: value.remarks,
        receivedBy:'',
      );

      ////  opening the pdf file
      FileHandleApi.openFile(pdfFile);
    }

    notifyListeners();
  }

}