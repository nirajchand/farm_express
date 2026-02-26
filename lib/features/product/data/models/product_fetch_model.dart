// lib/features/product/data/models/product_fetch_model.dart

import 'package:farm_express/features/product/domain/entities/product_entities.dart';
import 'package:json_annotation/json_annotation.dart';
import 'farmer_model.dart';

part 'product_fetch_model.g.dart';

@JsonSerializable()
class ProductFetchModel {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'farmerId')
  final FarmerModel? farmerId;
  final String? productName;
  final double? price;
  final String? unitType;
  final String? status;
  final double? quantity;
  final String? description;
  @JsonKey(name: 'product_image')
  final String? productImage;

  ProductFetchModel({
    required this.id,
    this.farmerId,
    this.productName,
    this.price,
    this.unitType,
    this.status,
    this.quantity,
    this.description,
    this.productImage,
  });

  factory ProductFetchModel.fromJson(Map<String, dynamic> json) =>
      _$ProductFetchModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFetchModelToJson(this);

  ProductEntities toEntity() {
    return ProductEntities(
      id: id,
      farmer: farmerId?.toEntity(),
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

class Pagination {
  final int page;
  final int size;
  final int total;
  final int totalPages;

  Pagination({
    required this.page,
    required this.size,
    required this.total,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      size: json['size'],
      total: json['total'],
      totalPages: json['totalPages'],
    );
  }
}

class ProductWithPagination {
  final List<ProductFetchModel>? products;
  final Pagination? pagination;

  ProductWithPagination({this.products, this.pagination});
}
