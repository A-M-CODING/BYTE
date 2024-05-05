import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/data/services/authentication_service.dart'; // Make sure the path is correct
import 'package:provider/provider.dart';
import 'package:byte_app/features/home/screens/home_page.dart'; // Make sure the path is correct to your HomePage
import 'package:byte_app/app_theme.dart';
class LogoutPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationService>(context, listen: false);
    final appTheme = AppTheme.of(context); // Get the app theme

    return ListTile(
      title: Text(
        AppLocalizations.of(context)!.logout,
        style: appTheme.bodyText1, // Use bodyText1 style from the app theme
      ),
      leading: Icon(Icons.exit_to_app,color: appTheme.primaryColor),
      onTap: () async {
        await authService.signOut();

        // Navigate to the home page after signing out
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()), // Assuming HomePage is your home page after logout
              (Route<dynamic> route) => false,
        );
      },
    );
  }
}

