import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSettingsState {
  final bool txnAlerts;
  final bool flaggedPurchases;
  final bool allowanceReminders;
  final bool biometricUnlock;
  final bool parentPin;
  final bool spendingAlerts;

  const UserSettingsState({
    this.txnAlerts = true,
    this.flaggedPurchases = true,
    this.allowanceReminders = false,
    this.biometricUnlock = true,
    this.parentPin = true,
    this.spendingAlerts = true,
  });

  UserSettingsState copyWith({
    bool? txnAlerts,
    bool? flaggedPurchases,
    bool? allowanceReminders,
    bool? biometricUnlock,
    bool? parentPin,
    bool? spendingAlerts,
  }) {
    return UserSettingsState(
      txnAlerts: txnAlerts ?? this.txnAlerts,
      flaggedPurchases: flaggedPurchases ?? this.flaggedPurchases,
      allowanceReminders: allowanceReminders ?? this.allowanceReminders,
      biometricUnlock: biometricUnlock ?? this.biometricUnlock,
      parentPin: parentPin ?? this.parentPin,
      spendingAlerts: spendingAlerts ?? this.spendingAlerts,
    );
  }
}

class UserSettingsNotifier extends Notifier<UserSettingsState> {
  @override
  UserSettingsState build() => const UserSettingsState();

  void setTxnAlerts(bool value) {
    state = state.copyWith(txnAlerts: value);
  }

  void setFlaggedPurchases(bool value) {
    state = state.copyWith(flaggedPurchases: value);
  }

  void setAllowanceReminders(bool value) {
    state = state.copyWith(allowanceReminders: value);
  }

  void setBiometricUnlock(bool value) {
    state = state.copyWith(biometricUnlock: value);
  }

  void setParentPin(bool value) {
    state = state.copyWith(parentPin: value);
  }

  void setSpendingAlerts(bool value) {
    state = state.copyWith(spendingAlerts: value);
  }
}

final userSettingsProvider =
    NotifierProvider<UserSettingsNotifier, UserSettingsState>(
  UserSettingsNotifier.new,
);
