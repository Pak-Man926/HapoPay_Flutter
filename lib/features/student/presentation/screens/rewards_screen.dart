import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapopay/core/constants/constants.dart';
import 'package:hapopay/features/student/presentation/screens/models/achievement_item.dart';
import 'package:hapopay/features/student/presentation/screens/models/tier_info.dart';

import '../../../../core/theme/tokens.dart';
import '../../providers/rewards_provider.dart';

class RewardsScreen extends ConsumerStatefulWidget {
  final bool isEmbeddedInShell;

  const RewardsScreen({
    super.key,
    this.isEmbeddedInShell = false,
  });

  @override
  ConsumerState<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends ConsumerState<RewardsScreen> {
  static const List<TierInfo> _tiers = [
    TierInfo(
        name: 'Sprout',
        min: 0,
        max: 200,
        color: Color(0xFF64748B),
        emoji: '🌱'),
    TierInfo(
        name: 'Scout',
        min: 200,
        max: 500,
        color: Color(0xFF00B4D8),
        emoji: '🔵'),
    TierInfo(
        name: 'Keeper',
        min: 500,
        max: 1000,
        color: Color(0xFF7C4DFF),
        emoji: '💜'),
    TierInfo(
        name: 'Champion',
        min: 1000,
        max: 2000,
        color: Color(0xFFFFD166),
        emoji: '⭐'),
    TierInfo(
        name: 'Legend',
        min: 2000,
        max: 999999,
        color: Color(0xFFFF6B35),
        emoji: '🔥'),
  ];

  late List<AchievementItem> _achievements;
  final List<String> _streakDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<bool> _completedDays = [true, true, true, true, true, true, true];

  @override
  void initState() {
    super.initState();
    _achievements = [
      const AchievementItem(
        id: '1',
        title: 'First Purchase',
        desc: 'Made your first payment',
        emoji: '🎯',
        pts: 10,
        isClaimed: true,
      ),
      const AchievementItem(
        id: '2',
        title: 'Saver Star',
        desc: 'Reached a savings goal',
        emoji: '🎨',
        pts: 25,
        isClaimed: true,
      ),
      const AchievementItem(
        id: '3',
        title: 'Budget Boss',
        desc: 'Stayed under limit 7 days',
        emoji: '💰',
        pts: 50,
        isClaimed: false,
      ),
      const AchievementItem(
        id: '4',
        title: 'Streak Master',
        desc: '7-day spending streak',
        emoji: '🔥',
        pts: 75,
        isClaimed: false,
      ),
      const AchievementItem(
        id: '5',
        title: 'Zero Waste',
        desc: 'No flagged purchases in a month',
        emoji: '✅',
        pts: 100,
        isClaimed: false,
      ),
      const AchievementItem(
        id: '6',
        title: 'Top Saver',
        desc: 'Saved over \$100 total',
        emoji: '🏆',
        pts: 150,
        isLocked: true,
      ),
    ];
  }

  void _claimAchievement(int index) {
    HapticFeedback.mediumImpact();
    setState(() {
      _achievements[index] = _achievements[index].copyWith(isClaimed: true);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Claimed +${_achievements[index].pts} reward points!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTokens.accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rewardsAsync = ref.watch(rewardsProvider);

    final backgroundColor =
        isDark ? AppTokens.darkBackground : AppTokens.lightBackground;
    final foregroundColor =
        isDark ? AppTokens.darkForeground : AppTokens.lightForeground;
    final mutedForeground =
        isDark ? AppTokens.darkMutedForeground : AppTokens.lightMutedForeground;
    final cardColor = isDark ? AppTokens.darkCard : AppTokens.lightCard;
    final borderColor = isDark ? AppTokens.darkBorder : AppTokens.lightBorder;

    final currentPoints = rewardsAsync.value?.totalPoints ?? 680;
    final currentTier = _tiers.firstWhere(
      (t) => currentPoints >= t.min && currentPoints < t.max,
      orElse: () => _tiers[2],
    );
    final currentTierIndex = _tiers.indexOf(currentTier);
    final nextTier = currentTierIndex < _tiers.length - 1
        ? _tiers[currentTierIndex + 1]
        : null;

    final pctToNext = nextTier != null
        ? ((currentPoints - currentTier.min) / (nextTier.min - currentTier.min))
            .clamp(0.0, 1.0)
        : 1.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: widget.isEmbeddedInShell
          ? null
          : AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: foregroundColor, size: 20),
                onPressed: () => context.pop(),
              ),
              title: Text(
                'Rewards & Streaks',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: foregroundColor,
                ),
              ),
              centerTitle: true,
            ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Tier Hero Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    currentTier.color.withValues(alpha: isDark ? 0.25 : 0.15),
                    currentTier.color.withValues(alpha: isDark ? 0.08 : 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppTokens.borderRadius3xl,
                border: Border.all(
                  color: currentTier.color.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Tier',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: mutedForeground,
                            ),
                          ),
                          const Spacing.vertical(2),
                          Row(
                            children: [
                              Text(currentTier.emoji,
                                  style: const TextStyle(fontSize: 24)),
                              const Spacing.horizontal(6),
                              Text(
                                currentTier.name,
                                style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: foregroundColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$currentPoints',
                            style: GoogleFonts.dmMono(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: currentTier.color,
                            ),
                          ),
                          Text(
                            'total points',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (nextTier != null) ...[
                    const Spacing.vertical(18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentTier.name,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: mutedForeground,
                          ),
                        ),
                        Text(
                          '${nextTier.min - currentPoints} pts to ${nextTier.emoji} ${nextTier.name}',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: mutedForeground,
                          ),
                        ),
                      ],
                    ),
                    const Spacing.vertical(6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pctToNext,
                        backgroundColor:
                            isDark ? AppTokens.darkMuted : AppTokens.lightMuted,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(currentTier.color),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Spacing.vertical(20),

            // Tier Roadmap Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: AppTokens.borderRadiusXl,
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.emoji_events_outlined,
                          color: AppTokens.primary, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Tier Roadmap',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: foregroundColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacing.vertical(16),
                  Row(
                    children: List.generate(_tiers.length, (i) {
                      final tier = _tiers[i];
                      final reached = currentPoints >= tier.min;
                      final isCurrent = tier == currentTier;

                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: isCurrent ? 36 : 30,
                                    height: isCurrent ? 36 : 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: reached
                                          ? tier.color
                                          : (isDark
                                              ? AppTokens.darkMuted
                                              : AppTokens.lightMuted),
                                      boxShadow: isCurrent
                                          ? [
                                              BoxShadow(
                                                color: tier.color
                                                    .withValues(alpha: 0.5),
                                                blurRadius: 10,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Center(
                                      child: Text(
                                        reached ? tier.emoji : '○',
                                        style: TextStyle(
                                          fontSize: reached ? 16 : 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacing.vertical(4),
                                  Text(
                                    tier.name,
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: isCurrent
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isCurrent
                                          ? tier.color
                                          : mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (i < _tiers.length - 1)
                              Container(
                                width: 8,
                                height: 2,
                                color: currentPoints >= _tiers[i + 1].min
                                    ? _tiers[i + 1].color
                                    : (isDark
                                        ? AppTokens.darkMuted
                                        : AppTokens.lightMuted),
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const Spacing.vertical(20),

            // 7-Day Streak Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: AppTokens.borderRadiusXl,
                border: Border.all(
                  color: AppTokens.accent.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTokens.accent.withValues(alpha: 0.08),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 18)),
                          const Spacing.horizontal(6),
                          Text(
                            '7-Day Streak',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: foregroundColor,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTokens.accent.withValues(alpha: 0.15),
                          borderRadius: AppTokens.borderRadiusFull,
                        ),
                        child: Text(
                          '🔥 Keep it going!',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTokens.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacing.vertical(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (i) {
                      final isComplete = _completedDays[i];
                      return Column(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isComplete
                                  ? AppTokens.accent
                                  : (isDark
                                      ? AppTokens.darkMuted
                                      : AppTokens.lightMuted),
                            ),
                            child: Center(
                              child: isComplete
                                  ? const Icon(Icons.check_rounded,
                                      color: AppTokens.darkBackground, size: 18)
                                  : null,
                            ),
                          ),
                          const Spacing.vertical(4),
                          Text(
                            _streakDays[i],
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: mutedForeground,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  const Spacing.vertical(12),
                  Center(
                    child: Text(
                      "Complete today's purchase to keep your streak!",
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacing.vertical(22),

            // Achievements List
            Text(
              'Achievements',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: foregroundColor,
              ),
            ),
            const Spacing.vertical(12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _achievements.length,
              separatorBuilder: (_, __) => const Spacing.vertical(10),
              itemBuilder: (context, index) {
                final award = _achievements[index];

                return Opacity(
                  opacity: award.isLocked ? 0.5 : 1.0,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: award.isClaimed
                          ? AppTokens.accent.withValues(alpha: 0.08)
                          : cardColor,
                      borderRadius: AppTokens.borderRadiusLg,
                      border: Border.all(
                        color: award.isClaimed
                            ? AppTokens.accent.withValues(alpha: 0.35)
                            : borderColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: award.isClaimed
                                ? AppTokens.accent.withValues(alpha: 0.15)
                                : (isDark
                                    ? AppTokens.darkSecondary
                                    : AppTokens.lightSecondary),
                            borderRadius: AppTokens.borderRadiusMd,
                          ),
                          child: Center(
                            child: Text(
                              award.isLocked ? '🔒' : award.emoji,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        const Spacing.horizontal(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                award.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: foregroundColor,
                                ),
                              ),
                              Text(
                                award.desc,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: AppTokens.gold, size: 14),
                                const Spacing.horizontal(2),
                                Text(
                                  '+${award.pts}',
                                  style: GoogleFonts.dmMono(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: award.isClaimed
                                        ? AppTokens.accent
                                        : AppTokens.primary,
                                  ),
                                ),
                              ],
                            ),
                            const Spacing.vertical(4),
                            if (award.isClaimed)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color:
                                      AppTokens.accent.withValues(alpha: 0.15),
                                  borderRadius: AppTokens.borderRadiusFull,
                                ),
                                child: Text(
                                  '✓ Claimed',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTokens.accent,
                                  ),
                                ),
                              )
                            else if (!award.isLocked)
                              GestureDetector(
                                onTap: () => _claimAchievement(index),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTokens.primary,
                                    borderRadius: AppTokens.borderRadiusFull,
                                  ),
                                  child: Text(
                                    'Claim!',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const Spacing.vertical(24),
          ],
        ),
      ),
    );
  }
}
