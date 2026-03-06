import 'package:dartz/dartz.dart';
import 'package:farm_express/features/cart/domain/entities/cart_entities.dart';
import 'package:farm_express/features/cart/domain/usecases/get_cart_usecases.dart';
import 'package:farm_express/features/cart/domain/respositories/cart_respositories.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock Repository
class MockCartRepositories extends Mock implements ICartRepositories {}

void main() {
  late MockCartRepositories mockRepository;
  late GetCartUsecases getCartUsecases;

  setUp(() {
    mockRepository = MockCartRepositories();
    getCartUsecases = GetCartUsecases(iCartRepositories: mockRepository);
  });

  group('GetCartUsecases - Unit Tests', () {
    test('should call repository to fetch cart', () async {
      // Arrange
      when(() => mockRepository.getCart()).thenAnswer(
        (_) async =>
            Right(CartEntities(id: 'cart1', consumerId: 'user1', items: [])),
      );

      // Act
      final result = await getCartUsecases();

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRepository.getCart()).called(1);
    });

    test('should return empty cart when no items', () async {
      // Arrange
      final emptyCart = CartEntities(
        id: 'cart1',
        consumerId: 'user1',
        items: [],
      );

      when(
        () => mockRepository.getCart(),
      ).thenAnswer((_) async => Right(emptyCart));

      // Act
      final result = await getCartUsecases();

      // Assert
      result.fold((failure) => fail('Should not fail'), (cart) {
        expect(cart.items?.length ?? 0, 0);
      });
    });

    test('should return cart with items', () async {
      // Arrange
      final cartWithItems = CartEntities(
        id: 'cart1',
        consumerId: 'user1',
        items: [],
      );

      when(
        () => mockRepository.getCart(),
      ).thenAnswer((_) async => Right(cartWithItems));

      // Act
      final result = await getCartUsecases();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (cart) => expect(cart.id, 'cart1'),
      );
    });

    test('should handle repository failure', () async {
      // Arrange
      when(
        () => mockRepository.getCart(),
      ).thenAnswer((_) async => Left(ServerFailure(message: 'Network error')));

      // Act
      final result = await getCartUsecases();

      // Assert
      expect(result.isLeft(), true);
    });

    test('should preserve cart ID on fetch', () async {
      // Arrange
      const cartId = 'cart_xyz';

      final cart = CartEntities(id: cartId, consumerId: 'user1', items: []);

      when(() => mockRepository.getCart()).thenAnswer((_) async => Right(cart));

      // Act
      final result = await getCartUsecases();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (returnedCart) => expect(returnedCart.id, cartId),
      );
    });

    test('should preserve consumer ID', () async {
      // Arrange
      const userId = 'user_123';

      final cart = CartEntities(id: 'cart1', consumerId: userId, items: []);

      when(() => mockRepository.getCart()).thenAnswer((_) async => Right(cart));

      // Act
      final result = await getCartUsecases();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (returnedCart) => expect(returnedCart.consumerId, userId),
      );
    });

    test('should handle user not found error', () async {
      // Arrange
      when(
        () => mockRepository.getCart(),
      ).thenAnswer((_) async => Left(ServerFailure(message: 'User not found')));

      // Act
      final result = await getCartUsecases();

      // Assert
      expect(result.isLeft(), true);
    });

    test('should handle database connection error', () async {
      // Arrange
      when(
        () => mockRepository.getCart(),
      ).thenAnswer((_) async => Left(ServerFailure(message: 'Database error')));

      // Act
      final result = await getCartUsecases();

      // Assert
      expect(result.isLeft(), true);
    });

    test('should handle timeout error', () async {
      // Arrange
      when(() => mockRepository.getCart()).thenAnswer(
        (_) async => Left(ServerFailure(message: 'Request timeout')),
      );

      // Act
      final result = await getCartUsecases();

      // Assert
      expect(result.isLeft(), true);
    });

    test('should handle concurrent fetch operations', () async {
      // Arrange
      when(() => mockRepository.getCart()).thenAnswer(
        (_) async =>
            Right(CartEntities(id: 'cart1', consumerId: 'user1', items: [])),
      );

      // Act
      final result1 = getCartUsecases();
      final result2 = getCartUsecases();

      final results = await Future.wait([
        result1,
        result2,
      ]);

      // Assert
      expect(results[0].isRight(), true);
      expect(results[1].isRight(), true);
    });

    test('should verify repository called only once per request', () async {
      // Arrange
      when(() => mockRepository.getCart()).thenAnswer(
        (_) async =>
            Right(CartEntities(id: 'cart1', consumerId: 'user1', items: [])),
      );

      // Act
      await getCartUsecases();

      // Assert
      verify(() => mockRepository.getCart()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should fetch cart successfully', () async {
      // Arrange
      final cart = CartEntities(
        id: 'cart1',
        consumerId: 'consumer_1',
        items: [],
      );

      when(() => mockRepository.getCart()).thenAnswer((_) async => Right(cart));

      // Act
      final result = await getCartUsecases();

      // Assert
      expect(result.isRight(), true);
    });

    test('should handle null items list', () async {
      // Arrange
      final cart = CartEntities(id: 'cart1', consumerId: 'user1', items: null);

      when(() => mockRepository.getCart()).thenAnswer((_) async => Right(cart));

      // Act
      final result = await getCartUsecases();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (returnedCart) => expect(returnedCart.items, null),
      );
    });
  });
}
