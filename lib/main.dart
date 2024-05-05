import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:byte_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:byte_app/data/services/authentication_service.dart';
import 'package:byte_app/features/home/screens/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:byte_app/localization/locale_provider.dart';
import 'package:byte_app/features/authentication/screens/login_screen.dart';
import 'package:byte_app/features/authentication/screens/signup_screen.dart';
import 'package:byte_app/features/alternatives/screens/alt_foods_screen.dart';
// import 'package:byte_app/features/alternatives/screens/get_prods_vids.dart';
import 'package:byte_app/features/alternatives/models/product.dart';
import 'package:byte_app/features/authentication/controllers/set_provider.dart';
import 'package:byte_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:byte_app/features/community/screens/postdetail_screen.dart';
import 'package:byte_app/features/chatbot/screens/chat.dart';
import 'package:byte_app/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenOnboarding = prefs.getBool('seen') ?? false;

  runApp(ByteApp(hasSeenOnboarding: hasSeenOnboarding));
}

class ByteApp extends StatefulWidget {
  final bool hasSeenOnboarding;
  const ByteApp({Key? key, required this.hasSeenOnboarding}) : super(key: key);

  @override
  _ByteAppState createState() => _ByteAppState();
}

class _ByteAppState extends State<ByteApp> {
  late Stream<User?> authStream;
  bool _isInitializationComplete = false;

  @override
  void initState() {
    super.initState();
    authStream = FirebaseAuth.instance.authStateChanges();
    initDynamicLinks();
    Future.delayed(const Duration(seconds: 3),
        _completeInitialization); // Assuming splash screen duration is 3 seconds.
  }

  void _completeInitialization() {
    setState(() {
      _isInitializationComplete = true;
    });
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      print('onLink: ${dynamicLinkData.link}');
      _handleDeepLink(dynamicLinkData.link);
    }, onError: (error) {
      print('onLink error: $error');
    });

    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      print('getInitialLink: ${initialLink.link}');
      _handleDeepLink(initialLink.link);
    }
  }

  void _handleDeepLink(Uri deepLink) {
    print('Handling deep link: $deepLink');
    final String? postId = deepLink.queryParameters['postId'];
    if (postId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostDetailScreen(postId: postId),
        ),
      );
    } else {
      print('No postId found in deep link');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitializationComplete) {
      return MaterialApp(
        home: SplashScreen(onInitializationComplete: _completeInitialization),
      );
    }
    return StreamBuilder<User?>(
      stream: authStream,
      builder: (context, snapshot) {
        // Check connection state and user login state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: CircularProgressIndicator());
        }
        final isLoggedIn = snapshot.hasData;

        return MultiProvider(
          providers: [
            Provider<AuthenticationService>(
              create: (_) => AuthenticationService(),
            ),
            ChangeNotifierProvider(create: (context) => LocaleProvider()),
            ChangeNotifierProvider(create: (context) => UserProvider()),
          ],
          child: Builder(
            builder: (context) {
              final localeProvider = Provider.of<LocaleProvider>(context);
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
                locale:
                    Provider.of<LocaleProvider>(context, listen: false).locale,
                initialRoute:
                    determineInitialRoute(widget.hasSeenOnboarding, isLoggedIn),
                routes: {
                  '/': (context) => const HomePageWrapper(),
                  '/onboarding': (context) => const OnboardingScreen(),
                  '/Homepage': (context) => HomePage(),
                  '/login': (context) => LoginScreen(),
                  '/signup': (context) => SignupScreen(),
                  '/chatbot': (context) => ChatbotScreen(),
                },
                onGenerateRoute: (settings) {
                  if (settings.name == '/altFoods') {
                    final args = settings.arguments as List<AltProduct>?;
                    return MaterialPageRoute(
                      builder: (context) => AltProductListingWidget(
                        altProducts: args ?? [],
                        ytVideos: [],
                        productsErrorMessage: '',
                        videosErrorMessage:
                            '', // Add this line to pass an empty list for now
                      ),
                    );
                  }
                  // Add other dynamic routing logic from main2.dart if necessary
                  // ...
                  return null; // Return null for unhandled routes
                },
              );
            },
          ),
        );
      },
    );
  }
}

String determineInitialRoute(bool hasSeenOnboarding, bool isLoggedIn) {
  if (!hasSeenOnboarding) {
    return '/onboarding';
  } else {
    return '/Homepage';
  }
}

class HomePageWrapper extends StatefulWidget {
  const HomePageWrapper({Key? key}) : super(key: key);

  @override
  _HomePageWrapperState createState() => _HomePageWrapperState();
}

class _HomePageWrapperState extends State<HomePageWrapper> {
  @override
  void initState() {
    super.initState();
    // Initialize dynamic links here
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      print('onLink: ${dynamicLinkData.link}');
      _handleDeepLink(dynamicLinkData.link);
    }, onError: (error) {
      print('onLink error: $error');
    });

    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      print('getInitialLink: ${initialLink.link}');
      _handleDeepLink(initialLink.link);
    }
  }

  void _handleDeepLink(Uri deepLink) {
    print('Handling deep link: $deepLink');
    final String? postId = deepLink.queryParameters['postId'];
    if (postId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostDetailScreen(postId: postId),
        ),
      );
    } else {
      print('No postId found in deep link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
