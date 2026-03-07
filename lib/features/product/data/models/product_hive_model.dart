import 'package:farm_express/core/constants/hive_table_constant.dart';
import 'package:farm_express/features/product/domain/entities/product_entities.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'product_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.productTypeId)
class ProductHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? farmerId;

  @HiveField(2)
  final String? productName;

  @HiveField(3)
  final double? price;

  @HiveField(4)
  final String? unitType;

  @HiveField(5)
  final String? status;

  @HiveField(6)
  final double? quantity;

  @HiveField(7)
  final String? description;

  @HiveField(8)
  final String? productImage;

  ProductHiveModel({
    String? id,
    this.farmerId,
    this.productName,
    this.price,
    this.unitType,
    this.status,
    this.quantity,
    this.description,
    this.productImage,
  }) : id = id ?? Uuid().v4();

  // From entity
  factory ProductHiveModel.fromEntity(ProductEntities entity) {
    return ProductHiveModel(
      id: entity.id,
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

  // To entity
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
