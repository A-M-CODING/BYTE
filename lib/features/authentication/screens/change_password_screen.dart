import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/app_theme.dart';

class ChangePasswordScreen extends StatelessWidget {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  ChangePasswordScreen({Key? key}) : super(key: key);

  // Function to change password
  void _changePassword(BuildContext context) async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password fields cannot be empty")),
      );
      return;
    }
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      // Call the Firebase updatePassword method
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && newPassword == confirmPassword) {
        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password changed successfully!")),
        );
        // Optionally, sign out the user to force re-authentication with the new password
        // await FirebaseAuth.instance.signOut();
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred while changing the password.";
      if (e.code == 'weak-password') {
        errorMessage = "The password provided is too weak.";
      } else if (e.code == 'requires-recent-login') {
        errorMessage =
        "You need to have recently logged in to change your password.";
        // Prompt the user to re-authenticate here if necessary
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = AppTheme.of(context);

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
            icon:
            const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
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
                            child: Text(
                              localizations.changePassword, // Localized
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 20),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: Text(
                              localizations.enterNewPassword, // Localized
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey.shade700),
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
                              child: makeInput(
                                  label: localizations.newPassword,
                                  obscureText: true,
                                  theme: theme,

                                  controller: _newPasswordController),
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1300),
                              child: makeInput(
                                  label: localizations.confirmPassword,
                                  obscureText: true,
                                  theme: theme,
                                  controller: _confirmPasswordController),
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
                              border: Border.all(
                                color: theme.lineColor,  // Using theme for border color
                              ),
                            ),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () => _changePassword(context),
                              color: theme.primaryColor,  // Using primary color from theme
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                localizations.changePasswordButton,  // Localized text
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: theme.primaryBtnText,  // Text color from theme
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 1200),
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 3,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/password.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget makeInput({
    required String label,
    bool obscureText = false,
    required TextEditingController controller,
    required AppTheme theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: theme.primaryText, // Using theme for text color
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
                vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: theme.lineColor), // Using theme for border color
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.lineColor),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
