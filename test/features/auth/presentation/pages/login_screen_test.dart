
import 'package:farm_express/features/auth/domain/usecases/login_usecases.dart';
import 'package:farm_express/features/auth/domain/usecases/logout_usecase.dart';
import 'package:farm_express/features/auth/domain/usecases/register_usecases.dart';
import 'package:farm_express/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock NavigatorObserver to track navigation
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  

  setUpAll(() {
    registerFallbackValue(
      const RegisterUsecasesParam(
        fullName: 'fallback',
        email: 'fallback@email.com',
        password: 'fallback',
        confirmPassword: 'fallback',
        userType: "consumer"
      ),
    );
    registerFallbackValue(
      const LoginUsecasesParams(email: 'fallback@email.com', password: 'fallback'),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecasesProvider.overrideWithValue(mockLoginUsecase),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
      ],
      child: const MaterialApp(home: LoginScreen()),
    );
  }

  group('LoginPage UI Elements', () {
    testWidgets('should display welcome text', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text("Welcome Back !"), findsOneWidget);
      expect(find.text("Sign in to your account"), findsOneWidget);
    });

    testWidgets('should display login button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display two text form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('should display email icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

  });

  group('LoginPage Form Validation', () {
    testWidgets('should show error for empty email', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Please ent53er your email'), findsOneWidget);
    });
  });


}