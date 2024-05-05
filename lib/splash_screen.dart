// File: lib/splash_screen.dart
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashScreen({Key? key, required this.onInitializationComplete})
      : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller and set up an opacity animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _opacity = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {}); // Call setState every time the animation value changes
      });

    _animationController.forward(); // Start the animation

    Future.delayed(const Duration(seconds: 5), widget.onInitializationComplete);
  }

  @override
  void dispose() {
    _animationController
        .dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEDEB), // Set the background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _opacity
                  .value, // Use the current value of the opacity animation
              duration:
                  const Duration(seconds: 1), // Duration of the fade effect
              child: Image.asset(
                  'assets/logos/logo.png'), // Ensure your logo is in the assets folder
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
