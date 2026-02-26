// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      product: ProductModel.fromJson(json['productId'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'productId': instance.product.toJson(),
      '_id': instance.id,
      'quantity': instance.quantity,
    };
