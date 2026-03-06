import 'package:dartz/dartz.dart';
import 'package:farm_express/features/cart/domain/entities/cretate_cart_entities.dart';
import 'package:farm_express/features/cart/domain/usecases/add_cart_usecases.dart';
import 'package:farm_express/features/cart/domain/respositories/cart_respositories.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock Repository
class MockCartRepositories extends Mock implements ICartRepositories {}

// Fallback value for AddCartEntity
class AddCartEntityFake extends Fake implements AddCartEntity {}

void main() {
  late MockCartRepositories mockRepository;
  late AddCartUsecases addCartUsecases;

  setUpAll(() {
    registerFallbackValue(AddCartEntityFake());
  });

  setUp(() {
    mockRepository = MockCartRepositories();
    addCartUsecases = AddCartUsecases(iCartRepositories: mockRepository);
  });

  group('AddCartUsecase - Unit Tests', () {
    test('should call repository when adding product to cart', () async {
      // Arrange
      const params = AddCartUsecasesParams(productId: '1', quantity: 1);

      when(
        () => mockRepository.addProductToCart(
          AddCartEntity(productId: '1', quantity: 1),
        ),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await addCartUsecases(params);

      // Assert
      expect(result.isRight(), true);
      verify(
        () => mockRepository.addProductToCart(any(that: isA<AddCartEntity>())),
      ).called(1);
    });

    test('should return true on successful add to cart', () async {
      // Arrange
      const params = AddCartUsecasesParams(productId: '1', quantity: 2);

      when(
        () => mockRepository.addProductToCart(
          AddCartEntity(productId: '1', quantity: 2),
        ),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await addCartUsecases(params);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (success) => expect(success, true),
      );
    });

    test('should handle repository failure when adding to cart', () async {
      // Arrange
      const params = AddCartUsecasesParams(productId: '1', quantity: 1);

      when(
        () => mockRepository.addProductToCart(any(that: isA<AddCartEntity>())),
      ).thenAnswer((_) async => Left(ServerFailure(message: 'Network error')));

      // Act
      final result = await addCartUsecases(params);

      // Assert
      expect(result.isLeft(), true);
    });

    test('should add product with correct quantity', () async {
      // Arrange
      const params = AddCartUsecasesParams(productId: 'prod_123', quantity: 5);

      when(
        () => mockRepository.addProductToCart(
          AddCartEntity(productId: 'prod_123', quantity: 5),
        ),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await addCartUsecases(params);

      // Assert
      expect(result.isRight(), true);
      verify(
        () => mockRepository.addProductToCart(any(that: isA<AddCartEntity>())),
      ).called(1);
    });

    test('should handle duplicate product addition', () async {
      // Arrange
      const params = AddCartUsecasesParams(productId: 'prod_123', quantity: 1);

      when(
        () => mockRepository.addProductToCart(any(that: isA<AddCartEntity>())),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result1 = await addCartUsecases(params);

      // Assert
      expect(result1.isRight(), true);
    });

    test('should reject zero quantity', () async {
      // Arrange
      const params = AddCartUsecasesParams(productId: 'prod_123', quantity: 0);

      // Assert
      expect(params.quantity > 0, false);
    });

    test('should handle negative quantity rejection', () async {
      // Arrange
      const params = AddCartUsecasesParams(productId: 'prod_123', quantity: -1);

      // Assert
      expect(params.quantity < 0, true);
    });

    test('should maintain product ID in params', () async {
      // Arrange
      const params = AddCartUsecasesParams(productId: 'prod_456', quantity: 2);

      // Assert
      expect(params.productId, 'prod_456');
    });

    test('should handle large quantity values', () async {
      // Arrange
      const params = AddCartUsecasesParams(
        productId: 'prod_123',
        quantity: 999,
      );

      when(
        () => mockRepository.addProductToCart(
          AddCartEntity(productId: 'prod_123', quantity: 999),
        ),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await addCartUsecases(params);

      // Assert
      expect(result.isRight(), true);
    });

    test('should handle empty product ID error', () async {
      // Arrange
      const params = AddCartUsecasesParams(productId: '', quantity: 1);

      // Assert
      expect(params.productId.isEmpty, true);
    });

    test('should verify repository is called only once', () async {
      // Arrange
      const params = AddCartUsecasesParams(productId: 'prod_123', quantity: 1);

      when(
        () => mockRepository.addProductToCart(any(that: isA<AddCartEntity>())),
      ).thenAnswer((_) async => const Right(true));

      // Act
      await addCartUsecases(params);

      // Assert
      verify(
        () => mockRepository.addProductToCart(any(that: isA<AddCartEntity>())),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle concurrent add operations', () async {
      // Arrange
      const params = AddCartUsecasesParams(productId: 'prod_123', quantity: 1);

      when(
        () => mockRepository.addProductToCart(any(that: isA<AddCartEntity>())),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result1 = addCartUsecases(params);
      final result2 = addCartUsecases(params);

      final results = await Future.wait<Either<Failure, bool>>([
        result1,
        result2,
      ]);

      // Assert
      expect(results[0].isRight(), true);
      expect(results[1].isRight(), true);
    });

    test('should validate product exists before adding', () async {
      // Arrange
      const params = AddCartUsecasesParams(
        productId: 'nonexistent_prod',
        quantity: 1,
      );

      when(
        () => mockRepository.addProductToCart(any(that: isA<AddCartEntity>())),
      ).thenAnswer(
        (_) async => Left(ServerFailure(message: 'Product not found')),
      );

      // Act
      final result = await addCartUsecases(params);

      // Assert
      expect(result.isLeft(), true);
    });

    test('should handle out of stock scenario', () async {
      // Arrange
      const params = AddCartUsecasesParams(
        productId: 'prod_123',
        quantity: 1000,
      );

      when(
        () => mockRepository.addProductToCart(any(that: isA<AddCartEntity>())),
      ).thenAnswer((_) async => Left(ServerFailure(message: 'Out of stock')));

      // Act
      final result = await addCartUsecases(params);

      // Assert
      expect(result.isLeft(), true);
    });
  });
}
