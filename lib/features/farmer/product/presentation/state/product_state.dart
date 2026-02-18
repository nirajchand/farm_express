

import 'package:equatable/equatable.dart';
import 'package:farm_express/features/farmer/product/domain/entities/product_entities.dart';

enum ProductStateStatus { initial, loading, success, failure }


class ProductState extends Equatable {
  final ProductStateStatus status;
  final ProductEntities? product;
  final String? errorMessage;

  const ProductState({
    this.status = ProductStateStatus.initial,
    this.errorMessage, this.product,
  });

  ProductState copyWith({
    ProductStateStatus? status,
    String? errorMessage,
    ProductEntities? product,
  }) {
    return ProductState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      product: product ?? this.product,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, product];
}