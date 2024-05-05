import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/localization/locale_provider.dart'; // Ensure this is the correct path for your LocaleProvider
import 'package:byte_app/app_theme.dart';
class LanguagePanel extends StatelessWidget {
  const LanguagePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final appTheme = AppTheme.of(context);

    // A list of languages with their respective locale codes.
    List<Map<String, String>> languages = [
      {'name': 'English', 'code': 'en'},
      {'name': 'اردو', 'code': 'ur'},
      {'name': 'Deutsch', 'code': 'de'},
      {'name': 'العربية', 'code': 'ar'},
      {'name': '한국어', 'code': 'ko'},
      {'name': 'हिंदी', 'code': 'hi'},
      {'name': '中文', 'code': 'zh'}
    ];

    return Card(
      color: appTheme.widgetBackground,
      elevation: 0,
      child: ExpansionTile(
        title: Text(
          AppLocalizations.of(context)!.languageLabel,
          style: appTheme.typography.subtitle1,
        ),
        initiallyExpanded: false,
        children: languages.map((language) {
          return ListTile(
            title: Text(
              language['name']!,
              style: appTheme.bodyText2.copyWith(
                color: appTheme.bodyText1.color, // Set the text color
              ),
            ),
            onTap: () {
              localeProvider.setLocale(Locale(language['code']!));
              Navigator.pop(
                  context); // Optionally close the drawer or settings menu
            },
            selected: Localizations
                .localeOf(context)
                .languageCode == language['code'],
          );
        }).toList(),
      ),
    );
  }
}