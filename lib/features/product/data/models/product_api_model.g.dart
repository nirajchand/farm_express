// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductApiModel _$ProductApiModelFromJson(Map<String, dynamic> json) =>
    ProductApiModel(
      id: json['_id'] as String?,
      farmerId: json['farmerId'] as String?,
      productName: json['productName'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      unitType: json['unitType'] as String?,
      status: json['status'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      description: json['description'] as String?,
      productImage: json['product_image'] as String?,
    );

Map<String, dynamic> _$ProductApiModelToJson(ProductApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'farmerId': instance.farmerId,
      'productName': instance.productName,
      'price': instance.price,
      'unitType': instance.unitType,
      'status': instance.status,
      'quantity': instance.quantity,
      'description': instance.description,
      'product_image': instance.productImage,
    };
