import 'package:farm_express/features/auth/domain/usecases/login_usecases.dart';
import 'package:farm_express/features/auth/domain/usecases/logout_usecase.dart';
import 'package:farm_express/features/auth/domain/usecases/register_usecases.dart';
import 'package:farm_express/features/auth/domain/usecases/reset_password_usecases.dart';
import 'package:farm_express/features/auth/domain/usecases/send_token_usecases.dart';
import 'package:farm_express/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecases;
  late final LogoutUsecase _logoutUsecase;
  late final SendTokenUsecases _sendTokenUsecase;
  late final ResetPasswordUsecases _resetPasswordUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecases = ref.read(loginUsecasesProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    _sendTokenUsecase = ref.read(sendTokenProvider);
    _resetPasswordUsecase = ref.read(resetPasswordsecasesProvider);
    return AuthState();
  }

  // Register
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final role = state.userType;

    if (role == null) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: "Please select a role",
      );
      return;
    }

    state = state.copyWith(status: AuthStatus.loading);
    final params = RegisterUsecasesParam(
      fullName: fullName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      userType: role.name,
    );
    final result = await _registerUsecase.call(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Registration Failed',
        );
      },
      (success) {
        state = state.copyWith(status: AuthStatus.registered);
      },
    );
  }

  // Login
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = LoginUsecasesParams(email: email, password: password);
    final result = await _loginUsecases.call(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Login Failed',
        );
      },
      (authEntity) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: authEntity,
        );
      },
    );
  }

  void setUserRole(UserRole role) {
    state = state.copyWith(userType: role);
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _logoutUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
      ),
    );
  }

  Future<void> sendResetToken({required String email}) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _sendTokenUsecase.call(email);
    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) => state = state.copyWith(
        status: AuthStatus.tokenSent,
        resetEmail: email, 
      ),
    );
  }

  // Reset password using token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword != confirmPassword) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: "Passwords do not match",
      );
      return;
    }

    state = state.copyWith(status: AuthStatus.loading);
    final params = ResetPasswordUsecasesParams(token: token, newPassword: newPassword);
    final result = await _resetPasswordUsecase.call(params);
    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) => state = state.copyWith(status: AuthStatus.passwordReset),
    );
  }
}
