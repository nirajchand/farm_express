import 'package:farm_express/features/product/domain/usecases/get_farmer_product_usecases.dart';
import 'package:farm_express/features/product/presentation/farmer/state/farmer_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final farmerProductViewModelProvider =
    NotifierProvider<FarmerProductViewModel, FarmerProductState>(
      () => FarmerProductViewModel(),
    );

class FarmerProductViewModel extends Notifier<FarmerProductState> {
  late final GetFarmerProductUsecases _getFarmerProductUsecases;

  @override
  FarmerProductState build() {
    _getFarmerProductUsecases = ref.read(getFarmerProductUsecasesProvider);
    return const FarmerProductState();
  }

  Future<void> getProductsByFarmerId() async {
    state = state.copyWith(status: FarmerProductStatus.loading);
    final result = await _getFarmerProductUsecases.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: FarmerProductStatus.failure,
          errorMessage: failure.message,
        );
      },
      (productsData) {
        state = state.copyWith(
          status: FarmerProductStatus.success,
          products: productsData,
        );
      },
    );
  }
}
