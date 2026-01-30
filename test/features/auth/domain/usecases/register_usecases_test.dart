import 'package:dartz/dartz.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:farm_express/features/auth/domain/entities/auth_entity.dart';
import 'package:farm_express/features/auth/domain/repositories/auth_repository.dart';
import 'package:farm_express/features/auth/domain/usecases/register_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const AuthEntity(
        fullName: 'fallback',
        email: 'fallback@email.com',
        userType: 'fallback',
      ),
    );
  });

  const tFullName = 'Test User';
  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tConfirmPassword = 'password123';
  const tUserType = 'consumer';

  group('RegisterUsecase', () {
    test('should return true when registration is successful', () async {
      // Arrange
      when(
        () => mockRepository.registerUser(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(
        const RegisterUsecasesParam(
          fullName: tFullName,
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
          userType: tUserType
        ),
      );

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.registerUser(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass AuthEntity with correct values to repository', () async {
      // Arrange
      AuthEntity? capturedEntity;
      when(() => mockRepository.registerUser(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(const Right(true));
      });

      // Act
      await usecase(
        const RegisterUsecasesParam(
          fullName: tFullName,
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
          userType: tUserType
        ),
      );

      // Assert
      expect(capturedEntity?.fullName, tFullName);
      expect(capturedEntity?.email, tEmail);
      expect(capturedEntity?.password, tPassword);
      expect(capturedEntity?.confirmPassword, tConfirmPassword);
      expect(capturedEntity?.userType, tUserType);
    });

    test('should return failure when registration fails', () async {
      // Arrange
      const failure = ServerFailure(message: 'Email already exists');
      when(
        () => mockRepository.registerUser(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const RegisterUsecasesParam(
          fullName: tFullName,
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
          userType: tUserType
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.registerUser(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.registerUser(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const RegisterUsecasesParam(
          fullName: tFullName,
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
          userType: tUserType
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.registerUser(any())).called(1);
    });
  });

  group('RegisterParams', () {
    test('should have correct props with all values', () {
      // Arrange
      const params = RegisterUsecasesParam(
        fullName: tFullName,
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
        userType: tUserType
      );

      // Assert
      expect(params.props, [
        tFullName,
        tEmail,
        tPassword,
        tConfirmPassword,
        tUserType,
      ]);
    });


    test('two params with same values should be equal', () {
      // Arrange
      const params1 = RegisterUsecasesParam(
        fullName: tFullName,
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
        userType: tUserType
      );
      const params2 = RegisterUsecasesParam(
        fullName: tFullName,
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
        userType: tUserType
      );

      // Assert
      expect(params1, params2);
    });
  });
}
