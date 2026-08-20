import 'package:flutter_test/flutter_test.dart';
import 'package:hapopay/features/student/models/reward_model.dart';
import 'package:hapopay/features/student/models/rewards_catalog.dart';

void main() {
  group('RewardsCatalog thresholds', () {
    test('tierForPoints matches redesign bands', () {
      expect(RewardsCatalog.tierForPoints(0), RewardTier.bronze);
      expect(RewardsCatalog.tierForPoints(149), RewardTier.bronze);
      expect(RewardsCatalog.tierForPoints(150), RewardTier.silver);
      expect(RewardsCatalog.tierForPoints(499), RewardTier.silver);
      expect(RewardsCatalog.tierForPoints(500), RewardTier.gold);
      expect(RewardsCatalog.tierForPoints(999), RewardTier.gold);
      expect(RewardsCatalog.tierForPoints(1000), RewardTier.platinum);
    });

    test('nextMilestonePoints is absolute threshold', () {
      expect(RewardsCatalog.nextMilestonePoints(100), 150);
      expect(RewardsCatalog.nextMilestonePoints(220), 500);
      expect(RewardsCatalog.nextMilestonePoints(600), 1000);
      expect(RewardsCatalog.nextMilestonePoints(1200), isNull);
    });

    test('rangeLabel shows inclusive display bands', () {
      expect(RewardsCatalog.rangeLabel(RewardTier.bronze), '0–149');
      expect(RewardsCatalog.rangeLabel(RewardTier.silver), '150–499');
      expect(RewardsCatalog.rangeLabel(RewardTier.gold), '500–999');
      expect(RewardsCatalog.rangeLabel(RewardTier.platinum), '1000+');
    });

    test('catalog has redesigned achievement ids', () {
      final ids = RewardsCatalog.achievements.map((a) => a.id).toSet();
      expect(ids, containsAll([
        'first_pay',
        'qr_rookie',
        'qr_pro',
        'campus_champ',
        'budget_3',
        'week_warrior',
        'month_master',
        'smart_spender',
        'big_buffer',
      ]));
      expect(ids.contains('social_star'), isFalse);
    });
  });

  group('RewardModel', () {
    test('seed demo is silver mid-progress with claimables', () {
      final demo = RewardModel.demo(studentId: 'student_123');
      expect(demo.studentId, 'student_123');
      expect(demo.tier, RewardTier.silver);
      expect(demo.totalPoints, 220);
      expect(demo.streakDays, 5);
      expect(demo.nextMilestonePoints, 500);
      expect(demo.achievements.where((a) => a.earned && !a.claimed).length,
          greaterThanOrEqualTo(1));
    });

    test('JSON round-trip preserves seed', () {
      final original = RewardsCatalog.seedReward(studentId: 's1');
      final restored = RewardModel.fromJson(original.toJson());
      expect(restored.studentId, original.studentId);
      expect(restored.totalPoints, original.totalPoints);
      expect(restored.tier, original.tier);
      expect(restored.streakDays, original.streakDays);
      expect(restored.achievements.length, original.achievements.length);
      expect(restored.milestones.length, 4);
    });

    test('tierProgressFraction within silver band', () {
      final reward = RewardsCatalog.seedReward(studentId: 's1');
      // 220 in 150–500 → (220-150)/(500-150) = 70/350
      expect(reward.tierProgressFraction, closeTo(70 / 350, 0.001));
    });

    test('copyWith can clear nextMilestonePoints', () {
      final reward = RewardsCatalog.seedReward(studentId: 's1');
      final cleared = reward.copyWith(
        totalPoints: 1000,
        tier: RewardTier.platinum,
        nextMilestonePoints: null,
      );
      expect(cleared.nextMilestonePoints, isNull);
      expect(cleared.tier, RewardTier.platinum);
    });
  });

  group('RewardsCatalog.applyClaim', () {
    test('bumps points, marks claimed, may promote tier', () {
      final before = RewardsCatalog.seedReward(studentId: 's1');
      // qr_rookie is earned unclaimed (+50) → 270 still silver
      final after = RewardsCatalog.applyClaim(before, 'qr_rookie');
      expect(after.totalPoints, before.totalPoints + 50);
      expect(
        after.achievements.firstWhere((a) => a.id == 'qr_rookie').claimed,
        isTrue,
      );
      expect(after.tier, RewardTier.silver);
      expect(after.nextMilestonePoints, 500);
    });

    test('claiming both claimables can promote toward gold path', () {
      var reward = RewardsCatalog.seedReward(studentId: 's1');
      reward = RewardsCatalog.applyClaim(reward, 'qr_rookie'); // +50 → 270
      reward = RewardsCatalog.applyClaim(reward, 'budget_3'); // +75 → 345
      expect(reward.totalPoints, 345);
      expect(reward.tier, RewardTier.silver);
    });

    test('no-op when already claimed or not earned', () {
      final before = RewardsCatalog.seedReward(studentId: 's1');
      final afterClaimed = RewardsCatalog.applyClaim(before, 'first_pay');
      expect(afterClaimed.totalPoints, before.totalPoints);
      final afterLocked = RewardsCatalog.applyClaim(before, 'month_master');
      expect(afterLocked.totalPoints, before.totalPoints);
    });
  });
}
