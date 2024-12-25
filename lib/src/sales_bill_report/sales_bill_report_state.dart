import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retail_app/services/sharepref/get_all_pref.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/src/pdf/sales_bill_pdf.dart';
import 'package:retail_app/src/sales_bill_report/api/sales_bill_report_api.dart';
import 'package:retail_app/src/sales_bill_report/model/sales_bill_report_model.dart';
import 'package:retail_app/utils/date_formater.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import 'db/sales_bill_report.dart';

class SalesBillReportState extends ChangeNotifier {
  SalesBillReportState();

  var value;
  late BuildContext _context;

  BuildContext get context => _context;
  late NavigatorState navigator;

  set getContext(BuildContext value) {
    _context = value;
    navigator = Navigator.of(_context);

    ///
  }

  late bool _isLoading = false;

  bool get isLoading => _isLoading;

  set getLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  init({required String billNo}) async {
    await clean();
    await getSalesBillReportFromAPI(billNo: billNo);
    _companyDetail = await GetAllPref.companyDetail();
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

  late List<SalesBillReportDataModel> _dataList = [];

  List<SalesBillReportDataModel> get dataList => _dataList;

  set getDataList(List<SalesBillReportDataModel> value) {
    _dataList = value;
    notifyListeners();
  }

  getSalesBillReportFromAPI({required String billNo}) async {
    getLoading = true;
    SalesBillReportModel model = await SalesBillReportApi.apiCall(
      databaseName: _companyDetail.dbName,
      billNo: billNo,
      unit: await GetAllPref.unitCode(),
    );

    if (model.statusCode == 200) {
      //getDataList = model.data;
      await onSuccess(dataModel: model.data);
      getLoading = false;
    } else {
      getLoading = false;
    }
    notifyListeners();
  }
  onSuccess({required List<SalesBillReportDataModel> dataModel}) async {
    await SalesBillReportDbDatabase.instance.deleteData();

    for (var element in dataModel) {
      await SalesBillReportDbDatabase.instance.insertData(element);
    }
    await getCustomerListFromDB();
    notifyListeners();
  }

  getCustomerListFromDB() async {
    await SalesBillReportDbDatabase.instance.getAllSalesReportData().then((value) {
      getDataList = value;
    });
    calculate();
    notifyListeners();
  }

  late List<SalesBillReportDataModel> _salesBillReportList = [];
  List<SalesBillReportDataModel> get salesBillReportList => _salesBillReportList;


  set getSaleSalesBillList(List<SalesBillReportDataModel> value) {
    _salesBillReportList = value;
    getDataList = value;
     calculate();
    notifyListeners();
  }

  double _hTermAmount = 0.0;
   double get hTermAmount => _hTermAmount;
  double _hNetAmount = 0.0;
  double get hNetAmount => _hNetAmount;
  double _hBasicAmount = 0.0;
  double get hBasicAmount => _hBasicAmount;

  set gethTermAmt(double hTerm){
    _hTermAmount = hTerm;
    notifyListeners();
  }
  set getHnetAmt(double hNet){
    _hNetAmount = hNet;
    notifyListeners();
  }

  set getBasicAmt(double hNet){
    _hBasicAmount = hNet;
    notifyListeners();
  }

  calculate(){
    double hTetmAmt = 0.0;
    double hNetAmt = 0.0;
    double hBasicAmt = 0.0;
    for(int i =0; i<dataList.length;++i){
      hTetmAmt = double.parse(dataList[i].hTermAMt);
      hNetAmt = double.parse(dataList[i].hNetAmt);
      hBasicAmt = double.parse(dataList[i].hBasicAMt);
    }
    gethTermAmt = hTetmAmt;
    getHnetAmt = hNetAmt;
    getBasicAmt = hBasicAmt;
    notifyListeners();
  }

  set getCompanyDetail(CompanyDetailsModel value) {
    _companyDetail = value;
    notifyListeners();
  }

  onPrint({required String name}) async {
    double dNetAmt = 0.00;
    double dTermAMt = 0.00;
    double totalAMT = 0.00;
    int i = 1;
    for (var value in dataList) {
      dNetAmt += double.parse(value.dNetAmt);
      dTermAMt += double.parse(value.dTermAMt);
      totalAMT = dNetAmt + dTermAMt;

      final pdfFile = await PdfInvoiceApiSales.generate(
        companyDetails: _companyDetail,
        vNo: value.hvno,
        customer: value.hGlDesc,
        address: value.address,
        phone: value.hMobileNo,
        panNo: value.hPanNo,
        dpDesc: value.dpDesc,
        balanceAmt: value.balanceAmt,
        date: DateConverter.nepaliToEnglish(
          year: int.parse(value.hMiti.split("/").last),
          month: int.parse(value.hMiti.split("/").elementAt(1)),
          day: int.parse(value.hMiti.split("/").first),
        ).toString().substring(0, 10).replaceAll("-", "/"),
        miti: value.hMiti,
        dataList: dataList,
        totalAmount: totalAMT,
        totalNetAmount: double.parse(value.hNetAmt).toStringAsFixed(2),
        totalTermAmount: double.parse(value.hTermAMt).toStringAsFixed(2),
        billTitleName: 'Sales Invoice',
      );

      ////  opening the pdf file
      FileHandleApiSales.openFile(pdfFile);
    }
    notifyListeners();
  }

  Future<void> printReceipt({required List<SalesBillReportDataModel> value}) async {

    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    /// COMPANY NAME
     await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
     await SunmiPrinter.setCustomFontSize(21);
     await SunmiPrinter.printText(_companyDetail.aliasName);

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
          text: item.dpDesc,
          width: 15,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: double.parse(item.dQty).toStringAsFixed(0),
          width: 5,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          text: double.parse(item.dLocalRate).toStringAsFixed(1) ,
          width: 7,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: double.parse(item.dNetAmt).toStringAsFixed(1) ,
          width: 9,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
      grandTotal += double.parse(double.parse(item.dNetAmt).toStringAsFixed(1));
      await SunmiPrinter.lineWrap(0);
    }

    await SunmiPrinter.line();

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