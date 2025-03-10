import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../src/ledger_report_party_bill/provider/report_provider.dart';
import '../option_dialog_custom_option.dart';
import 'option_selection.dart';

Future<bool> showInformationDialog(
    BuildContext parentContext,
    OptionDialogCustomOption optionDialogCustomOption,
    String modalTitle,
    ) async {
  return await showDialog(
    context: parentContext,
    barrierDismissible: false,
    builder: (context) {
      final reportProvider = Provider.of<ReportProvider>(context, listen: true);
      var size = MediaQuery.of(context).size;
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          title:  Column(
            children: [
              Text(modalTitle,),
            ],
          ),
          content: OptionSelection(optionDialogCustomOption, parentContext),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text(
                'Okay',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                // if(modalTitle == "Month Attendance"){
                //   if(reportProvider.year != null && reportProvider.month != null){
                //     Navigator.of(context).pop(true);
                //   }else{
                //     Fluttertoast.showToast(msg: "Please select year and month");
                //   }
                // }else{
                // if(reportProvider.year != null && reportProvider.month != null){
                //   Navigator.of(context).pop(true);
                // }
                   Navigator.of(context).pop(true);
                // }


              },
            ),
          ],
        ),
      );
    },
  );


}

