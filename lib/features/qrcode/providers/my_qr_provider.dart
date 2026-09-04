import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyQrState {
  final double amount;
  final String description;

  const MyQrState({
    this.amount = 0.0,
    this.description = '',
  });

  String generatePayload(String studentId, String studentName) {
    final payload = {
      'student_id': studentId,
      'student_name': studentName,
      'amount': amount,
      'description': description,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
    return jsonEncode(payload);
  }

  MyQrState copyWith({
    double? amount,
    String? description,
  }) {
    return MyQrState(
      amount: amount ?? this.amount,
      description: description ?? this.description,
    );
  }
}

class MyQrNotifier extends Notifier<MyQrState> {
  @override
  MyQrState build() => const MyQrState();

  void setAmount(double amount) {
    state = state.copyWith(amount: amount);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }
}

final myQrProvider = NotifierProvider<MyQrNotifier, MyQrState>(
  MyQrNotifier.new,
);
