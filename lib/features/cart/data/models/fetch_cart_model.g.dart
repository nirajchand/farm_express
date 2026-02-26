// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartFetchModel _$CartFetchModelFromJson(Map<String, dynamic> json) =>
    CartFetchModel(
      id: json['_id'] as String,
      consumerId: json['consumerId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CartFetchModelToJson(CartFetchModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'consumerId': instance.consumerId,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
