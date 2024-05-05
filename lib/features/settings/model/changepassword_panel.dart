import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/features/authentication/screens/change_password_screen.dart'; // Make sure this import is correct
import 'package:byte_app/app_theme.dart';

class ChangePasswordPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context); // Get the app theme

    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.changePassword,
        style: appTheme.bodyText1, // Use bodyText1 style from the app theme
      ),
      leading: Icon(Icons.lock_outline,
          color: appTheme.primaryColor), // Set icon color to primary color
      onTap: () {
        // Navigate to the ChangePasswordScreen when tapped
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
        );
      },
    );
  }
}
