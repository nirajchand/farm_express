

import 'package:farm_express/features/product/domain/entities/product_entities.dart';
import 'package:json_annotation/json_annotation.dart';
part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  @JsonKey(name: '_id')
  final String id;
  final String farmerId;
  final String productName;
  final double price;
  final String unitType;
  final String status;
  final double quantity;
  final String description;
  @JsonKey(name: "product_image")
  final String productImage;
  ProductModel({
    required this.id,
    required this.farmerId,
    required this.productName,
    required this.price,
    required this.unitType,
    required this.status,
    required this.quantity,
    required this.description,
    required this.productImage,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductEntities toEntity() {
    return ProductEntities(
      id: id,
      farmerId: farmerId,
      productName: productName,
      price: price,
      unitType: unitType,
      status: status,
      quantity: quantity,
      description: description,
      productImage: productImage,
    );
  }
}