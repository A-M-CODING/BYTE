import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DocumentsPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(AppLocalizations.of(context)!.documentsLabel), // Assuming 'documentsLabel' exists in your localizations
        initiallyExpanded: false,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(AppLocalizations.of(context)!.noDocumentsMessage), // Assuming 'noDocumentsMessage' exists in your localizations
            ),
          ),
        ],
      ),
    );
  }
}
