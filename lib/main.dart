import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'constants/values.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

