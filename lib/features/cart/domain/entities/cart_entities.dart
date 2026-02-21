

import 'package:equatable/equatable.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';

class CartEntities extends Equatable {
  final String? productId;
  final int? quantity;
  final List<ProductEntities>? items;
  
  const CartEntities({
    this.productId,
    this.quantity,
    this.items,
  });
  @override
  List<Object?> get props => [productId, quantity, items];
}