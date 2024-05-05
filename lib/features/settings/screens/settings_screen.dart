import 'package:byte_app/features/settings/model/changepassword_panel.dart';
import 'package:flutter/material.dart';
import 'package:byte_app/features/settings/model/about_us_form.dart';
import 'package:byte_app/features/settings/model/medical_information_form.dart';
import 'package:byte_app/features/settings/model/language_panel.dart';
import 'package:byte_app/features/settings/model/documents.dart';
import 'package:byte_app/features/settings/model/logout_panel.dart';
import 'package:byte_app/features/settings/model/feedback_panel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionHeader(
                AppLocalizations.of(context)!.personalization, context),
            AboutUsForm(),
            SizedBox(height: 20),
            MedicalInformationForm(),
            SizedBox(height: 20),
            LanguagePanel(),
            SizedBox(height: 20),
            DocumentsPanel(),
            SizedBox(height: 20),
            _buildSectionHeader(AppLocalizations.of(context)!.system, context),
            LogoutPanel(),
            FeedbackPanel(),
            ChangePasswordPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    final appTheme = AppTheme.of(
        context); // Assuming AppTheme is accessible through context

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: appTheme.typography.subtitle1.copyWith(
          fontFamily: appTheme.typography.subtitle1Family,
          // You can adjust the text style properties as needed
        ),
      ),
    );
  }
}