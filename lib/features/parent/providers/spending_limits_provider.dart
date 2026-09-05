import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../student/providers/student_account_provider.dart';

class SpendingLimitsState {
  final double currentLimit;
  final bool isCardLocked;
  final bool isSaving;
  final String? errorMessage;
  final bool isInitialized;

  const SpendingLimitsState({
    this.currentLimit = 50.0,
    this.isCardLocked = false,
    this.isSaving = false,
    this.errorMessage,
    this.isInitialized = false,
  });

  SpendingLimitsState copyWith({
    double? currentLimit,
    bool? isCardLocked,
    bool? isSaving,
    String? errorMessage,
    bool? isInitialized,
    bool clearError = false,
  }) {
    return SpendingLimitsState(
      currentLimit: currentLimit ?? this.currentLimit,
      isCardLocked: isCardLocked ?? this.isCardLocked,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class SpendingLimitsNotifier extends Notifier<SpendingLimitsState> {
  @override
  SpendingLimitsState build() {
    final accountAsync = ref.watch(studentAccountProvider);
    final account = accountAsync.value;
    if (account != null) {
      return SpendingLimitsState(
        currentLimit: account.dailyLimit > 0 ? account.dailyLimit : 50.0,
        isCardLocked: account.dailyLimit == 0.0,
        isInitialized: true,
      );
    }
    return const SpendingLimitsState();
  }

  void setLimit(double limit) {
    state = state.copyWith(currentLimit: limit, clearError: true);
  }

  void setCardLocked(bool locked) {
    state = state.copyWith(isCardLocked: locked, clearError: true);
  }

  Future<bool> saveLimit() async {
    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final targetLimit = state.isCardLocked ? 0.0 : state.currentLimit;
      await ref.read(studentAccountProvider.notifier).updateLimit(targetLimit);
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

final spendingLimitsProvider =
    NotifierProvider<SpendingLimitsNotifier, SpendingLimitsState>(
  SpendingLimitsNotifier.new,
);
