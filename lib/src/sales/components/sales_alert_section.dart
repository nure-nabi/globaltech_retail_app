import 'package:flutter/material.dart';

import '../../../services/router/router_name.dart';
import '../../../services/services.dart';
import '../../../themes/themes.dart';
import '../../../widgets/widgets.dart';

class OrderCompleteAlert {
  show({
    required BuildContext context,
    required String text,
    required bool isSuccess,
  }) {
    ShowAlert(context).alert(
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: titleTextStyle.copyWith(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                verticalSpace(10.0),
                ElevatedButton(
                  onPressed: isSuccess
                      ? () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, indexPath, (route) => false);
                  }
                      : () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
