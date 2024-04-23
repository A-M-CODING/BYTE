import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:byte_app/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:byte_app/data/services/authentication_service.dart';
import 'package:byte_app/features/home/screens/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/localization/locale_provider.dart'; // Make sure to import locale_provider.dart

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ByteApp());
}

class ByteApp extends StatelessWidget {
  const ByteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(),
        ),
        ChangeNotifierProvider(create: (context) => LocaleProvider()), // Add LocaleProvider
      ],
      child: Builder(
        builder: (context) {
          // Get the locale from LocaleProvider
          final provider = Provider.of<LocaleProvider>(context);
          return MaterialApp(
            title: 'BYTE Health & Nutrition',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: provider.locale, // Use the locale from LocaleProvider
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
