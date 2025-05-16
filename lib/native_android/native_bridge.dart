import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppServiceBridge {
  //static const MethodChannel _channel = MethodChannel('com.example.clientapp/app_service');
  static const MethodChannel _channel = MethodChannel('com.example.clientapp');
  static const EventChannel _eventChannel = EventChannel('payment_events');

  static Future<void> initService() async {
    await _channel.invokeMethod('initService');

  }

  static Future<void> bindService() async {

    await _channel.invokeMethod('bindService');
  }

  static Future<void> doLogon() async {
    await _channel.invokeMethod('doLogon');
  }

  static Future<void> setTlement() async {
    await _channel.invokeMethod('settlement');
  }
  static Future<void> printNative({
    required StringBuffer header,
    required String content,
    required StringBuffer footer,
    required String companyName,
    required String refrenceId,
    required String paymentMode,
}) async {


    try{
      final  response =  await _channel.invokeMethod('printReceipt', {
        'heading': header.toString(),
        'content': content.toString(),
        'footer': footer.toString(),
        'companyName': companyName.toString(),
        'refrenceId': refrenceId.toString(),
        'paymentMode': paymentMode.toString(),
      });
    }  on PlatformException catch (e) {
      Fluttertoast.showToast(msg: "${e.message}");
      throw Exception('Failed to make transaction: ${e.message}');
    }

  }

  static Future<String?> getSerialNumber() async {
     final String? result = await _channel.invokeMethod('getSerialNumber');
     Fluttertoast.showToast(msg: result.toString());
    return result;
  }

  static Future<void> makeTransaction2() async {

    await _channel.invokeMethod('makeTransaction');
  }

  static Future<void> launchApp() async {

    await _channel.invokeMethod('launchApp');
  }

  static Future<String> makeTransaction({
    required double amount,
    required String transType,
    String? remarks,
  }) async {
    try {

      final  response =  await _channel.invokeMethod('makeTransaction', {
        'amount': amount, // as int
        'transType': transType,
        'remarks': remarks ?? '',
      });

      String referenceId= "";
      if (response is Map) {
        referenceId = '${response['ReferenceId']}';
        print('Message: ${response['message']}');
        print('Result Code: ${response['ReferenceId']}');
      //  Fluttertoast.showToast(msg: 'Result Code ${response['resultCode']}');
        // Or if it's from onSuccess:
        print('Success: ${response['success']}');
      }
      return referenceId;
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: "${e.message}");
      throw Exception('Failed to make transaction: ${e.message}');
    }
  }

  static Stream<Map<String, dynamic>> get paymentEvents {
    return _eventChannel.receiveBroadcastStream().map((event) {
      return Map<String, dynamic>.from(event as Map);
    });
  }


  static Future<bool?> isServiceConnected() async {
    final bool? result = await _channel.invokeMethod('isServiceConnected');
    Fluttertoast.showToast(msg: result.toString());
    return result;
  }

// Add other methods as needed...
}