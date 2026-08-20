/// rewards_provider.dart
/// Riverpod AsyncNotifier that owns the rewards state for the current student.
/// Exposes refresh() and claimAchievement() for UI actions.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/reward_model.dart';
import '../models/rewards_catalog.dart';
import '../repository/rewards_repository.dart';

part 'rewards_provider.g.dart';

// ---------------------------------------------------------------------------
// Rewards AsyncNotifier
// ---------------------------------------------------------------------------

@riverpod
class Rewards extends _$Rewards {
  @override
  Future<RewardModel> build() async {
    final user = ref.watch(authProvider).user;
    final studentId = user?.id;
    if (studentId == null || studentId.isEmpty) {
      throw StateError('Sign in to view rewards');
    }
    return ref.read(rewardsRepositoryProvider).fetchRewards(studentId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch());
  }

  /// Claim an earned achievement.
  /// Optimistically bumps points/tier, then reconciles with the server.
  /// On failure restores prior data (does not wipe to [AsyncError]).
  Future<void> claimAchievement(String achievementId) async {
    final previous = state;
    final current = previous.asData?.value;
    if (current == null) return;

    state = AsyncData(RewardsCatalog.applyClaim(current, achievementId));

    try {
      final user = ref.read(authProvider).user;
      final studentId = user?.id;
      if (studentId == null || studentId.isEmpty) {
        throw StateError('Sign in to claim rewards');
      }
      final updated = await ref
          .read(rewardsRepositoryProvider)
          .claimAchievement(studentId, achievementId);
      if (!ref.mounted) return;
      state = AsyncData(updated);
    } catch (e) {
      if (!ref.mounted) rethrow;
      state = previous;
      rethrow;
    }
  }

  Future<RewardModel> _fetch() async {
    final user = ref.read(authProvider).user;
    final studentId = user?.id;
    if (studentId == null || studentId.isEmpty) {
      throw StateError('Sign in to view rewards');
    }
    return ref.read(rewardsRepositoryProvider).fetchRewards(studentId);
  }
}

@riverpod
int earnedAchievementsCount(Ref ref) {
  return ref.watch(rewardsProvider).value?.earnedAchievementsCount ?? 0;
}
