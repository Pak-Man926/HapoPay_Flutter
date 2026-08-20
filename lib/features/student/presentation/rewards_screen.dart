/// rewards_screen.dart
/// Full-page Student Rewards UI — tiers, progress, achievements, streaks.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hapopay/core/constants/constants.dart';
import '../models/reward_model.dart';
import '../models/rewards_catalog.dart';
import '../providers/rewards_provider.dart';
import 'reward_theme.dart';

IconData _iconFromString(String name) {
  const map = {
    'payment': Icons.payment,
    'savings': Icons.savings,
    'qr_code_scanner': Icons.qr_code_scanner,
    'local_fire_department': Icons.local_fire_department,
    'account_balance_wallet': Icons.account_balance_wallet,
    'share': Icons.share,
    'emoji_events': Icons.emoji_events,
    'star': Icons.star,
    'school': Icons.school,
    'shopping_cart': Icons.shopping_cart,
  };
  return map[name] ?? Icons.emoji_events;
}

class RewardsScreen extends ConsumerStatefulWidget {
  const RewardsScreen({super.key});

  @override
  ConsumerState<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends ConsumerState<RewardsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heroController;
  late final Animation<double> _heroFade;
  String? _claimingId;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _heroFade = CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOutCubic,
    );
    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  Future<void> _onClaim(AchievementModel achievement) async {
    if (_claimingId != null) return;
    setState(() => _claimingId = achievement.id);
    try {
      await ref.read(rewardsProvider.notifier).claimAchievement(achievement.id);
      if (!mounted) return;
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Claimed ${achievement.name} (+${achievement.points} pts)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not claim: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _claimingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rewardsAsync = ref.watch(rewardsProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Rewards',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => ref.read(rewardsProvider.notifier).refresh(),
          ),
        ],
      ),
      body: rewardsAsync.when(
        loading: () => const _LoadingSkeleton(),
        error: (e, _) => _ErrorBody(
          onRetry: () => ref.read(rewardsProvider.notifier).refresh(),
        ),
        data: (reward) => RefreshIndicator(
          color: rewardTierColors[reward.tier] ?? Colors.amber,
          onRefresh: () => ref.read(rewardsProvider.notifier).refresh(),
          child: FadeTransition(
            opacity: _heroFade,
            child: _RewardsBody(
              reward: reward,
              claimingId: _claimingId,
              onClaim: _onClaim,
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardsBody extends StatelessWidget {
  final RewardModel reward;
  final String? claimingId;
  final Future<void> Function(AchievementModel) onClaim;

  const _RewardsBody({
    required this.reward,
    required this.claimingId,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final achievements = reward.achievements;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: _HeroCard(reward: reward),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: _StreakPanel(streakDays: reward.streakDays),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
            child: _TierLadder(currentTier: reward.tier),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: _StatsRow(reward: reward),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 32, 20, 16),
            child: _SectionHeader(
              title: 'Achievements',
              subtitle: 'Complete goals to earn points',
            ),
          ),
        ),
        if (achievements.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: _EmptyAchievements(),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _AchievementCard(
                  achievement: achievements[i],
                  claiming: claimingId == achievements[i].id,
                  onClaim: () => onClaim(achievements[i]),
                ),
                childCount: achievements.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.78,
              ),
            ),
          ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  final RewardModel reward;

  const _HeroCard({required this.reward});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onHero = Colors.white;
    final gradientColors = rewardTierGradients[reward.tier] ??
        [Colors.purple, Colors.purpleAccent];
    final progress = reward.tierProgressFraction;
    final nextPoints = reward.nextMilestonePoints;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(reward.tier.badge,
                        style: const TextStyle(fontSize: 16)),
                    horizontalSpaceTiny,
                    Text(
                      reward.tier.label,
                      style: TextStyle(
                        color: onHero,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        shadows: theme.brightness == Brightness.light
                            ? const [
                                Shadow(blurRadius: 2, color: Colors.black26),
                              ]
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpaceLarge,
          Text(
            'Total Points',
            style: TextStyle(
              color: onHero.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          verticalSpaceTiny,
          Text(
            '${reward.totalPoints}',
            style: TextStyle(
              color: onHero,
              fontSize: 48,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          verticalSpaceTiny,
          Text(
            'pts',
            style: TextStyle(
              color: onHero.withValues(alpha: 0.75),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          verticalSpaceLarge,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nextPoints != null
                        ? 'Next tier in ${nextPoints - reward.totalPoints} pts'
                        : 'Max tier reached!',
                    style: TextStyle(color: onHero, fontSize: 12),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      color: onHero,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              verticalSpaceSmall,
              _AnimatedProgressBar(
                value: progress,
                backgroundColor: Colors.white24,
                foregroundColor: Colors.white,
                height: 8,
                borderRadius: 4,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StreakPanel extends StatelessWidget {
  final int streakDays;

  const _StreakPanel({required this.streakDays});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final filledDots = streakDays.clamp(0, 7);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                color:
                    streakDays > 0 ? Colors.deepOrangeAccent : scheme.outline,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      streakDays > 0
                          ? '$streakDays-day streak'
                          : 'No active streak',
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Stay under budget to keep the fire going',
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.55),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final filled = i < filledDots;
              return Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? Colors.deepOrangeAccent
                          : scheme.surfaceContainerHighest,
                      border: Border.all(
                        color: filled
                            ? Colors.deepOrangeAccent
                            : scheme.outlineVariant,
                      ),
                    ),
                    child: filled
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'D${i + 1}',
                    style: TextStyle(
                      fontSize: 9,
                      color: scheme.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: RewardsCatalog.streakMilestones.map((m) {
              final reached = streakDays >= m;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: reached
                      ? Colors.deepOrangeAccent.withValues(alpha: 0.15)
                      : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: reached
                        ? Colors.deepOrangeAccent.withValues(alpha: 0.4)
                        : scheme.outlineVariant,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      reached
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked,
                      size: 14,
                      color: reached
                          ? Colors.deepOrangeAccent
                          : scheme.onSurface.withValues(alpha: 0.35),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$m days',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: reached
                            ? Colors.deepOrangeAccent
                            : scheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TierLadder extends StatelessWidget {
  final RewardTier currentTier;

  const _TierLadder({
    required this.currentTier,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const tiers = RewardTier.values;
    final currentIndex = tiers.indexOf(currentTier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          title: 'Tier Progress',
          subtitle: 'Point bands from Bronze to Platinum',
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(tiers.length, (i) {
            final tier = tiers[i];
            final isActive = i == currentIndex;
            final isUnlocked = i <= currentIndex;
            final color = rewardTierColors[tier] ?? Colors.grey;
            final range = RewardsCatalog.rangeLabel(tier);

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? color.withValues(alpha: 0.2)
                            : isUnlocked
                                ? color.withValues(alpha: 0.08)
                                : scheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isActive
                              ? color
                              : isUnlocked
                                  ? color.withValues(alpha: 0.3)
                                  : scheme.outlineVariant,
                          width: isActive ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            tier.badge,
                            style: TextStyle(fontSize: isActive ? 20 : 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tier.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isActive
                                  ? color
                                  : isUnlocked
                                      ? color.withValues(alpha: 0.85)
                                      : scheme.onSurface
                                          .withValues(alpha: 0.35),
                              fontSize: 10,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            range,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: scheme.onSurface.withValues(alpha: 0.45),
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (i < tiers.length - 1)
                    Icon(
                      Icons.chevron_right,
                      color: isUnlocked
                          ? color.withValues(alpha: 0.5)
                          : scheme.outlineVariant,
                      size: 16,
                    ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final RewardModel reward;

  const _StatsRow({required this.reward});

  @override
  Widget build(BuildContext context) {
    final total = reward.achievements.length;
    final earned = reward.earnedAchievementsCount;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.emoji_events_rounded,
            iconColor: Colors.amber,
            label: 'Achievements',
            value: '$earned / $total',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: Colors.deepOrangeAccent,
            label: 'Day Streak',
            value: '${reward.streakDays}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.workspace_premium_rounded,
            iconColor: rewardTierColors[reward.tier] ?? Colors.grey,
            label: 'Tier',
            value: reward.tier.label,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final AchievementModel achievement;
  final bool claiming;
  final VoidCallback onClaim;

  const _AchievementCard({
    required this.achievement,
    required this.claiming,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isEarned = achievement.earned;
    final isClaimed = achievement.claimed;
    final canClaim = isEarned && !isClaimed;
    final progress = achievement.progressFraction;
    final accent = isEarned ? const Color(0xFFFFD700) : scheme.outline;
    final cardBg = isEarned
        ? Color.alphaBlend(
            accent.withValues(alpha: 0.12),
            scheme.surface,
          )
        : scheme.surface;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isEarned ? accent.withValues(alpha: 0.45) : scheme.outlineVariant,
          width: isEarned ? 1.5 : 1,
        ),
        boxShadow: isEarned
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.12),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isEarned
                        ? accent.withValues(alpha: 0.15)
                        : scheme.onSurface.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _iconFromString(achievement.icon),
                    color: isEarned
                        ? accent
                        : scheme.onSurface.withValues(alpha: 0.35),
                    size: 22,
                  ),
                ),
                if (claiming)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: accent,
                    ),
                  )
                else if (canClaim)
                  GestureDetector(
                    onTap: onClaim,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Claim',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else if (isClaimed)
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green.shade400,
                    size: 20,
                  )
                else
                  Icon(
                    Icons.lock_rounded,
                    color: scheme.onSurface.withValues(alpha: 0.25),
                    size: 18,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              achievement.name,
              style: TextStyle(
                color: isEarned
                    ? scheme.onSurface
                    : scheme.onSurface.withValues(alpha: 0.55),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              achievement.description,
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.45),
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (achievement.hasProgress && !isEarned) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${achievement.progress} / ${achievement.goal}',
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.45),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '${((progress ?? 0) * 100).toInt()}%',
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.55),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              _AnimatedProgressBar(
                value: progress ?? 0,
                backgroundColor: scheme.onSurface.withValues(alpha: 0.08),
                foregroundColor: scheme.primary,
                height: 5,
                borderRadius: 3,
              ),
            ],
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isEarned
                    ? accent.withValues(alpha: 0.1)
                    : scheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bolt,
                    size: 12,
                    color: isEarned
                        ? accent
                        : scheme.onSurface.withValues(alpha: 0.35),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '+${achievement.points} pts',
                    style: TextStyle(
                      color: isEarned
                          ? accent
                          : scheme.onSurface.withValues(alpha: 0.35),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyAchievements extends StatelessWidget {
  const _EmptyAchievements();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(Icons.emoji_events_outlined, size: 40, color: scheme.outline),
          const SizedBox(height: 12),
          Text(
            'No achievements yet',
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Make payments and stay on budget to unlock badges.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.55),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedProgressBar extends StatefulWidget {
  final double value;
  final Color backgroundColor;
  final Color foregroundColor;
  final double height;
  final double borderRadius;

  const _AnimatedProgressBar({
    required this.value,
    required this.backgroundColor,
    required this.foregroundColor,
    this.height = 8,
    this.borderRadius = 4,
  });

  @override
  State<_AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<_AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _anim = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(_AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _anim = Tween<double>(
        begin: _anim.value,
        end: widget.value,
      ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: LinearProgressIndicator(
          value: _anim.value,
          backgroundColor: widget.backgroundColor,
          valueColor: AlwaysStoppedAnimation(widget.foregroundColor),
          minHeight: widget.height,
        ),
      ),
    );
  }
}

class _LoadingSkeleton extends StatefulWidget {
  const _LoadingSkeleton();

  @override
  State<_LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<_LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _box({double height = 20, double? width, double radius = 10}) {
    final base = Theme.of(context).colorScheme.onSurface;
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: base.withValues(alpha: _anim.value * 0.12),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(height: 180, radius: 28),
          const SizedBox(height: 24),
          _box(height: 120, radius: 20),
          const SizedBox(height: 24),
          _box(height: 16, width: 140),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _box(height: 90, radius: 12)),
              const SizedBox(width: 8),
              Expanded(child: _box(height: 90, radius: 12)),
              const SizedBox(width: 8),
              Expanded(child: _box(height: 90, radius: 12)),
              const SizedBox(width: 8),
              Expanded(child: _box(height: 90, radius: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorBody({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: scheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                color: scheme.error,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Could not load rewards',
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.55),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            color: scheme.onSurface.withValues(alpha: 0.55),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
