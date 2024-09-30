// test/login_screen_test.dart

import 'package:exercisecoach/screens/login_screen.dart';
import 'package:exercisecoach/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:exercisecoach/widgets/customized_button.dart';
import 'package:exercisecoach/widgets/customized_textfield.dart';
import 'login_screen_test.mocks.dart';

@GenerateMocks([
  FirebaseAuthService,
  FirebaseAuth,
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  UserCredential,
  User,
  AuthCredential,
])
void main() {
  late MockFirebaseAuthService mockFirebaseAuthService;

  setUp(() {
    mockFirebaseAuthService = MockFirebaseAuthService();
  });

  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Provider<FirebaseAuthService>(
          create: (_) => mockFirebaseAuthService,
          child: const LoginScreen(),
        ),
      ),
    );
  }

  testWidgets('displays login screen', (WidgetTester tester) async {
    await pumpLoginScreen(tester);

    expect(find.text('Welcome Back! Glad \nto see you again'), findsOneWidget);
    expect(find.byType(CustomizedTextfield), findsNWidgets(2));
    expect(find.byType(CustomizedButton), findsOneWidget);
  });

  testWidgets('successful email and password login', (WidgetTester tester) async {
    when(mockFirebaseAuthService.login(any, any)).thenAnswer((_) async {});

    await pumpLoginScreen(tester);

    await tester.enterText(find.byType(CustomizedTextfield).first, 'test@example.com');
    await tester.enterText(find.byType(CustomizedTextfield).last, 'password123');

    await tester.tap(find.byType(CustomizedButton));
    await tester.pumpAndSettle();

    verify(mockFirebaseAuthService.login('test@example.com', 'password123')).called(1);
  });

  testWidgets('failed email and password login shows error dialog', (WidgetTester tester) async {
    when(mockFirebaseAuthService.login(any, any)).thenThrow(FirebaseAuthException(
      code: 'user-not-found',
      message: 'User not found',
    ));

    await pumpLoginScreen(tester);

    await tester.enterText(find.byType(CustomizedTextfield).first, 'test@example.com');
    await tester.enterText(find.byType(CustomizedTextfield).last, 'wrongpassword');

    await tester.tap(find.byType(CustomizedButton));
    await tester.pumpAndSettle();

    expect(find.text('Invalid Username or password. Please register again or make sure that username and password is correct'), findsOneWidget);
  });

  testWidgets('successful Google login', (WidgetTester tester) async {
    when(mockFirebaseAuthService.logininwithgoogle()).thenAnswer((_) async {});

    await pumpLoginScreen(tester);

    await tester.tap(find.byIcon(FontAwesomeIcons.google));
    await tester.pumpAndSettle();

    verify(mockFirebaseAuthService.logininwithgoogle()).called(1);
  });
}
