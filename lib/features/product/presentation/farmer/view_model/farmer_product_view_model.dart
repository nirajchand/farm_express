
import 'package:farm_express/features/product/domain/usecases/delete_product_usecases.dart';
import 'package:farm_express/features/product/domain/usecases/get_farmer_product_usecases.dart';
import 'package:farm_express/features/product/domain/usecases/update_product_usecases.dart';
import 'package:farm_express/features/product/presentation/farmer/state/farmer_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final farmerProductViewModelProvider =
    NotifierProvider<FarmerProductViewModel, FarmerProductState>(
      () => FarmerProductViewModel(),
    );

class FarmerProductViewModel extends Notifier<FarmerProductState> {
  late final GetFarmerProductUsecases _getFarmerProductUsecases;
  late final DeleteProductUsecases _deleteProductUsecases;
  late final UpdateProductUsecases _updateProductUsecases;

  @override
  FarmerProductState build() {
    _getFarmerProductUsecases = ref.read(getFarmerProductUsecasesProvider);
    _deleteProductUsecases = ref.read(deleteProductUsecasesProvider);
    _updateProductUsecases = ref.read(updateProductUsecasesProvider);
    return const FarmerProductState();
  }

  Future<void> getProductsByFarmerId() async {
    state = state.copyWith(status: FarmerProductStatus.loading);
    final result = await _getFarmerProductUsecases.call();

    result.fold(
      (failure) => state = state.copyWith(
        status: FarmerProductStatus.failure,
        errorMessage: failure.message,
      ),
      (products) => state = state.copyWith(
        status: FarmerProductStatus.success,
        products: products,
      ),
    );
  }

  Future<bool> deleteProduct(String productId) async {
    final result = await _deleteProductUsecases.call(productId);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: FarmerProductStatus.failure,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        final updated = state.products.where((p) => p.id != productId).toList();
        state = state.copyWith(products: updated);
        return true;
      },
    );
  }

  Future<bool> updateProduct(UpdateProductUseCaseParams params) async {
    state = state.copyWith(status: FarmerProductStatus.loading);
    final result = await _updateProductUsecases.call(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: FarmerProductStatus.failure,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        getProductsByFarmerId(); // Refresh list
        return true;
      },
    );
  }
}
