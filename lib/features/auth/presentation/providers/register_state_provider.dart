import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_user.dart';
import 'auth_providers.dart';

class RegisterScreenState {
  final int currentStep;
  final UserRole selectedRole;
  final bool obscurePassword;
  final bool obscureConfirm;
  final bool isLoading;
  final String? errorMessage;
  final String inviteCode;

  const RegisterScreenState({
    this.currentStep = 1,
    this.selectedRole = UserRole.parent,
    this.obscurePassword = true,
    this.obscureConfirm = true,
    this.isLoading = false,
    this.errorMessage,
    this.inviteCode = 'HAPOFAM-7341',
  });

  RegisterScreenState copyWith({
    int? currentStep,
    UserRole? selectedRole,
    bool? obscurePassword,
    bool? obscureConfirm,
    bool? isLoading,
    String? errorMessage,
    String? inviteCode,
    bool clearError = false,
  }) {
    return RegisterScreenState(
      currentStep: currentStep ?? this.currentStep,
      selectedRole: selectedRole ?? this.selectedRole,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      inviteCode: inviteCode ?? this.inviteCode,
    );
  }
}

class RegisterScreenNotifier extends Notifier<RegisterScreenState> {
  @override
  RegisterScreenState build() => const RegisterScreenState();

  void setStep(int step) {
    state = state.copyWith(currentStep: step, clearError: true);
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(
        currentStep: state.currentStep - 1,
        clearError: true,
      );
    }
  }

  void setRole(UserRole role) {
    state = state.copyWith(selectedRole: role, clearError: true);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleConfirmVisibility() {
    state = state.copyWith(obscureConfirm: !state.obscureConfirm);
  }

  void setError(String? error) {
    state = state.copyWith(errorMessage: error);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  bool validateAndAdvance({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    state = state.copyWith(clearError: true);

    if (state.currentStep == 1) {
      if (fullName.trim().isEmpty || email.trim().isEmpty) {
        state = state.copyWith(errorMessage: 'Please fill in all fields.');
        return false;
      }
      state = state.copyWith(currentStep: 2, clearError: true);
      return true;
    } else if (state.currentStep == 2) {
      if (password.isEmpty) {
        state = state.copyWith(errorMessage: 'Please enter a password.');
        return false;
      }
      if (password.length < 6) {
        state = state.copyWith(
          errorMessage: 'Password must be at least 6 characters.',
        );
        return false;
      }
      if (password != confirmPassword) {
        state = state.copyWith(errorMessage: "Passwords don't match.");
        return false;
      }
      state = state.copyWith(currentStep: 3, clearError: true);
      return true;
    }

    return true;
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await ref.read(authProvider.notifier).register(
            email: email.trim(),
            password: password,
            fullName: fullName.trim(),
            role: state.selectedRole,
          );

      final authState = ref.read(authProvider);

      if (authState.isAuthenticated) {
        state = state.copyWith(isLoading: false, clearError: true);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: authState.errorMessage ?? 'Registration failed.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

final registerStateProvider =
    NotifierProvider<RegisterScreenNotifier, RegisterScreenState>(
  RegisterScreenNotifier.new,
);
