import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PayStep { biometric, qr, success }

class PayQrState {
  final PayStep step;
  final bool bioDone;
  final int countdown;

  const PayQrState({
    this.step = PayStep.biometric,
    this.bioDone = false,
    this.countdown = 60,
  });

  PayQrState copyWith({
    PayStep? step,
    bool? bioDone,
    int? countdown,
  }) {
    return PayQrState(
      step: step ?? this.step,
      bioDone: bioDone ?? this.bioDone,
      countdown: countdown ?? this.countdown,
    );
  }
}

class PayQrNotifier extends Notifier<PayQrState> {
  Timer? _timer;

  @override
  PayQrState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const PayQrState();
  }

  void startCountdown() {
    _timer?.cancel();
    state = state.copyWith(countdown: 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown <= 1) {
        state = state.copyWith(countdown: 60);
      } else {
        state = state.copyWith(countdown: state.countdown - 1);
      }
    });
  }

  Future<void> authenticate() async {
    state = state.copyWith(bioDone: true);
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(step: PayStep.qr);
    startCountdown();
  }

  void simulateScanSuccess() {
    _timer?.cancel();
    state = state.copyWith(step: PayStep.success);
  }

  void reset() {
    _timer?.cancel();
    state = const PayQrState();
  }
}

final payQrProvider = NotifierProvider<PayQrNotifier, PayQrState>(
  PayQrNotifier.new,
);
