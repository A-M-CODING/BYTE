import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/firebase_options.dart'; // Make sure this import is correct
import 'data/services/authentication_service.dart';
import 'features/home/screens/home_page.dart';
import 'features/authentication/screens/login_screen.dart';
import 'features/authentication/screens/signup_screen.dart';
import 'features/alternatives/screens/alt_foods_screen.dart';
import 'features/alternatives/screens/get_prods_vids.dart';
import 'features/alternatives/models/product.dart';
import 'features/authentication/controllers/set_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use the Firebase options
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const ByteApp(),
    ),
  );
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
      ],
      child: MaterialApp(
        title: 'BYTE Health & Nutrition',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          // Remove '/altFoods' from here if you're using onGenerateRoute
          // '/altFoods': (context) => const AltProductListingWidget(),
          '/prodsVids': (context) => GetProdsVidsPage(),
        },
        onGenerateRoute: (settings) {
          // Check if the settings.name matches '/altFoods'
          if (settings.name == '/altFoods') {
            final args = settings.arguments as List<AltProduct>?;
            return MaterialPageRoute(
              builder: (context) => AltProductListingWidget(
                altProducts: args ?? [],
                ytVideos: [], // Add this line to pass an empty list for now
              ),
            );
          }
          // Handle other dynamic routes or return null for the unknown routes
          // ...
        },
      ),
    );
  }
}
