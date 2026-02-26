import 'package:json_annotation/json_annotation.dart';
import 'package:farm_express/features/cart/data/models/product_model.dart';
import 'package:farm_express/features/cart/domain/entities/cart_item_entities.dart';

part 'cart_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CartItemModel {
  @JsonKey(name: "productId")
  final ProductModel product;
  @JsonKey(name: "_id")
  final String? id;
  final double quantity;

  const CartItemModel({
    required this.product,
    required this.quantity, this.id,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItemEntity toEntity() {
    return CartItemEntity(
      product: product.toEntity(),
      quantity: quantity,
      id: id,
    );
  }
}