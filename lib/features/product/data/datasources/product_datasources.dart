
import 'dart:io';

import 'package:farm_express/features/product/data/models/product_api_model.dart';

abstract interface class IProductRemoteDataSource {
  Future<ProductApiModel> addProduct(ProductApiModel data, File? image);
  Future<List<ProductApiModel>> getAllProducts();
  Future<ProductApiModel> updateProduct(ProductApiModel data);
  Future<void> deleteProduct(String productId);
  Future<List<ProductApiModel>> getProductsByFarmerId(String farmerId);
}