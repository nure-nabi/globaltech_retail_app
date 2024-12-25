import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/services/router/router_generator.dart';
import 'package:retail_app/services/router/router_name.dart';

import 'package:retail_app/themes/themes.dart';

import '../constants/text_style.dart';
import 'state_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    return MultiProvider(
      providers: myStateList,
      child: MaterialApp(
        title: 'OMS|Retail',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: primarySwatch,
          primaryColor: primaryColor,
          // textTheme: const TextTheme(
          //    titleMedium: TextStyle(
          //        fontSize: 14.0,
          //        fontWeight: FontWeight.bold,
          //        fontFamily: 'Montserrat Medium',
          //        color: Colors.black54,
          //    )
          // )
     
        ),
        initialRoute: splashPath,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
