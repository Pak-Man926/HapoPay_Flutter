import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import '../config/env_config.dart';

/// Provides a stream of student account IDs whose transactions have changed.
///
/// This service subscribes to Supabase Realtime channels for transaction
/// inserts/updates. It is a no-op when Supabase is not configured.
///
/// The [studentAccountProvider] watches this stream and re-fetches account
/// data whenever a relevant change is detected, providing live updates
/// without manual refresh.
class SupabaseRealtimeService {
  SupabaseRealtimeService._();

  static SupabaseRealtimeService? _instance;
  final _controller = StreamController<String>.broadcast();
  StreamSubscription? _subscription;

  /// Stream of student IDs that have new or updated transactions.
  Stream<String> get transactionUpdates => _controller.stream;

  /// Whether Supabase is configured and available.
  bool get isAvailable => EnvConfig.supabaseUrl.isNotEmpty;

  /// Start listening to transaction changes for [studentId].
  void subscribe(String studentId) {
    if (!isAvailable) return;
    if (_subscription != null) return;

    try {
      _subscription = Supabase.instance.client
          .channel('public:transactions')
          .onPostgresChanges(
            event: '*',
            schema: 'public',
            table: 'transactions',
            callback: (payload) {
              final newStudentId = payload.newRecord['student_id'] as String?;
              if (newStudentId != null) {
                _controller.add(newStudentId);
              }
            },
          )
          .subscribe();
    } catch (_) {}
  }

  void unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    unsubscribe();
    _controller.close();
    _instance = null;
  }

  static SupabaseRealtimeService get instance {
    _instance ??= SupabaseRealtimeService._();
    return _instance!;
  }
}

final supabaseRealtimeServiceProvider =
    Provider<SupabaseRealtimeService>((ref) {
  final service = SupabaseRealtimeService.instance;
  ref.onDispose(() => service.dispose());
  return service;
});
