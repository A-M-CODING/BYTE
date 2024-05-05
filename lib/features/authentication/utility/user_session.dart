import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const _isLoggedInKey = 'isLoggedIn';
  static const _isAdminKey = 'isAdmin';
  static const _hasSeenOnboardingKey = 'seen';

  // Function to save login status
  static Future<void> saveUserLoggedIn(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  // Function to save admin status
  static Future<void> saveIsAdmin(bool isAdmin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAdminKey, isAdmin);
  }

  // Function to save onboarding status
  static Future<void> saveHasSeenOnboarding(bool hasSeenOnboarding) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, hasSeenOnboarding);
  }

  // Function to retrieve login status
  static Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Function to retrieve admin status
  static Future<bool> isAdmin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAdminKey) ?? false;
  }

  // Function to retrieve onboarding status
  static Future<bool> hasSeenOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  // Function to clear login status, used during logout
  static Future<void> clearUserSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_isAdminKey);
    await prefs.remove(_hasSeenOnboardingKey);
  }
}
