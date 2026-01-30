import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/auth/domain/entities/auth_entity.dart';
import 'package:farm_express/features/auth/domain/repositories/auth_repository.dart';
import 'package:farm_express/features/auth/domain/usecases/login_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late LoginUsecase loginUsecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUsecase = LoginUsecase(authRepository: mockRepository);
  });

  const tEmail = "test@gmail.com";
  const tPassword = "password123";

  const tUser = AuthEntity(
    fullName: "Test name",
    email: tEmail,
    userType: "consumer",
  );

  group("Login UseCase", () {
    test("Should return AuthEntity when login is successful", () async {
      when(
        () => mockRepository.loginUser(tEmail, tPassword),
      ).thenAnswer((_) async => const Right(tUser));

      final result = await loginUsecase(
        const LoginUsecasesParams(email: tEmail, password: tPassword),
      );

      expect(result, const Right(tUser));
      verify(() => mockRepository.loginUser(tEmail, tPassword));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when login fails', () async {
      // Arrange
      const failure = ServerFailure(message: 'Invalid credentials');
      when(
        () => mockRepository.loginUser(tEmail, tPassword),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await loginUsecase(
        const LoginUsecasesParams(email: tEmail, password: tPassword),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.loginUser(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.loginUser(tEmail, tPassword),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await loginUsecase(
        const LoginUsecasesParams(email: tEmail, password: tPassword),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.loginUser(tEmail, tPassword)).called(1);
    });

    test('should pass correct email and password to repository', () async {
      // Arrange
      when(
        () => mockRepository.loginUser(any(), any()),
      ).thenAnswer((_) async => const Right(tUser));

      // Act
      await loginUsecase(
        const LoginUsecasesParams(email: tEmail, password: tPassword),
      );

      // Assert
      verify(() => mockRepository.loginUser(tEmail, tPassword)).called(1);
    });

    test(
      'should succeed with correct credentials and fail with wrong credentials',
      () async {
        // Arrange
        const wrongEmail = 'wrong@example.com';
        const wrongPassword = 'wrongpassword';
        const failure = ServerFailure(message: 'Invalid credentials');

        // Mock: check credentials using if condition
        when(() => mockRepository.loginUser(any(), any())).thenAnswer((
          invocation,
        ) async {
          final email = invocation.positionalArguments[0] as String;
          final password = invocation.positionalArguments[1] as String;

          // If email and password are correct, return success
          if (email == tEmail && password == tPassword) {
            return const Right(tUser);
          }
          // Otherwise return failure
          return const Left(failure);
        });

        // Act & Assert - Correct credentials should succeed
        final successResult = await loginUsecase(
          const LoginUsecasesParams(email: tEmail, password: tPassword),
        );
        expect(successResult, const Right(tUser));

        // Act & Assert - Wrong email should fail
        final wrongEmailResult = await loginUsecase(
          const LoginUsecasesParams(email: wrongEmail, password: tPassword),
        );
        expect(wrongEmailResult, const Left(failure));

        // Act & Assert - Wrong password should fail
        final wrongPasswordResult = await loginUsecase(
          const LoginUsecasesParams(email: tEmail, password: wrongPassword),
        );
        expect(wrongPasswordResult, const Left(failure));
      },
    );
  });

  group('LoginParams', () {
    test('should have correct props', () {
      // Arrange
      const params = LoginUsecasesParams(email: tEmail, password: tPassword);

      // Assert
      expect(params.props, [tEmail, tPassword]);
    });

    test('two params with same values should be equal', () {
      // Arrange
      const params1 = LoginUsecasesParams(email: tEmail, password: tPassword);
      const params2 = LoginUsecasesParams(email: tEmail, password: tPassword);

      // Assert
      expect(params1, params2);
    });

    test('two params with different values should not be equal', () {
      // Arrange
      const params1 = LoginUsecasesParams(email: tEmail, password: tPassword);
      const params2 = LoginUsecasesParams(
        email: 'other@email.com',
        password: tPassword,
      );

      // Assert
      expect(params1, isNot(params2));
    });
  });
}
