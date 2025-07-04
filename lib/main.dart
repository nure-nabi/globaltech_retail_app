import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'constants/values.dart';
import 'native_android/native_bridge.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bind the native service
  try {
    // Initialize services
    await AppServiceBridge.initService();
   // await AppServiceBridge.getPackage();
   // await AppServiceBridge.bindService();

    // Check connection status
    final isConnected = await AppServiceBridge.isServiceConnected();
    if (isConnected == true) {
     // Fluttertoast.showToast(msg: "Service is connected");
      // Proceed with your app logic
    } else {
     // Fluttertoast.showToast(msg: "Service is not connected");
      // Handle connection failure
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Initialization failed: $e");
    // Handle initialization error
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    systemNavigationBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
  ));
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init('${directory.path}/globaltech_retails');
  await Hive.openBox(HiveDatabase.cache.name);
  runApp(const MyApp());
}

