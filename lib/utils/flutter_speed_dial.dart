import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/services/router/router_name.dart';
import '../../../widgets/widgets.dart';

import '../themes/fonts_style.dart';

class SpeedDialOptionsWidget extends StatelessWidget {
  const SpeedDialOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 11.0, bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "CLOSE TAG",
              backgroundColor: Colors.red,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close),
            ),
          ],
        ),
      ),
      body: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                _optionListOne(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _optionListOne(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          _buildOptions(
            icon: Icons.exit_to_app,
            label: "Pdc Entry",
            onTap: () {
              _navigateTo(context, routeName: pdcEntry);
            },
          ),
          _buildOptions(
            icon: Icons.report,
            label: "Pdc Report",
            onTap: () {
              _navigateTo(context, routeName: pDCScreen);
            },
          ),
        ],
      ),
    );
  }



  ///
  ///
  ///
  ///
  ///
  ///

  void _navigateTo(context, {required String routeName}) {
    Navigator.popAndPushNamed(context, routeName);
  }


  Widget _buildOptions({
    required IconData icon,
    required String label,
    required void Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 3,
                child: Container(
                  decoration: ContainerDecoration.decoration(
                    color: Colors.green,
                    bColor: Colors.green,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      label,
                      style: subTitleTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 3.0),
              Flexible(
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(icon),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
