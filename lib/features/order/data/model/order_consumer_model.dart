import 'package:farm_express/features/consumer_profile/data/models/profile_api_model.dart';

import '../../domain/entities/order_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    super.id,
    super.productId,
    super.farmerId,
    super.productName,
    super.price,
    super.quantity,
    super.unitType,
    super.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['_id'],
      productId: json['productId'],
      farmerId: json['farmerId'],
      productName: json['productName'],
      price: (json['price'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toDouble(),
      unitType: json['unitType'],
      subtotal: (json['subtotal'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (productId != null) 'productId': productId,
      if (farmerId != null) 'farmerId': farmerId,
      if (productName != null) 'productName': productName,
      if (price != null) 'price': price,
      if (quantity != null) 'quantity': quantity,
      if (unitType != null) 'unitType': unitType,
      if (subtotal != null) 'subtotal': subtotal,
    };
  }

  factory OrderItemModel.fromEntity(OrderItemEntity entity) {
    return OrderItemModel(
      id: entity.id,
      productId: entity.productId,
      farmerId: entity.farmerId,
      productName: entity.productName,
      price: entity.price,
      quantity: entity.quantity,
      unitType: entity.unitType,
      subtotal: entity.subtotal,
    );
  }
}

class OrderModel extends OrderEntity {
  const OrderModel({
    super.id,
    super.consumerId,
    super.items,
    super.totalAmount,
    super.deliveryFee,
    super.orderStatus,
    super.paymentStatus,
    super.paymentMethod,
    super.shippingAddress,
    super.createdAt,
    super.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      consumerId: json['consumerId'] != null
          ? ProfileApiModel.fromJson(json['consumerId']).toEntity()
          : null,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e))
          .toList(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble(),
      orderStatus: json['orderStatus'],
      paymentStatus: json['paymentStatus'],
      paymentMethod: json['paymentMethod'],
      shippingAddress: json['shippingAddress'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (consumerId != null) 'consumerId': consumerId,
      if (items != null)
        'items': items!
            .map((e) => OrderItemModel.fromEntity(e).toJson())
            .toList(),
      if (totalAmount != null) 'totalAmount': totalAmount,
      if (deliveryFee != null) 'deliveryFee': deliveryFee,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (shippingAddress != null) 'shippingAddress': shippingAddress,
    };
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      consumerId: consumerId,
      items: items
          ?.map(
            (e) => OrderItemEntity(
              id: e.id,
              productId: e.productId,
              farmerId: e.farmerId,
              productName: e.productName,
              price: e.price,
              quantity: e.quantity,
              unitType: e.unitType,
              subtotal: e.subtotal,
            ),
          )
          .toList(),
      totalAmount: totalAmount,
      deliveryFee: deliveryFee,
      orderStatus: orderStatus,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      shippingAddress: shippingAddress,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      consumerId: entity.consumerId,
      items: entity.items?.map((e) => OrderItemModel.fromEntity(e)).toList(),
      totalAmount: entity.totalAmount,
      deliveryFee: entity.deliveryFee,
      orderStatus: entity.orderStatus,
      paymentStatus: entity.paymentStatus,
      paymentMethod: entity.paymentMethod,
      shippingAddress: entity.shippingAddress,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
