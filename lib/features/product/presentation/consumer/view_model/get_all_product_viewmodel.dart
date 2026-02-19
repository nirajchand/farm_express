import 'package:farm_express/features/product/domain/usecases/get_allProducts_usecases.dart';
import 'package:farm_express/features/product/presentation/consumer/state/get_all_product_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllProductViewModelProvider =
    NotifierProvider<GetAllProductsViewModel, GetAllProductState>(
      () => GetAllProductsViewModel(),
    );

class GetAllProductsViewModel extends Notifier<GetAllProductState> {
  late final GetAllproductsUsecases _getAllproductsUsecases;

  @override
  GetAllProductState build() {
    _getAllproductsUsecases = ref.read(getAllProductsUsecasesProvider);
    return GetAllProductState();
  }

  Future<void> getAllProducts() async {
    state = state.copyWith(status: GetAllProductStateStatus.loading);
    final result = await _getAllproductsUsecases.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: GetAllProductStateStatus.failure,
          errorMessage: failure.message,
        );
      },
      (productsData) {
        state = state.copyWith(
          status: GetAllProductStateStatus.success,
          products: productsData,
        );
      },
    );
  }
}
