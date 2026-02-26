import 'package:equatable/equatable.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';

enum GetAllProductStateStatus { loading, success, failure }

class GetAllProductState extends Equatable {
  final GetAllProductStateStatus status;
  final List<ProductEntities>? products;
  final Pagination? pagination; 
  final String? errorMessage;

  const GetAllProductState({
    this.status = GetAllProductStateStatus.loading,
    this.products,
    this.pagination,
    this.errorMessage,
  });

  GetAllProductState copyWith({
    GetAllProductStateStatus? status,
    List<ProductEntities>? products,
    Pagination? pagination,
    String? errorMessage,
  }) {
    return GetAllProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, pagination, errorMessage];
}
