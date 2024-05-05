import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../authentication/screens/login_screen.dart';
import '../../authentication/screens/signup_screen.dart';
import 'package:byte_app/localization/locale_provider.dart';
import 'package:byte_app/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.of(context);
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      return CircularProgressIndicator();
    }

    // Language dropdown list items
    List<DropdownMenuItem<String>> langItems = [
      DropdownMenuItem(child: Text("English"), value: 'en'),
      DropdownMenuItem(child: Text("اردو"), value: 'ur'),
      DropdownMenuItem(child: Text("Deutsch"), value: 'de'),
      DropdownMenuItem(child: Text("العربية"), value: 'ar'),
      DropdownMenuItem(child: Text("한국어"), value: 'ko'),
      DropdownMenuItem(child: Text("हिंदी"), value: 'hi'),
      DropdownMenuItem(child: Text("中文"), value: 'zh'),
    ];

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        actions: [
          DropdownButtonHideUnderline(
            child: Padding(
              padding: EdgeInsets.only(right: 10), // Add padding to the right
              child: DropdownButton<String>(
                icon: Icon(Icons.language, color: theme.primaryColor),
                items: langItems,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    Locale newLocale = Locale(newValue);
                    Provider.of<LocaleProvider>(context, listen: false)
                        .setLocale(newLocale);
                  }
                },
                value: Localizations.localeOf(context).languageCode,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30), // Added space after AppBar
                FadeInUp(
                  duration: Duration(milliseconds: 1000),
                  child: Text(
                    localizations.welcome,
                    style: theme.title1,
                  ),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  duration: Duration(milliseconds: 1200),
                  child: Text(
                    localizations.verifyIdentity,
                    textAlign: TextAlign.center,
                    style: theme.bodyText1,
                  ),
                ),
                FadeInUp(
                  duration: Duration(milliseconds: 1400),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Illustration2.png'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: 30), // Increased space between image and button
                FadeInUp(
                  duration: Duration(milliseconds: 1500),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: theme.lineColor,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      localizations.login,
                      style: theme.subtitle1,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  duration: Duration(milliseconds: 1600),
                  child: Container(
                    padding: EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border(
                        bottom: BorderSide(color: theme.lineColor),
                        top: BorderSide(color: theme.lineColor),
                        left: BorderSide(color: theme.lineColor),
                        right: BorderSide(color: theme.lineColor),
                      ),
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      ),
                      color: theme.secondaryBackground,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        localizations.signUp,
                        style: theme.subtitle1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
