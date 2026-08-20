/// Shared rewards game-design catalog: tiers, achievements, seed helpers.
/// Used by [RewardModel.demo], MockInterceptor, and UI so content cannot drift.
library;

import 'reward_model.dart';

/// Achievement category for grouping in the UI.
enum AchievementCategory { payments, streak, saving }

extension AchievementCategoryX on AchievementCategory {
  String get label {
    switch (this) {
      case AchievementCategory.payments:
        return 'Payments';
      case AchievementCategory.streak:
        return 'Budget & streak';
      case AchievementCategory.saving:
        return 'Saving';
    }
  }
}

/// Static definition of an achievement (progress state is per-student).
class AchievementDefinition {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int points;
  final AchievementCategory category;
  final int? defaultGoal;

  const AchievementDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.points,
    required this.category,
    this.defaultGoal,
  });
}

/// Single source of truth for HapoPay student rewards game design.
class RewardsCatalog {
  RewardsCatalog._();

  /// Streak milestones highlighted in the streak panel.
  static const List<int> streakMilestones = [3, 7, 14, 30];

  static const List<MilestoneModel> milestones = [
    MilestoneModel(tier: RewardTier.bronze, minPoints: 0, maxPoints: 150),
    MilestoneModel(tier: RewardTier.silver, minPoints: 150, maxPoints: 500),
    MilestoneModel(tier: RewardTier.gold, minPoints: 500, maxPoints: 1000),
    MilestoneModel(tier: RewardTier.platinum, minPoints: 1000),
  ];

  static const List<AchievementDefinition> achievements = [
    // Payments
    AchievementDefinition(
      id: 'first_pay',
      name: 'First Tap',
      description: 'Complete your very first payment',
      icon: 'payment',
      points: 25,
      category: AchievementCategory.payments,
    ),
    AchievementDefinition(
      id: 'qr_rookie',
      name: 'QR Rookie',
      description: 'Pay with QR scan 3 times',
      icon: 'qr_code_scanner',
      points: 50,
      category: AchievementCategory.payments,
      defaultGoal: 3,
    ),
    AchievementDefinition(
      id: 'qr_pro',
      name: 'QR Pro',
      description: 'Pay with QR scan 10 times',
      icon: 'qr_code_scanner',
      points: 100,
      category: AchievementCategory.payments,
      defaultGoal: 10,
    ),
    AchievementDefinition(
      id: 'campus_champ',
      name: 'Campus Champ',
      description: 'Complete 25 total payments',
      icon: 'school',
      points: 200,
      category: AchievementCategory.payments,
      defaultGoal: 25,
    ),
    // Budget / streak
    AchievementDefinition(
      id: 'budget_3',
      name: 'Budget Buddy',
      description: 'Stay under your limit for 3 days straight',
      icon: 'savings',
      points: 75,
      category: AchievementCategory.streak,
      defaultGoal: 3,
    ),
    AchievementDefinition(
      id: 'week_warrior',
      name: 'Week Warrior',
      description: 'Keep a 7-day under-budget streak',
      icon: 'local_fire_department',
      points: 150,
      category: AchievementCategory.streak,
      defaultGoal: 7,
    ),
    AchievementDefinition(
      id: 'month_master',
      name: 'Month Master',
      description: 'Keep a 30-day under-budget streak',
      icon: 'emoji_events',
      points: 300,
      category: AchievementCategory.streak,
      defaultGoal: 30,
    ),
    // Saving
    AchievementDefinition(
      id: 'smart_spender',
      name: 'Smart Spender',
      description: 'Finish a full week under your spending limit',
      icon: 'shopping_cart',
      points: 100,
      category: AchievementCategory.saving,
    ),
    AchievementDefinition(
      id: 'big_buffer',
      name: 'Big Buffer',
      description: 'Save KSh 500 toward your buffer',
      icon: 'account_balance_wallet',
      points: 125,
      category: AchievementCategory.saving,
      defaultGoal: 500,
    ),
  ];

  static AchievementDefinition? definitionFor(String id) {
    for (final d in achievements) {
      if (d.id == id) return d;
    }
    return null;
  }

  static AchievementCategory categoryFor(String id) {
    return definitionFor(id)?.category ?? AchievementCategory.payments;
  }

  /// Tier for a raw points total.
  static RewardTier tierForPoints(int points) {
    if (points >= 1000) return RewardTier.platinum;
    if (points >= 500) return RewardTier.gold;
    if (points >= 150) return RewardTier.silver;
    return RewardTier.bronze;
  }

