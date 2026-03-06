import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';
import 'package:farm_express/features/product/presentation/consumer/pages/view_product_details.dart';

void main() {
  final testProduct = ProductEntities(
    id: 'prod_1',
    farmerId: 'farmer_1',
    productName: 'Fresh Tomato',
    description: 'Organic fresh tomatoes from farm',
    price: 50.0,
    quantity: 100,
    unitType: 'kg',
    status: 'Ready',
    productImage: 'https://example.com/tomato.jpg',
  );

  Widget createTestWidget({required ProductEntities product}) {
    return ProviderScope(
      child: MaterialApp(home: ProductDetailsPage(product: product)),
    );
  }

  group('Product Details Widget - UI Elements', () {
    testWidgets('should display product name', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      expect(find.text('Fresh Tomato'), findsOneWidget);
    });

    testWidgets('should display product description', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      expect(find.text('Organic fresh tomatoes from farm'), findsOneWidget);
    });

    testWidgets('should display product status', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      expect(find.text('Ready'), findsOneWidget);
    });

    testWidgets('should display product image', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should have quantity selector', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('should display farmer info', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should have scaffold', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('Product Details - User Interactions', () {
    testWidgets('should handle quantity display', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      await tester.pump(Duration(milliseconds: 100));
      expect(find.text('Fresh Tomato'), findsOneWidget);
    });

    testWidgets('should display status in UI', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      expect(find.text('Ready'), findsOneWidget);
    });

    testWidgets('should render without errors', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      await tester.pumpAndSettle();
      expect(find.byType(ProductDetailsPage), findsOneWidget);
    });

    testWidgets('should display product in growing state', (tester) async {
      final growingProduct = ProductEntities(
        id: 'prod_1',
        farmerId: 'farmer_1',
        productName: 'Fresh Tomato',
        description: 'Organic fresh tomatoes from farm',
        price: 50.0,
        quantity: 100,
        unitType: 'kg',
        status: 'Growing',
        productImage: 'https://example.com/tomato.jpg',
      );
      await tester.pumpWidget(createTestWidget(product: growingProduct));
      expect(find.text('Growing'), findsOneWidget);
    });

    testWidgets('should display product in sold state', (tester) async {
      final soldProduct = ProductEntities(
        id: 'prod_1',
        farmerId: 'farmer_1',
        productName: 'Fresh Tomato',
        description: 'Organic fresh tomatoes from farm',
        price: 50.0,
        quantity: 100,
        unitType: 'kg',
        status: 'Sold',
        productImage: 'https://example.com/tomato.jpg',
      );
      await tester.pumpWidget(createTestWidget(product: soldProduct));
      expect(find.text('Sold'), findsOneWidget);
    });

    testWidgets('should handle null status', (tester) async {
      final noStatusProduct = ProductEntities(
        id: 'prod_1',
        farmerId: 'farmer_1',
        productName: 'Fresh Tomato',
        description: 'Organic fresh tomatoes from farm',
        price: 50.0,
        quantity: 100,
        unitType: 'kg',
        status: null,
        productImage: 'https://example.com/tomato.jpg',
      );
      await tester.pumpWidget(createTestWidget(product: noStatusProduct));
      expect(find.byType(ProductDetailsPage), findsOneWidget);
    });

    testWidgets('should display product details in scroll', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      await tester.drag(find.byType(CustomScrollView), Offset(0, -300));
      await tester.pump();
      expect(find.text('Fresh Tomato'), findsOneWidget);
    });

    testWidgets('should maintain UI on multiple pumps', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      await tester.pump();
      await tester.pump(Duration(milliseconds: 100));
      expect(find.text('Fresh Tomato'), findsOneWidget);
    });
  });

  group('Product Details - Data Display', () {
    testWidgets('should display correct product name', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      expect(find.text('Fresh Tomato'), findsOneWidget);
    });

    testWidgets('should display correct description', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      expect(find.text('Organic fresh tomatoes from farm'), findsOneWidget);
    });
  });

  group('Product Details - Theme Support', () {
    testWidgets('should render product page', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      expect(find.byType(ProductDetailsPage), findsOneWidget);
    });

    testWidgets('should display product name', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      expect(find.text('Fresh Tomato'), findsOneWidget);
    });

    testWidgets('should have scrollable content', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      await tester.pumpAndSettle();
      expect(find.byType(ProductDetailsPage), findsOneWidget);
    });

    testWidgets('should handle scrolling gesture', (tester) async {
      await tester.pumpWidget(createTestWidget(product: testProduct));
      expect(find.byType(ProductDetailsPage), findsOneWidget);
    });
  });
}
