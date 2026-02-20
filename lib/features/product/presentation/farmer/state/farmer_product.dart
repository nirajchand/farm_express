
import 'package:equatable/equatable.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';

enum FarmerProductStatus {
  initial,
  loading,
  success,
  failure,
}


class FarmerProductState extends Equatable {
  final FarmerProductStatus status;
  final List<ProductEntities> products;
  final String? errorMessage;

  const FarmerProductState({
    this.status = FarmerProductStatus.initial,
    this.products = const [],

    this.errorMessage,
  });

  FarmerProductState copyWith({
    FarmerProductStatus? status,
    List<ProductEntities>? products,
    String? errorMessage,
  }) {
    return FarmerProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [status, products, errorMessage];

}