  /// Absolute next-tier threshold, or null at platinum.
  static int? nextMilestonePoints(int points) {
    final tier = tierForPoints(points);
    final current = milestones.firstWhere((m) => m.tier == tier);
    return current.maxPoints;
  }

  /// Apply claim points and recompute tier fields on a [RewardModel].
  static RewardModel applyClaim(RewardModel reward, String achievementId) {
    AchievementModel? target;
    for (final a in reward.achievements) {
      if (a.id == achievementId) {
        target = a;
        break;
      }
    }
    if (target == null || !target.earned || target.claimed) return reward;

    final newTotal = reward.totalPoints + target.points;
    final updatedAchievements = reward.achievements.map((a) {
      if (a.id == achievementId) return a.copyWith(claimed: true);
      return a;
    }).toList();

    return reward.copyWith(
      totalPoints: newTotal,
      tier: tierForPoints(newTotal),
      nextMilestonePoints: nextMilestonePoints(newTotal),
      achievements: updatedAchievements,
      milestones: List<MilestoneModel>.from(milestones),
    );
  }

  /// Mid-progress demo / mock seed (~220 pts, Silver) with claimable items.
  static RewardModel seedReward({required String studentId}) {
    return RewardModel(
      studentId: studentId,
      totalPoints: 220,
      tier: RewardTier.silver,
      streakDays: 5,
      nextMilestonePoints: 500,
      milestones: milestones,
      achievements: [
        AchievementModel(
          id: 'first_pay',
          name: 'First Tap',
          description: 'Complete your very first payment',
          earned: true,
          claimed: true,
          icon: 'payment',
          points: 25,
        ),
        AchievementModel(
          id: 'qr_rookie',
          name: 'QR Rookie',
          description: 'Pay with QR scan 3 times',
          earned: true,
          claimed: false,
          icon: 'qr_code_scanner',
          points: 50,
          progress: 3,
          goal: 3,
        ),
        AchievementModel(
          id: 'qr_pro',
          name: 'QR Pro',
          description: 'Pay with QR scan 10 times',
          earned: false,
          icon: 'qr_code_scanner',
          points: 100,
          progress: 3,
          goal: 10,
        ),
        AchievementModel(
          id: 'campus_champ',
          name: 'Campus Champ',
          description: 'Complete 25 total payments',
          earned: false,
          icon: 'school',
          points: 200,
          progress: 8,
          goal: 25,
        ),
        AchievementModel(
          id: 'budget_3',
          name: 'Budget Buddy',
          description: 'Stay under your limit for 3 days straight',
          earned: true,
          claimed: false,
          icon: 'savings',
          points: 75,
          progress: 3,
          goal: 3,
        ),
        AchievementModel(
          id: 'week_warrior',
          name: 'Week Warrior',
          description: 'Keep a 7-day under-budget streak',
          earned: false,
          icon: 'local_fire_department',
          points: 150,
          progress: 5,
          goal: 7,
        ),
        AchievementModel(
          id: 'month_master',
          name: 'Month Master',
          description: 'Keep a 30-day under-budget streak',
          earned: false,
          icon: 'emoji_events',
          points: 300,
          progress: 5,
          goal: 30,
        ),
        AchievementModel(
          id: 'smart_spender',
          name: 'Smart Spender',
          description: 'Finish a full week under your spending limit',
          earned: false,
          icon: 'shopping_cart',
          points: 100,
        ),
        AchievementModel(
          id: 'big_buffer',
          name: 'Big Buffer',
          description: 'Save KSh 500 toward your buffer',
          earned: false,
          icon: 'account_balance_wallet',
          points: 125,
          progress: 180,
          goal: 500,
        ),
      ],
    );
  }

  /// JSON map for MockInterceptor / network fixtures.
  static Map<String, dynamic> seedJson({required String studentId}) {
    return seedReward(studentId: studentId).toJson();
  }

  /// Point range label for a tier (e.g. "0–149", "1000+").
  static String rangeLabel(RewardTier tier) {
    final m = milestones.firstWhere((x) => x.tier == tier);
    if (m.maxPoints == null) return '${m.minPoints}+';
    // Display inclusive upper bound as maxPoints - 1 for clarity (0–149).
    return '${m.minPoints}–${m.maxPoints! - 1}';
  }
}
