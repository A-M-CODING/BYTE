import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/data/services/authentication_service.dart';
<<<<<<< HEAD
=======
import 'package:byte_app/features/form/screens/health_information_form.dart';
>>>>>>> fe279d9 (Updated community features)

class SignupScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      return CircularProgressIndicator();
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Text(
                  localizations.signUp, // Localized
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: Text(
                  localizations.signUpFree, // Localized
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: makeInput(label: localizations.email, controller: _emailController), // Localized
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1300),
                child: makeInput(label: localizations.password, obscureText: true, controller: _passwordController), // Localized
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1400),
                child: makeInput(label: localizations.confirmPassword, obscureText: true, controller: _confirmPasswordController), // Localized
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1500),
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
                    onPressed: () async {
                      final String email = _emailController.text.trim();
                      final String password = _passwordController.text.trim();
                      final String confirmPassword = _confirmPasswordController.text.trim();

                      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localizations.fieldRequired)), // Localized
                        );
                        return;
                      }

                      if (password != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localizations.passwordsDoNotMatch)), // Localized
                        );
                        return;
                      }

                      final result = await Provider.of<AuthenticationService>(
                        context,
                        listen: false,
                      ).signUp(email: email, password: password);

                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result)),
                        );
                      } else {
<<<<<<< HEAD
                        // TODO: Navigate to the next screen after sign up
=======
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HealthInformationForm()),
                        );
>>>>>>> fe279d9 (Updated community features)
                      }
                    },
                    color: Colors.greenAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      localizations.signUpButtonText, // Localized
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ),
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 1600),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(localizations.alreadyHaveAccount), // Localized
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to the login screen
                      },
                      child: Text(
                        localizations.loginButtonText, // Localized
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
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
