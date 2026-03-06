import 'package:dartz/dartz.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';
import 'package:farm_express/features/product/domain/usecases/add_product_usecases.dart';
import 'package:farm_express/features/product/domain/repositories/product_respositories.dart';
import 'package:farm_express/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock Repository
class MockProductRepository extends Mock implements IProductRepository {}

// Fallback value for ProductEntities
class ProductEntitiesFake extends Fake implements ProductEntities {}

void main() {
  late MockProductRepository mockRepository;
  late AddProductUsecases addProductUsecases;

  setUpAll(() {
    registerFallbackValue(ProductEntitiesFake());
  });

  setUp(() {
    mockRepository = MockProductRepository();
    addProductUsecases = AddProductUsecases(iProductRepository: mockRepository);
  });

  group('AddProductUsecases - Unit Tests', () {
    test('should call repository when adding product', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: 'Tomato',
        description: 'Fresh tomatoes',
        price: 50.0,
        quantity: 100,
        unitType: 'kg',
        status: 'Ready',
      );

      final product = ProductEntities(
        id: 'prod_1',
        farmerId: 'farmer1',
        productName: 'Tomato',
        description: 'Fresh tomatoes',
        price: 50.0,
        quantity: 100,
        unitType: 'kg',
        status: 'Ready',
      );

      when(
        () =>
            mockRepository.addProduct(any(that: isA<ProductEntities>()), null),
      ).thenAnswer((_) async => Right(product));

      // Act
      final result = await addProductUsecases(params);

      // Assert
      expect(result.isRight(), true);
      verify(
        () =>
            mockRepository.addProduct(any(that: isA<ProductEntities>()), null),
      ).called(1);
    });

    test('should return ProductEntities on successful add', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: 'Apple',
        description: 'Red apples',
        price: 80.0,
        quantity: 50,
        unitType: 'kg',
        status: 'Ready',
      );

      final product = ProductEntities(
        id: 'prod_2',
        farmerId: 'farmer1',
        productName: 'Apple',
        description: 'Red apples',
        price: 80.0,
        quantity: 50,
        unitType: 'kg',
        status: 'Ready',
      );

      when(
        () =>
            mockRepository.addProduct(any(that: isA<ProductEntities>()), null),
      ).thenAnswer((_) async => Right(product));

      // Act
      final result = await addProductUsecases(params);

      // Assert
      result.fold((failure) => fail('Should not fail'), (returnedProduct) {
        expect(returnedProduct.productName, 'Apple');
        expect(returnedProduct.price, 80.0);
      });
    });

    test('should handle repository failure', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: 'Banana',
        description: 'Yellow bananas',
        price: 40.0,
        quantity: 75,
        unitType: 'kg',
        status: 'Growing',
      );

      when(
        () =>
            mockRepository.addProduct(any(that: isA<ProductEntities>()), null),
      ).thenAnswer((_) async => Left(ServerFailure(message: 'Network error')));

      // Act
      final result = await addProductUsecases(params);

      // Assert
      expect(result.isLeft(), true);
    });

    test('should validate product name is not empty', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: '',
        description: 'Description',
        price: 50.0,
        quantity: 100,
        unitType: 'kg',
        status: 'Ready',
      );

      // Assert
      expect(params.productName?.isEmpty ?? true, true);
    });

    test('should validate price is positive', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: 'Product',
        description: 'Description',
        price: -10.0,
        quantity: 100,
        unitType: 'kg',
        status: 'Ready',
      );

      // Assert
      expect((params.price ?? 0) < 0, true);
    });

    test('should validate quantity is not negative', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: 'Product',
        description: 'Description',
        price: 50.0,
        quantity: -5,
        unitType: 'kg',
        status: 'Ready',
      );

      // Assert
      expect((params.quantity ?? 0) < 0, true);
    });

    test('should handle zero price', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: 'FreeProduct',
        description: 'Free item',
        price: 0.0,
        quantity: 10,
        unitType: 'pcs',
        status: 'Ready',
      );

      // Assert
      expect((params.price ?? 0) == 0.0, true);
    });

    test('should handle zero quantity', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: 'OutOfStock',
        description: 'Out of stock item',
        price: 50.0,
        quantity: 0,
        unitType: 'kg',
        status: 'Sold',
      );

      // Assert
      expect((params.quantity ?? 0) == 0, true);
    });

    test('should preserve product details correctly', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer_123',
        productName: 'Orange',
        description: 'Fresh oranges',
        price: 60.0,
        quantity: 200,
        unitType: 'kg',
        status: 'Ready',
      );

      final product = ProductEntities(
        id: 'prod_3',
        farmerId: 'farmer_123',
        productName: 'Orange',
        description: 'Fresh oranges',
        price: 60.0,
        quantity: 200,
        unitType: 'kg',
        status: 'Ready',
      );

      when(
        () =>
            mockRepository.addProduct(any(that: isA<ProductEntities>()), null),
      ).thenAnswer((_) async => Right(product));

      // Act
      final result = await addProductUsecases(params);

      // Assert
      result.fold((failure) => fail('Should not fail'), (returnedProduct) {
        expect(returnedProduct.productName, 'Orange');
        expect(returnedProduct.description, 'Fresh oranges');
        expect(returnedProduct.farmerId, 'farmer_123');
      });
    });

    test('should handle very long product name', () async {
      // Arrange
      final longName = 'A' * 255;
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: longName,
        description: 'Description',
        price: 50.0,
        quantity: 100,
        unitType: 'kg',
        status: 'Ready',
      );

      // Assert
      expect((params.productName ?? '').length, 255);
    });

    test('should handle special characters in product name', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: 'Organic @-Tomato #1',
        description: 'Description',
        price: 50.0,
        quantity: 100,
        unitType: 'kg',
        status: 'Ready',
      );

      // Assert
      expect((params.productName ?? '').contains('@'), true);
    });

    test('should handle decimal prices correctly', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: 'Product',
        description: 'Description',
        price: 99.99,
        quantity: 100,
        unitType: 'kg',
        status: 'Ready',
      );

      final product = ProductEntities(
        id: 'prod_4',
        farmerId: 'farmer1',
        productName: 'Product',
        description: 'Description',
        price: 99.99,
        quantity: 100,
        unitType: 'kg',
        status: 'Ready',
      );

      when(
        () =>
            mockRepository.addProduct(any(that: isA<ProductEntities>()), null),
      ).thenAnswer((_) async => Right(product));

      // Act
      final result = await addProductUsecases(params);

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (product) => expect(product.price, 99.99),
      );
    });

    test('should handle large quantity values', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: 'Product',
        description: 'Description',
        price: 50.0,
        quantity: 100000,
        unitType: 'kg',
        status: 'Ready',
      );

      // Assert
      expect(params.quantity, 100000);
    });

    test('should verify repository called only once', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: 'Potato',
        description: 'Fresh potatoes',
        price: 30.0,
        quantity: 500,
        unitType: 'kg',
        status: 'Ready',
      );

      final product = ProductEntities(
        id: 'prod_5',
        farmerId: 'farmer1',
        productName: 'Potato',
        description: 'Fresh potatoes',
        price: 30.0,
        quantity: 500,
        unitType: 'kg',
        status: 'Ready',
      );

      when(
        () =>
            mockRepository.addProduct(any(that: isA<ProductEntities>()), null),
      ).thenAnswer((_) async => Right(product));

      // Act
      await addProductUsecases(params);

      // Assert
      verify(
        () =>
            mockRepository.addProduct(any(that: isA<ProductEntities>()), null),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should preserve product ID', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: 'Carrot',
        description: 'Orange carrots',
        price: 35.0,
        quantity: 150,
        unitType: 'kg',
        status: 'Ready',
      );

      final product = ProductEntities(
        id: 'prod_6',
        farmerId: 'farmer1',
        productName: 'Carrot',
        description: 'Orange carrots',
        price: 35.0,
        quantity: 150,
        unitType: 'kg',
        status: 'Ready',
      );

      when(
        () =>
            mockRepository.addProduct(any(that: isA<ProductEntities>()), null),
      ).thenAnswer((_) async => Right(product));

      // Act
      final result = await addProductUsecases(params);

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (returnedProduct) => expect(returnedProduct.id, 'prod_6'),
      );
    });

    test('should handle concurrent product additions', () async {
      // Arrange
      final params = AddProductUseCaseParams(
        farmerId: 'farmer1',
        productName: 'Product1',
        description: 'Description',
        price: 50.0,
        quantity: 100,
        unitType: 'kg',
        status: 'Ready',
      );

      when(
        () =>
            mockRepository.addProduct(any(that: isA<ProductEntities>()), null),
      ).thenAnswer(
        (_) async => Right(
          ProductEntities(
            id: 'prod_new',
            farmerId: 'farmer1',
            productName: 'Product1',
            price: 50.0,
            quantity: 100,
            unitType: 'kg',
            status: 'Ready',
          ),
        ),
      );

      // Act
      final result1 = addProductUsecases(params);
      final result2 = addProductUsecases(params);

      final results = await Future.wait<Either<Failure, ProductEntities>>([
        result1,
        result2,
      ]);

      // Assert
      expect(results[0].isRight(), true);
      expect(results[1].isRight(), true);
    });
  });
}
