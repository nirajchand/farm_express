
import 'package:equatable/equatable.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';

enum GetAllProductStateStatus { loading, success, failure }

class GetAllProductState extends Equatable {
  final GetAllProductStateStatus status;
  final List<ProductEntities>? products;
  final String? errorMessage;

  const GetAllProductState({
    this.status = GetAllProductStateStatus.loading,
    this.products,
    this.errorMessage,
  });

  GetAllProductState copyWith({
    GetAllProductStateStatus? status,
    List<ProductEntities>? products,
    String? errorMessage,
  }) {
    return GetAllProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}