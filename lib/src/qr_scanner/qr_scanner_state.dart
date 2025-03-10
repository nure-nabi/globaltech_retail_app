import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/custom_log.dart';
import 'db/db_scanner.dart';
import 'model/qr_scanner_model.dart';

class QRScanState extends ChangeNotifier {
  QRScanState();

  late BuildContext _context;

  BuildContext get context => _context;
  late final NavigatorState navigator = Navigator.of(_context);

  set getContext(BuildContext value) {
    _context = value;
    init();
  }

  init() async {
    await clean();
    await getAllListFromDataBase();
  }

  Future<void> clean() async {
    _isLoading = false;
    _dataList = [];
    _productList = [];
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<QRDataModel> _dataList = [];

  List<QRDataModel> get dataList => _dataList;

  set dataList(List<QRDataModel> value) {
    _dataList = value;
    notifyListeners();
  }

  late List<QRDataModel> _productList = [];

  List<QRDataModel> get productList => _productList;

  set getProductList(List<QRDataModel> value) {
    _productList = value;
    notifyListeners();
  }

  List<QRDataModel>? parseQRDataList(String data) {
    try {
      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((item) => QRDataModel.fromJson(item)).toList();
    } catch (e) {
      try {
        final Map<String, dynamic> jsonData = json.decode(data);
        return [QRDataModel.fromJson(jsonData)];
      } catch (e) {
        CustomLog.errorLog(value: "Error parsing QR data: $e");
        return null;
      }
    }
  }

  Future<void> processQRData(String? scanData) async {
    if (scanData == null) {
      Fluttertoast.showToast(msg: "No QR data received");
      return;
    }
    isLoading = true;
    try {
      final qrDataList = parseQRDataList(scanData);
      if (qrDataList != null && qrDataList.isNotEmpty) {
        for (var qrData in qrDataList) {
          await QRScanDatabase.instance.insertData(qrData);
        }
        await onSuccess(dataModel: qrDataList.toList());
        isLoading = false;
        notifyListeners();
      } else {
        CustomLog.errorLog(value: "Invalid QR format: $scanData");
      }
    } catch (e) {
      CustomLog.errorLog(value: "Error processing QR code: $e");
    } finally {
      isLoading = false;
    }
  }

  onSuccess({required List<QRDataModel> dataModel}) async {
    await QRScanDatabase.instance.deleteData();
    for (var element in dataModel) {
      await QRScanDatabase.instance.insertData(element);
    }
    await getAllListFromDataBase();
    notifyListeners();
  }

  getAllListFromDataBase() async {
    isLoading = true;
    await QRScanDatabase.instance.getAllData().then((value) {
      getProductList = value;
    });
    isLoading = false;
    notifyListeners();
  }
}