import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/data/services/authentication_service.dart';
import 'package:byte_app/features/form/screens/health_information_form.dart';
import 'package:byte_app/features/authentication/screens/login_screen.dart';
import 'package:byte_app/app_theme.dart'; // Importing the AppTheme

class SignupScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = AppTheme.of(context); // Accessing the AppTheme
    if (localizations == null) {
      return CircularProgressIndicator();
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.primaryBackground, // Using theme colors
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.primaryBackground,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, size: 20, color: theme.primaryText),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Adjusted spacing
            children: <Widget>[
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Text(
                  localizations!.signUp, // Localized
                  style: theme.title1, // Using theme typography
                ),
              ),
              const SizedBox(height: 10), // Reduced spacing
              FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: Text(
                  localizations.signUpFree, // Localized
                  style: theme.bodyText1,
                ),
              ),
              const SizedBox(height: 10), // Reduced spacing
              FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: makeInput(
                    label: localizations.email,
                    controller: _emailController,
                    theme: theme), // Localized
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1300),
                child: makeInput(
                    label: localizations.password,
                    obscureText: true,
                    controller: _passwordController,
                    theme: theme), // Localized
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1400),
                child: makeInput(
                    label: localizations.confirmPassword,
                    obscureText: true,
                    controller: _confirmPasswordController,
                    theme: theme), // Localized
              ),
              const SizedBox(height: 20), // Reduced spacing
              FadeInUp(
                duration: const Duration(milliseconds: 1500),
                child: Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: theme.primaryText),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () async {
                      final String email = _emailController.text.trim();
                      final String password = _passwordController.text.trim();
                      final String confirmPassword =
                      _confirmPasswordController.text.trim();

                      if (email.isEmpty ||
                          password.isEmpty ||
                          confirmPassword.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  localizations.fieldRequired)), // Localized
                        );
                        return;
                      }

                      if (password != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(localizations
                                  .passwordsDoNotMatch)), // Localized
                        );
                        return;
                      }

                      final result = await Provider.of<AuthenticationService>(
                        context,
                        listen: false,
                      ).signUp(email: email, password: password);

                      if (result != null) {
                        // Navigates to the HealthInformationForm after successful sign-up
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const HealthInformationForm()),
                        );
                      }
                    },
                    color: theme.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      localizations.signUpButtonText, // Localized
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: theme.primaryBtnText),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Reduced spacing
              FadeInUp(
                duration: const Duration(milliseconds: 1600),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(localizations.alreadyHaveAccount), // Localized
                    TextButton(
                      onPressed: () {
                        // Navigate to the login screen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginScreen()), // Replace with your login screen widget
                        );
                      },
                      child: Text(
                        localizations.loginButtonText, // Localized
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: theme.primaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
