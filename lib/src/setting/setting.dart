import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemSettingPage extends StatefulWidget {
  const SystemSettingPage({super.key});

  @override
  State<SystemSettingPage> createState() => _SystemSettingPageState();
}

class _SystemSettingPageState extends State<SystemSettingPage> {
  final LocalAuthentication localAuth = LocalAuthentication();
  @override
  Widget build(BuildContext context) {

    List<Widget> settingList = [
      FutureBuilder(
        future: Future.wait([
          localAuth.canCheckBiometrics,
          SharedPreferences.getInstance(),
        ]),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data != null) {
            bool canCheckBiometric = data[0] as bool;
            SharedPreferences prefs = data[1] as SharedPreferences;

            if (canCheckBiometric) {
              return ListTile(
                leading: const Icon(
                  Icons.fingerprint,
                  color: Colors.black,
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Use Biometric',
                      style: TextStyle(color: Colors.black),
                    ),
                    StatefulBuilder(
                      builder: (context, setState) {
                        bool isBiometricEnabled = prefs.getBool('use_biometric') == true;

                        return FlutterSwitch(
                          width: 60.0,
                          height: 30.0,
                          toggleSize: 25.0,
                          value: isBiometricEnabled,
                          borderRadius: 30.0,
                          padding: 2.0,
                          activeToggleColor: Colors.green,
                          inactiveToggleColor: Colors.grey,
                          activeSwitchBorder: Border.all(
                            color: Colors.grey,
                            width: 2.5,
                          ),
                          inactiveSwitchBorder: Border.all(
                            color: Colors.grey,
                            width: 2.5,
                          ),
                          activeColor: Colors.white,
                          inactiveColor: Colors.white,
                          activeIcon: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          inactiveIcon: const Icon(
                            Icons.close,
                            color: Color(0xFFFFDF5D),
                          ),
                          onToggle: (checked) async {
                            final LocalAuthentication localAuth = LocalAuthentication();

                            await localAuth
                                .authenticate(
                              localizedReason: 'Scan your fingerprint',
                              options: const AuthenticationOptions(
                                useErrorDialogs: true,
                                stickyAuth: true,
                                biometricOnly: true,
                              ),
                            )
                                .then((isAuthenticated) async {
                              if (isAuthenticated) {
                                await SharedPreferences.getInstance().then((prefs) async {
                                  if (checked) {
                                    await prefs.setBool('use_biometric', true).then(
                                          (_) => Fluttertoast.showToast(msg: 'Enabled Biometric Login'),
                                    );
                                  } else {
                                    await prefs.setBool('use_biometric', false).then(
                                          (_) => Fluttertoast.showToast(msg: 'Disabled Biometric Login'),
                                    );
                                  }
                                  setState(() => isBiometricEnabled = checked);
                                });

                              }
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          }
          return const SizedBox();
        },
      ),
    ];

    return  Scaffold(
      appBar: AppBar(title: const Text('System Setting')),
      body: SafeArea(
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: settingList.length,
          itemBuilder: (context, index) => settingList[index],
        ),
      ),
    );
  }
}
