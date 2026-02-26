import 'package:equatable/equatable.dart';
import 'package:farm_express/features/cart/domain/entities/cart_item_entities.dart';

class CartEntities extends Equatable {
  final String? id;
  final String? consumerId;
  final List<CartItemEntity>? items;

  const CartEntities({
    this.id,
    this.consumerId,
    this.items,
  });

  @override
  List<Object?> get props => [id, consumerId, items];
}