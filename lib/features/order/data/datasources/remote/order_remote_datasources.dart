import 'package:dio/dio.dart';
import 'package:farm_express/core/api/api_endpoints.dart';
import 'package:farm_express/core/api/app_client.dart';
import 'package:farm_express/core/services/storage/token_service.dart';
import 'package:farm_express/features/order/data/datasources/order_datasources..dart';
import 'package:farm_express/features/order/data/model/order_consumer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderRemoteDataSourceProvider = Provider<IRemoteOrderDataSource>((ref) {
  return OrderRemoteDataSourceImpl(
    ref.read(apiClientProvider),
    ref.read(tokenServiceProvider),
  );
});

class OrderRemoteDataSourceImpl implements IRemoteOrderDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  const OrderRemoteDataSourceImpl(
    ApiClient apiClient,
    TokenService tokenService,
  ) : _apiClient = apiClient,
      _tokenService = tokenService;

  @override
  Future<bool> placeOrder(OrderModel order) async {
    try {
      final token = await _tokenService.getToken();

      final response = await _apiClient.post(
        ApiEndpoints.placeOrder,
        data: order.toJson(),
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.data["success"] == true) {
        return true;
      } else {
        throw Exception(response.data["message"] ?? "Failed to place order");
      }
    } catch (e) {
      throw Exception("Error placing order: $e");
    }
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final token = await _tokenService.getToken();

      final response = await _apiClient.get(
        ApiEndpoints.getOrder,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        final List<dynamic> data = response.data["data"];
        return data.map((e) => OrderModel.fromJson(e)).toList();
      } else {
        throw Exception(
          response.data["message"] ??
              "Failed to fetch orders (${response.statusCode})",
        );
      }
    } catch (e) {
      throw Exception("Error fetching orders: $e");
    }
  }

  @override
  Future<List<OrderModel>> getFarmerOrder() async {
    try {
      final token = await _tokenService.getToken();

      final response = await _apiClient.get(
        ApiEndpoints.getFarmerOrder,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        final List<dynamic> data = response.data["data"];
        return data.map((e) => OrderModel.fromJson(e)).toList();
      } else {
        throw Exception(
          response.data["message"] ??
              "Failed to fetch orders (${response.statusCode})",
        );
      }
    } catch (e) {
      throw Exception("Error fetching orders: $e");
    }
  }
  
  @override
  Future<bool> updateOrderS(String orderStatus, String orderId) async {
    try {
      final token = await _tokenService.getToken();

      final response = await _apiClient.put(
        ApiEndpoints.updateOrderStatus(orderId),
        data: {"orderStatus": orderStatus},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return true;
      } else {
        throw Exception(
          response.data["message"] ??
              "Failed to update order status (${response.statusCode})",
        );
      }
    } catch (e) {
      throw Exception("Error updating order status: $e");
    }
  }
}
