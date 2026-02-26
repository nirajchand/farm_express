import 'package:equatable/equatable.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';

class CartItemEntity extends Equatable {
  final String? id;
  final ProductEntities? product;
  final double? quantity;

  const CartItemEntity({
    this.product,
    this.quantity, this.id,
  });

  @override
  List<Object?> get props => [id,product, quantity];
}