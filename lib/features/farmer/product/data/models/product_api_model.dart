import 'package:farm_express/features/farmer/product/domain/entities/product_entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_api_model.g.dart';

@JsonSerializable()
class ProductApiModel {
  final String? farmerId;
  final String? productName;
  final double? price;
  final String? unitType;
  final String? status;
  final double? quantity;
  final String? description;
  @JsonKey(name: "product_image")
  final String? productImage;

  const ProductApiModel({
    this.farmerId,
    this.productName,
    this.price,
    this.unitType,
    this.status,
    this.quantity,
    this.description,
    this.productImage,
  });


  factory ProductApiModel.fromJson(Map<String, dynamic> map) => _$ProductApiModelFromJson(map);
  Map<String, dynamic> toJson() => _$ProductApiModelToJson(this);


  factory ProductApiModel.fromEntity(ProductEntities entity) {
    return ProductApiModel(
      farmerId: entity.farmerId,
      productName: entity.productName,
      price: entity.price,
      unitType: entity.unitType,
      status: entity.status,
      quantity: entity.quantity,
      description: entity.description,
      productImage: entity.productImage,
    );
  }


  ProductEntities toEntity() {
    return ProductEntities(
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
