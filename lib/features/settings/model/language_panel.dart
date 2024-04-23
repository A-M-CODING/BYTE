import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/localization/locale_provider.dart'; // Ensure this is the correct path for your LocaleProvider

class LanguagePanel extends StatelessWidget {
  const LanguagePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Card(
      child: ExpansionTile(
        title: Text(AppLocalizations.of(context)!.languageLabel),  // Make sure 'languageLabel' is defined in your localizations
        initiallyExpanded: false,
        children: <Widget>[
          ListTile(
            title: Text('English'),
            onTap: () {
              localeProvider.setLocale(Locale('en'));
            },
            selected: Localizations.localeOf(context).languageCode == 'en',
          ),
          ListTile(
            title: Text('اردو'),
            onTap: () {
              localeProvider.setLocale(Locale('ur'));
            },
            selected: Localizations.localeOf(context).languageCode == 'ur',
          ),
        ],
      ),
    );
  }
}
