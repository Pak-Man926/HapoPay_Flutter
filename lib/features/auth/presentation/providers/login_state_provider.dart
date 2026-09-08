import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'auth_providers.dart';

class LoginScreenState {
  final UserRole selectedRole;
  final bool obscurePassword;
  final bool isLoading;
  final String? errorMessage;

  const LoginScreenState({
    this.selectedRole = UserRole.parent,
    this.obscurePassword = true,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginScreenState copyWith({
    UserRole? selectedRole,
    bool? obscurePassword,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginScreenState(
      selectedRole: selectedRole ?? this.selectedRole,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class LoginScreenNotifier extends Notifier<LoginScreenState> {
  @override
  LoginScreenState build() => const LoginScreenState();

  void setRole(UserRole role) {
    state = state.copyWith(selectedRole: role, clearError: true);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void setError(String? message) {
    state = state.copyWith(errorMessage: message);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty || password.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please enter your email and password.',
      );
      Logger().e('Login failed: Email or password is empty.');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      // -----------------------------------------------------------------------
      // API Authentication (Commented out for UI testing)
      // -----------------------------------------------------------------------
      // await ref.read(authProvider.notifier).login(cleanEmail, password);
      // final authState = ref.read(authProvider);
      //
      // if (authState.isAuthenticated) {
      //   state = state.copyWith(isLoading: false, clearError: true);
      //   Logger().i(
      //       "Login successful for user: ${authState.user?.email} with role: ${authState.user?.role} ");
      //   return true;
      // } else {
      //   state = state.copyWith(
      //     isLoading: false,
      //     errorMessage: authState.errorMessage ?? 'Authentication failed.',
      //   );
      //   Logger().e(
      //     'Login failed: ${authState.errorMessage ?? 'Unknown error.'}',
      //   );
      //   return false;
      // }

      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

final loginStateProvider =
    NotifierProvider<LoginScreenNotifier, LoginScreenState>(
  LoginScreenNotifier.new,
);
