import 'package:equatable/equatable.dart';

class ProductEntities extends Equatable {
  final String? farmerId;
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
  ];
}
