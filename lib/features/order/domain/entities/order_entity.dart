import 'package:farm_express/features/consumer_profile/domain/entities/profile_entity.dart';

class OrderItemEntity {
  final String? id;
  final String? productId;
  final String? farmerId;
  final String? productName;
  final double? price;
  final double? quantity;
  final String? unitType;
  final double? subtotal;

  const OrderItemEntity({
    this.id,
    this.productId,
    this.farmerId,
    this.productName,
    this.price,
    this.quantity,
    this.unitType,
    this.subtotal,
  });
}

class OrderEntity {
  final String? id;
  final ProfileEntity? consumerId;
  final List<OrderItemEntity>? items;
  final double? totalAmount;
  final double? deliveryFee;
  final String? orderStatus;
  final String? paymentStatus;
  final String? paymentMethod;
  final String? shippingAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderEntity({
    this.id,
    this.consumerId,
    this.items,
    this.totalAmount,
    this.deliveryFee,
    this.orderStatus,
    this.paymentStatus,
    this.paymentMethod,
    this.shippingAddress,
    this.createdAt,
    this.updatedAt,
  });
}
