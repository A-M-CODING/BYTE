import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:byte_app/features/home/screens/home_page.dart'; // Correct this path as necessary

void main() {
  testWidgets('HomePage has a title and buttons', (WidgetTester tester) async {
    // Build the HomePage widget.
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Verify if the "Welcome" text is found within the HomePage.
    expect(find.text('Welcome'), findsOneWidget);

    // Verify that the "Login" and "Sign up" buttons are found.
    expect(find.widgetWithText(MaterialButton, 'Login'), findsOneWidget);
    expect(find.widgetWithText(MaterialButton, 'Sign up'), findsOneWidget);

    // You can also tap the buttons and check navigation if you've set up routes.
    // await tester.tap(find.widgetWithText(MaterialButton, 'Login'));
    // await tester.pumpAndSettle();
    // expect(find.byType(LoginScreen), findsOneWidget);

    // Similar test for "Sign up" button
    // await tester.tap(find.widgetWithText(MaterialButton, 'Sign up'));
    // await tester.pumpAndSettle();
    // expect(find.byType(SignupScreen), findsOneWidget);
  });
}
