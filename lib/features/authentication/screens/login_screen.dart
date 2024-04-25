// login_screen.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:byte_app/data/services/authentication_service.dart';
import 'package:byte_app/features/form/screens/health_information_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/features/authentication/screens/signup_screen.dart';
<<<<<<< HEAD
import 'package:byte_app/features/profile/screens/profile_page.dart';
=======
import 'package:byte_app/features/community/screens/homedecider.dart';
>>>>>>> fe279d9 (Updated community features)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);

  // Function to check if form is filled and navigate accordingly
  void _checkFormCompletionAndNavigate(User user, BuildContext context) async {
    final formFilled = await FirebaseFirestore.instance
        .collection('user_health_data')
        .doc(user.uid)
        .get()
        .then((snapshot) => snapshot.data()?['formFilled'] ?? false);

    if (formFilled) {
<<<<<<< HEAD
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ProfilePage()));
=======
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeDecider()));
>>>>>>> fe279d9 (Updated community features)
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HealthInformationForm()));
    }
  }

  // Function to handle email/password sign-in
  void _signInWithEmailAndPassword(BuildContext context, AuthenticationService authService) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email and password cannot be empty")));
      return;
    }

    final result = await authService.signIn(email: email, password: password);
    if (result != null) {
      _checkFormCompletionAndNavigate(FirebaseAuth.instance.currentUser!, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid email or password")));
    }
  }

  // Function to handle Google sign-in
  void _signInWithGoogle(BuildContext context, AuthenticationService authService) async {
    final result = await authService.signInWithGoogle();
    if (result != null) {
      _checkFormCompletionAndNavigate(FirebaseAuth.instance.currentUser!, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to sign in with Google')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationService>(context, listen: false);
    final localizations = AppLocalizations.of(context);

    // Ensure localizations are loaded
    if (localizations == null) {
      return CircularProgressIndicator();
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
<<<<<<< HEAD
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: Text(
                          localizations.loginTitle, // Localized
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: Text(
                          localizations.loginToYourAccount, // Localized
                          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
=======
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          FadeInUp(
                            duration: const Duration(milliseconds: 1000),
                            child: Text(
                              localizations.loginTitle, // Localized
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 20),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: Text(
                              localizations.loginToYourAccount, // Localized
                              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: <Widget>[
                            FadeInUp(
                              duration: const Duration(milliseconds: 1200),
                              child: makeInput(label: localizations.email, controller: _emailController), // Localized
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1300),
                              child: makeInput(label: localizations.password, obscureText: true, controller: _passwordController), // Localized
                            ),
                          ],
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1400),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            padding: const EdgeInsets.only(top: 3, left: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: const Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                              ),
                            ),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () => _signInWithEmailAndPassword(context, authService),
                              color: Colors.greenAccent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                localizations.loginButtonText, // Localized
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1400),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            padding: const EdgeInsets.only(top: 3, left: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.black),
                            ),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () => _signInWithGoogle(context, authService),
                              color: Colors.blueAccent, // Change this if you want to match the green accent of the login button
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                localizations.signInWithGoogle, // Localized
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ), FadeInUp(
                        duration: const Duration(milliseconds: 1500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(localizations.dontHaveAccount), // Localized
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => SignupScreen()),
                                );
                              },
                              child: Text(
                                localizations.signUp, // Localized
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ),
                          ],
>>>>>>> fe279d9 (Updated community features)
                        ),
                      ),
                    ],
                  ),
<<<<<<< HEAD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: makeInput(label: localizations.email, controller: _emailController), // Localized
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: makeInput(label: localizations.password, obscureText: true, controller: _passwordController), // Localized
                        ),
                      ],
                    ),
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1400),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: const EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: const Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                          ),
                        ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () => _signInWithEmailAndPassword(context, authService),
                          color: Colors.greenAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            localizations.loginButtonText, // Localized
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
            FadeInUp(
              duration: const Duration(milliseconds: 1400),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () => _signInWithGoogle(context, authService),
                    color: Colors.blueAccent, // Change this if you want to match the green accent of the login button
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      localizations.signInWithGoogle, // Localized
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
=======
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 1200),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.cover,
>>>>>>> fe279d9 (Updated community features)
                      ),
                    ),
                  ),
                ),
<<<<<<< HEAD
              ),
            ), FadeInUp(
                    duration: const Duration(milliseconds: 1500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(localizations.dontHaveAccount), // Localized
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => SignupScreen()),
                            );
                          },
                          child: Text(
                            localizations.signUp, // Localized
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 1200),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
=======
              ],
            ),
          ),
        ));
>>>>>>> fe279d9 (Updated community features)
  }

  Widget makeInput({required String label, bool obscureText = false, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
