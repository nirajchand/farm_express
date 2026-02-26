import 'package:farm_express/features/cart/domain/entities/cretate_cart_entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartCreateModel {
  final String? productId;
  final int? quantity;

  const CartCreateModel({this.productId, this.quantity});

  factory CartCreateModel.fromJson(Map<String, dynamic> json) =>
      _$CartCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartCreateModelToJson(this);

  factory CartCreateModel.fromEntity(AddCartEntity entity) {
    return CartCreateModel(
      productId: entity.productId,
      quantity: entity.quantity,
    );
  }

   toEntity() {
    return AddCartEntity(
      productId: productId,
      quantity: quantity,
    );
  }
}
