import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/config/app_detail.dart';
import 'package:retail_app/themes/themes.dart';
import 'package:retail_app/widgets/gerdient_container.dart';
import 'package:retail_app/widgets/widgets.dart';
import '../../constants/text_style.dart';
import 'splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<SplashState>(context, listen: false).getContext = context;
    return Consumer<SplashState>(
      builder: (context, state, child) {
        return GredientContainer(
          reverseGredient: true,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppDetails.organizeBy,
                style: subTitleTextStyle.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            body: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Center(
                      child: Image.asset(
                        'assets/images/favicon.png',
                        width: 90.0,
                      ),
                    ),
                  ),
                  verticalSpace(10),
                  Text(
                    AppDetails.appName,
                    textAlign: TextAlign.center,
                    style: cardTextStyleHeader,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
