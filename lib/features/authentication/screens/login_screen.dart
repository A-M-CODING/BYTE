import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:byte_app/data/services/authentication_service.dart';
import 'package:byte_app/features/form/screens/health_information_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/features/authentication/screens/signup_screen.dart';
import 'package:byte_app/features/community/screens/homedecider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:byte_app/features/authentication/controllers/set_provider.dart';
import 'package:byte_app/app_theme.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _checkFormCompletionAndNavigate(User user, BuildContext context) async {
    final formFilled = await FirebaseFirestore.instance
        .collection('user_health_data')
        .doc(user.uid)
        .get()
        .then((snapshot) => snapshot.data()?['formFilled'] ?? false);

    Provider.of<UserProvider>(context, listen: false).setUserId(user.uid);

    if (formFilled) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomeDecider()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HealthInformationForm()));
    }
  }

  void _signInWithEmailAndPassword(
      BuildContext context, AuthenticationService authService) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email and password cannot be empty")));
      return;
    }

    final result = await authService.signIn(email: email, password: password);
    if (result != null) {
      _checkFormCompletionAndNavigate(
          FirebaseAuth.instance.currentUser!, context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid email or password")));
    }
  }

  void _signInWithGoogle(
      BuildContext context, AuthenticationService authService) async {
    final result = await authService.signInWithGoogle();
    if (result != null) {
      _checkFormCompletionAndNavigate(
          FirebaseAuth.instance.currentUser!, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in with Google')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<AuthenticationService>(context, listen: false);
    final localizations = AppLocalizations.of(context);
    final appTheme = AppTheme.of(context);

    if (localizations == null) {
      return CircularProgressIndicator();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: appTheme.primaryBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.primaryBackground,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: appTheme.primaryText,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          FadeInUp(
                            duration: const Duration(milliseconds: 1000),
                            child: Text(localizations.loginTitle,
                                style: appTheme.title1),
                          ),
                          SizedBox(height: 20),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: Text(localizations.loginToYourAccount,
                                style: appTheme.bodyText1),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: <Widget>[
                            FadeInUp(
                              duration: const Duration(milliseconds: 1400),
                              child: makeInput(
                                label: localizations.email,
                                controller: _emailController,
                                theme: appTheme,
                              ),
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1500),
                              child: makeInput(
                                label: localizations.password,
                                obscureText: true,
                                controller: _passwordController,
                                theme: appTheme,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1600),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            padding: EdgeInsets.only(top: 3, left: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: appTheme.lineColor),
                            ),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () => _signInWithEmailAndPassword(
                                  context, authService),
                              color: appTheme.primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text(
                                localizations.loginButtonText,
                                style: appTheme.bodyText1
                                    .copyWith(color: appTheme.primaryBtnText),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1700),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            padding: EdgeInsets.only(top: 3, left: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: appTheme.lineColor),
                            ),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () =>
                                  _signInWithGoogle(context, authService),
                              color: appTheme.primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text(
                                localizations.signInWithGoogle,
                                style: appTheme.bodyText1
                                    .copyWith(color: appTheme.primaryBtnText),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1800),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(localizations.dontHaveAccount),
                            TextButton(
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => SignupScreen())),
                              child: Text(
                                localizations.signUp,
                                style: appTheme.bodyText1
                                    .copyWith(color: appTheme.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 1900),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.33,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/background3.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeInput(
      {required String label,
      bool obscureText = false,
      required TextEditingController controller,
      required AppTheme theme}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: theme.primaryText,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primaryText),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primaryText),
            ),
          ),
        ),
        const SizedBox(height: 20), // Reduced spacing
      ],
    );
  }
}
