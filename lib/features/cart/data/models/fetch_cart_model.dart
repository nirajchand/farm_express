import 'package:json_annotation/json_annotation.dart';
import 'cart_item_model.dart';
import 'package:farm_express/features/cart/domain/entities/cart_entities.dart';

part 'fetch_cart_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CartFetchModel {
  @JsonKey(name: "_id")
  final String id;
  final String consumerId;
  final List<CartItemModel> items;

  const CartFetchModel({
    required this.id,
    required this.consumerId,
    required this.items,
  });

  factory CartFetchModel.fromJson(Map<String, dynamic> json) =>
      _$CartFetchModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartFetchModelToJson(this);

  CartEntities toEntity() {
    return CartEntities(
      id: id,
      consumerId: consumerId,
      items: items.map((e) => e.toEntity()).toList(),
    );
  }
}