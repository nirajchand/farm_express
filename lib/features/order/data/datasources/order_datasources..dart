import 'package:farm_express/features/order/data/model/order_consumer_model.dart';

abstract interface class IRemoteOrderDataSource {
  Future<bool> placeOrder(OrderModel order);
  Future<List<OrderModel>> getOrders();
  Future<List<OrderModel>> getFarmerOrder();
  Future<bool> updateOrderS(String orderStatus, String orderId);
}
