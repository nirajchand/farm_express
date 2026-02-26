import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // static const String baseUrl = "http://10.0.2.2:2000/api";

  // Configuration
  static const bool isPhysicalDevice = true;
  static const String _ipAddress = '192.168.18.20';
  static const int _port = 2000;

  // Base URLs
  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get serverUrl => 'http://$_host:$_port';
  static String get baseUrl => '$serverUrl/api';
  static String get mediaServerUrl => serverUrl;

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ==========Auth endpoints ======
  static const String register = "/auth/register";
  static const String login = "/auth/login";

  // ================ consumerProfile=======================
  static const String getProfile = "/consumer/getProfile";
  static const String updateProfile = "/consumer/updateProfile";

  // ================ farmerProfile=======================
  static const String getFarmerProfile = "/farmer/getProfile";
  static const String updateFarmerProfile = "/farmer/updateProfile";

  // ================ product=======================
  static const String addProducts = "/farmer/product/addProduct";
  static String getAllProducts({int page = 1, int size = 10, String? search}) {
    String url = "/consumer/products?page=$page&size=$size";
    if (search != null && search.isNotEmpty) {
      url += "&search=$search";
    }
    return url;
  }

  static const String getProductsByFarmerId = "/farmer/product/farmerProducts";
  static String deleteProduct(String productId) => "/farmer/product/$productId";
  static String updateProduct(String productId) => "/farmer/product/$productId";


  // ============Cart======================
  static const String getCart = "/consumer/cart/getCart";
  static const String addCart = "/consumer/cart/add";
  static String deleteCartItem(String productId) =>
      "/consumer/cart/remove/$productId";
  static const String updateCart = "/consumer/cart/update";

  // ================= Order =======================
  static const String placeOrder = "/consumer/order/placeOrder";
  static const String getOrder = "/consumer/order/my";
  static const String getFarmerOrder = "/farmer/order/farmer";
  static String updateOrderStatus(String orderId) => "/farmer/order/updateOrderStatus/$orderId";
}
