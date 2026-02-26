import 'package:farm_express/features/cart/domain/usecases/add_cart_usecases.dart';
import 'package:farm_express/features/cart/domain/usecases/delete_cart_item_usecases.dart';
import 'package:farm_express/features/cart/domain/usecases/get_cart_usecases.dart';
import 'package:farm_express/features/cart/domain/usecases/update_cart_usecases.dart';
import 'package:farm_express/features/cart/presentation/state/cart_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCartViewModelProvider = NotifierProvider<GetCartViewModel, CartState>(
  () => GetCartViewModel(),
);

class GetCartViewModel extends Notifier<CartState> {
  late final GetCartUsecases _getCartUsecases;
  late final AddCartUsecases _addCartUsecases;
  late final DeleteCartItemUsecases _deleteCartItemUsecases;
  late final UpdateCartUsecases _updateCartUsecases;

  @override
  CartState build() {
    _getCartUsecases = ref.read(getCartUsecasesProvider);
    _addCartUsecases = ref.read(addCartUsecasesProvider);
    _deleteCartItemUsecases = ref.read(deleteCartItemUsecasesProvider);
    _updateCartUsecases = ref.read(updateCartUsecasesProvider);
    return CartState();
  }

  Future<void> getCart() async {
    state = state.copyWith(status: CartStatus.loading);
    final result = await _getCartUsecases.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CartStatus.failure,
          errorMessage: failure.message,
        );
      },
      (cartData) {
        state = state.copyWith(status: CartStatus.success, cart: cartData);
      },
    );
  }

  Future<void> addToCart(String productId, int quantity) async {
    state = state.copyWith(status: CartStatus.loading);
    final result = await _addCartUsecases.call(
      AddCartUsecasesParams(productId: productId, quantity: quantity),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CartStatus.failure,
          errorMessage: failure.message,
        );
      },
      (success) {
        if (success) {
          getCart();
        } else {
          state = state.copyWith(
            status: CartStatus.failure,
            errorMessage: 'Failed to add item to cart',
          );
        }
      },
    );
  }

  Future<bool> removeFromCart(String productId) async {
    state = state.copyWith(isDeleting: true); // don't touch CartStatus
    final result = await _deleteCartItemUsecases.call(productId);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isDeleting: false,
          status: CartStatus.failure,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        if (success) {
          getCart(); // this will set loading/success naturally
          state = state.copyWith(isDeleting: false);
          return true;
        } else {
          state = state.copyWith(
            isDeleting: false,
            status: CartStatus.failure,
            errorMessage: 'Failed to remove item from cart',
          );
          return false;
        }
      },
    );
  }

  Future<void> updateCart(String productId, double quantity) async {
    state = state.copyWith(status: CartStatus.loading);
    final result = await _updateCartUsecases.call(
      UpdateCartUsecasesParams(productId: productId, quantity: quantity),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CartStatus.failure,
          errorMessage: failure.message,
        );
      },
      (updatedCart) {
        getCart();
        state = state.copyWith(status: CartStatus.success, cart: updatedCart);
      },
    );
  }
}
