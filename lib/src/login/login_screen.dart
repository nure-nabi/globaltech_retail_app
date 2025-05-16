import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/config/app_detail.dart';
import 'package:retail_app/services/services.dart';
import 'package:retail_app/src/login/companylist_screen.dart';
import 'package:retail_app/themes/themes.dart';
import 'package:retail_app/utils/loading_indicator.dart';
import 'package:retail_app/widgets/gerdient_container.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/text_style.dart';
import 'api/login_api.dart';
import 'login_state.dart';
import 'model/login_model.dart';
import 'setapi_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSubmittedUser = false;
  bool isSubmittedPassword = false;
  bool rememberMe = false;
  late final NavigatorState navigator;
  final LocalAuthentication localAuth = LocalAuthentication();
  @override
  void initState() {
    super.initState();
    Provider.of<LoginState>(context, listen: false).getContext = context;
    navigator = Navigator.of(context);
  }

  onBack() async {
    return SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return onBack();
      },
      child: Consumer<LoginState>(
        builder: (BuildContext context, state, Widget? child) {
          return GredientContainer(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(
                  AppDetails.appName,
                  style: cardTextStyleHeaderLogin,
                ),
              ),

              body: Padding(
                padding: const EdgeInsets.all(0.0),
                child: SingleChildScrollView(
                //  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20,),
                      Form(
                        key: state.loginKey,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(20),
                          width: 500,
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Card(
                            elevation: 4,
                            color: Colors.green[100],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/favicon.png',
                                      width: 100.0,
                                      height: 90.0,
                                    ),
                                    const SizedBox(height: 20.0),
                                    SizedBox(
                                      height: 45,
                                      child: TextFormField(
                                        controller: state.userNameController,
                                        cursorColor: Colors.orange,
                                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          hintText: 'Enter Username',
                                          hintStyle: hintTextStyle,
                                          labelText: 'Username',
                                          labelStyle: labelTextStyle,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14.0),
                                            borderSide: const BorderSide(
                                                color: Colors.orange, width: 1),
                                          ),
                                        ),
                                        onChanged: (text) {
                                          state.loginKey.currentState!.validate();
                                          isSubmittedUser = true;
                                          setState(() {

                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return null;
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    if (isSubmittedUser == true && state.userNameController.text.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            'Please enter user name',
                                            style: TextStyle(color: Colors.red, fontSize: 12.0),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(
                                      height: 14.0,
                                    ),
                                    SizedBox(
                                      height: 45,
                                      child: TextFormField(
                                        controller: state.passwordController,
                                        obscureText: state.isPasswordHidden,
                                        cursorColor: Colors.orange,
                                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                          suffixIcon: (state.isPasswordHidden) ? GestureDetector(
                                            onTap: () {
                                              state.showHidePassword = false;
                                            },
                                            child: const Icon(Icons.visibility,color: Colors.orange,),)
                                              : GestureDetector(
                                            onTap: () {
                                              state.showHidePassword = true;
                                            },
                                            child: const Icon(
                                              Icons.visibility_off,color: Colors.orange,),
                                          ),
                                          hintText: 'Enter password',
                                          hintStyle: hintTextStyle,
                                          labelText: 'Password',
                                          labelStyle: labelTextStyle,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(14.0)),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14.0),
                                            borderSide: const BorderSide(
                                                color: Colors.orange, width: 1),
                                          ),
                                        ),
                                        onChanged: (text) {
                                          state.loginKey.currentState!.validate();
                                          isSubmittedUser = true;
                                          setState(() {

                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return null;
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    if (isSubmittedPassword == true && state.passwordController.text.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            'Please enter password',
                                            style: TextStyle(color: Colors.red, fontSize: 12.0),
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Row(
                                        children: <Widget>[
                                           Text('Remember Login Credentials',style: cardTextStyleRemember,),
                                          Checkbox(
                                            checkColor: Colors.white,
                                            activeColor: Colors.orange,
                                            value: rememberMe,
                                            onChanged: (checked) {
                                              setState(() {
                                                rememberMe = checked!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20, bottom: 30),
                                      child: Material(
                                        color:
                                        Colors.orange[900]?.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(14.0),
                                        child: InkWell(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                              Colors.orange[900]?.withOpacity(0.9),
                                              borderRadius: BorderRadius.circular(14.0),
                                            ),
                                            height: 45.0,
                                            width: 100.0,
                                            child:  Center(
                                                child: Text(
                                                  'LOGIN',
                                                  style: cardTextStyleHeader,
                                                )),
                                          ),
                                          onTap: () {
                                            if(state.userNameController.text.isEmpty || state.passwordController.text.isEmpty){
                                              isSubmittedUser = true;
                                              isSubmittedPassword = true;
                                              setState(() {
                                        
                                              });
                                            }else {
                                              // Navigator.pushReplacement(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) => const CompanyListScreen(
                                              //       automaticallyImplyLeading: false,
                                              //     ),
                                              //   ),
                                              // );
                                              state.onLogin(context,rememberMe);
                                            }
                                          },
                                        ),
                                      ),
                                    ),

                                    Text(
                                      "OR",textAlign: TextAlign.center,
                                      style: cardTextStyleTitle,
                                    ),
                                    InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24.0),
                                        ),
                                        height: 50.0,
                                        width: 100.0,
                                        child:  Center(
                                            child: Text(
                                              'Set API',
                                              style: cardTextStyleTitle,
                                            )),
                                      ),
                                      onTap: () {
                                        state.apiController.text = "";
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: const SetAPISection(),
                                          ),
                                        );
                                      },
                                    ),
                                    FutureBuilder<bool>(
                                      future: localAuth.canCheckBiometrics,
                                      builder: (context, snapshot) {
                                        final data = snapshot.data;
                                        if (data != null && data == true) {
                                          return FutureBuilder(
                                            future: SharedPreferences.getInstance(),
                                            builder: (context, snapshot) {
                                              final prefs = snapshot.data;

                                              if (prefs != null && prefs.getBool('use_biometric') == true) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(bottom: 20),
                                                  child: InkWell(
                                                    onTap: () async {
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
                                                        CompanyModel model = await LoginAPI.login(
                                                          username: await GetAllPref.userName(),
                                                          password: await GetAllPref.getPassword());
                                                        if (isAuthenticated && model.statusCode == 200) {
                                                          context.read<LoginState>().getCompanyFromDatabase();
                                                          Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => const CompanyListScreen(
                                                                automaticallyImplyLeading: false,
                                                              ),
                                                            ),
                                                          );
                                                          // navigator.pushReplacement(PageTransition(
                                                          //   type: PageTransitionType.rightToLeft,
                                                          //   child: const CompanyListScreen(automaticallyImplyLeading: false),
                                                          // ));
                                                        //  Fluttertoast.showToast(msg: GetAllPref.unitCode());

                                                        }else{
                                                          Fluttertoast.showToast(msg: "Your password is not valid!");
                                                        }
                                                      });
                                                    },
                                                    child: const Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [Icon(Icons.fingerprint,color: Colors.orange,), SizedBox(width: 5), Text('Login with biometric',style: TextStyle(color: Colors.orange),)],
                                                    ),
                                                  ),
                                                );
                                              }

                                              return const SizedBox();
                                            },
                                          );
                                        }

                                        return const SizedBox();
                                      },
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          'Globaltechnepal Pvt. Ltd.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          'Address : Teku, Kathmandu Nepal.',
                          style: TextStyle(
                            fontSize: 14,
                            color:Colors.white,
                          ),
                        ),
                      ),
                      const Padding(
                        padding:  EdgeInsets.only(bottom: 5),
                        child: Text(
                          'Email : info@globaltechnepal.com.np',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          '+977 9851069643,9802069650',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: FutureBuilder<PackageInfo>(
                          future: PackageInfo.fromPlatform(),
                          builder: (context, snapshot) {
                            final data = snapshot.data;
                            if (data != null) {
                              return Text(
                                'Version ${data.version}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          if (state.isLoading) Center(child: LoadingScreen.loadingScreen());
        },
      ),
    );
  }
}
