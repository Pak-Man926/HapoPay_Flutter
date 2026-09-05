import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/screens/models/achievement_item.dart';

class RewardsScreenState {
  final int totalPoints;
  final List<AchievementItem> achievements;
  final List<String> streakDays;
  final List<bool> completedDays;

  const RewardsScreenState({
    this.totalPoints = 680,
    this.streakDays = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
    this.completedDays = const [true, true, true, true, true, true, true],
    this.achievements = const [
      AchievementItem(
        id: '1',
        title: 'First Purchase',
        desc: 'Made your first payment',
        emoji: '🎯',
        pts: 10,
        isClaimed: true,
      ),
      AchievementItem(
        id: '2',
        title: 'Saver Star',
        desc: 'Reached a savings goal',
        emoji: '🎨',
        pts: 25,
        isClaimed: true,
      ),
      AchievementItem(
        id: '3',
        title: 'Budget Boss',
        desc: 'Stayed under limit 7 days',
        emoji: '💰',
        pts: 50,
        isClaimed: false,
      ),
      AchievementItem(
        id: '4',
        title: 'Streak Master',
        desc: '7-day spending streak',
        emoji: '🔥',
        pts: 75,
        isClaimed: false,
      ),
      AchievementItem(
        id: '5',
        title: 'Zero Waste',
        desc: 'No flagged purchases in a month',
        emoji: '✅',
        pts: 100,
        isClaimed: false,
      ),
      AchievementItem(
        id: '6',
        title: 'Top Saver',
        desc: 'Saved over \$100 total',
        emoji: '🏆',
        pts: 150,
        isLocked: true,
      ),
    ],
  });

  RewardsScreenState copyWith({
    int? totalPoints,
    List<AchievementItem>? achievements,
    List<String>? streakDays,
    List<bool>? completedDays,
  }) {
    return RewardsScreenState(
      totalPoints: totalPoints ?? this.totalPoints,
      achievements: achievements ?? this.achievements,
      streakDays: streakDays ?? this.streakDays,
      completedDays: completedDays ?? this.completedDays,
    );
  }
}

class RewardsScreenNotifier extends Notifier<RewardsScreenState> {
  @override
  RewardsScreenState build() => const RewardsScreenState();

  int claimAchievement(int index) {
    if (index < 0 || index >= state.achievements.length) return 0;
    final item = state.achievements[index];
    if (item.isClaimed || item.isLocked) return 0;

    final updatedList = List<AchievementItem>.from(state.achievements);
    updatedList[index] = item.copyWith(isClaimed: true);

    state = state.copyWith(
      achievements: updatedList,
      totalPoints: state.totalPoints + item.pts,
    );
    return item.pts;
  }
}

final rewardsScreenProvider =
    NotifierProvider<RewardsScreenNotifier, RewardsScreenState>(
  RewardsScreenNotifier.new,
);
