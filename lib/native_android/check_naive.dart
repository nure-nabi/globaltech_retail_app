import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:retail_app/themes/colors.dart';

import 'native_bridge.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController textEditingController = TextEditingController();
  late String resultText = '';
  var channel2 = const MethodChannel('uniqueChannelName');

  Future<void> callPaymentNativeCode(String userName) async {
    try {
     // resultText = await channel.invokeMethod('userName', {'username': userName});
      // AppServiceBridge.makeTransaction2();
      await AppServiceBridge.makeTransaction(
        amount: 1.0, // amount in smallest currency unit
        transType: 'Fonepay',
        remarks: 'Test payment',
      );
      setState(() {});
    } catch (_) {}
  }

  Future<void> callLogoNativeCode(String userName) async {
    try {
      await AppServiceBridge.doLogon();
      setState(() {});
    } catch (_) {}
  }

  Future<void> callSettlement(String userName) async {
    try {
      await AppServiceBridge.setTlement();
      setState(() {});
    } catch (_) {}
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }


  Future<void> _makePayment() async {
    try {
      await AppServiceBridge.makeTransaction(
        amount: 10000, // amount in smallest currency unit
        transType: 'PURCHASE',
       // paymentEntryMode: 'CHIP',
        remarks: 'Test payment',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Code'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
              color: primaryColor
            ),
          ),


          Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  ElevatedButton(
                    onPressed: (){
                      callPaymentNativeCode("");
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Bootstrap.bag),
                          SizedBox(width: 10,),
                          Text("Sale",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),

                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.deepPurpleAccent.withOpacity(0.5)
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap:(){
                                callLogoNativeCode("");
                              },
                              child: Column(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Colors.white
                                      ),
                                      child: const Icon(Bootstrap.shield_check,size: 30,)),
                                  const SizedBox(height: 10,),
                                  const Text("Logo",style: TextStyle(fontWeight: FontWeight.w400),)
                                ],
                              ),
                            ),
                            SizedBox(width: 20,),
                            InkWell(
                              onTap:(){
                                callSettlement("");
                              },
                              child: Column(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Colors.white
                                      ),
                                      child: const Icon(Bootstrap.hand_thumbs_up,size: 30,)),
                                  const SizedBox(height: 10,),
                                  const Text("Settle",style: TextStyle(fontWeight: FontWeight.w400),)
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
          )
        ],
      )

      // Center(
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 30),
      //         child: TextField(
      //           controller: textEditingController,
      //           decoration: const InputDecoration(
      //             labelText: 'Enter UserName',
      //           ),
      //         ),
      //       ),
      //       const SizedBox(
      //         height: 30,
      //       ),
      //       MaterialButton(
      //         color: Colors.teal,
      //         textColor: Colors.white,
      //         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      //         onPressed: () {
      //           String userName = textEditingController.text;
      //
      //           if (userName.isEmpty) {
      //             userName = "FreeTrained";
      //           }
      //           //_makePayment();
      //           callNativeCode(userName);
      //         },
      //         child: const Text('Click Me'),
      //       ),
      //       const SizedBox(
      //         height: 20,
      //       ),
      //       Text(
      //         resultText,
      //         style: const TextStyle(fontSize: 20),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}