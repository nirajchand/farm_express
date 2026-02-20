import 'package:equatable/equatable.dart';
import 'package:farm_express/features/product/domain/entities/farmer_entity.dart';

class ProductEntities extends Equatable {
  final String? id;
  final String? farmerId;
  final FarmerEntity? farmer;
  final String? productName;
  final double? price;
  final String? unitType;
  final String? status;
  final double? quantity;
  final String? description;
  final String? productImage;

  const ProductEntities({
    this.farmerId,
    this.productName,
    this.price,
    this.unitType,
    this.status,
    this.quantity,
    this.description,
    this.productImage,
    this.farmer, this.id,
  });

  @override
  List<Object?> get props => [
    farmerId,
    productName,
    price,
    unitType,
    status,
    quantity,
    description,
    productImage,
    farmer,
  ];
}
