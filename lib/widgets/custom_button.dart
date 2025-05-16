import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:retail_app/themes/themes.dart';

import '../constants/text_style.dart';
import '../src/ledger_master/ledger_master.dart';

class SaveButton extends StatelessWidget {
  final String buttonName;
  final void Function() onClick;
  final double? padding;
  final LedgerMasterState? state;
  const SaveButton({
    super.key,
    required this.buttonName,
    required this.onClick,
    this.padding = 8,
    this.state ,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 5,
      color: primaryColor,
      child: InkWell(
        onTap:  () {
          onClick();
        },
        child: Padding(
          padding:  EdgeInsets.all(padding!),
          child: Text(
            buttonName,
            textAlign: TextAlign.center,
            style: cardTextStyleHeader,
          ),
        ),
      ),
    );
  }
}

class CancleButton extends StatelessWidget {
  final String buttonName;
  final void Function() onClick;
  const CancleButton({
    super.key,
    required this.buttonName,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: errorColor,
      child: InkWell(
        onTap: () {
          onClick();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            buttonName,
            textAlign: TextAlign.center,
            style: cardTextStyleHeader ,
          ),
        ),
      ),
    );
  }
}
