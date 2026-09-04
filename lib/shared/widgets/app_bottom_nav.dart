import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/tokens.dart';

enum AppTab { home, activity, pay, rewards, settings }

class AppBottomNav extends StatelessWidget {
  final bool isParent;
  final AppTab currentTab;
  final ValueChanged<AppTab> onTabSelected;

  const AppBottomNav({
    super.key,
    required this.isParent,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTokens.darkCard : AppTokens.lightCard;
    final borderColor = isDark ? AppTokens.darkBorder : AppTokens.lightBorder;
    final mutedForeground =
        isDark ? AppTokens.darkMutedForeground : AppTokens.lightMutedForeground;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom
            : 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: isParent
            ? [
                _NavButton(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: currentTab == AppTab.home,
                  onTap: () => onTabSelected(AppTab.home),
                  mutedColor: mutedForeground,
                ),
                _NavButton(
                  icon: Icons.receipt_long_rounded,
                  label: 'Activity',
                  isSelected: currentTab == AppTab.activity,
                  onTap: () => onTabSelected(AppTab.activity),
                  mutedColor: mutedForeground,
                ),
                _NavButton(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  isSelected: currentTab == AppTab.settings,
                  onTap: () => onTabSelected(AppTab.settings),
                  mutedColor: mutedForeground,
                ),
              ]
            : [
                _NavButton(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: currentTab == AppTab.home,
                  onTap: () => onTabSelected(AppTab.home),
                  mutedColor: mutedForeground,
                ),
                // Prominent Elevated Center Pay Button
                _CenterPayNavButton(
                  isSelected: currentTab == AppTab.pay,
                  onTap: () => onTabSelected(AppTab.pay),
                ),
                _NavButton(
                  icon: Icons.star_rounded,
                  label: 'Rewards',
                  isSelected: currentTab == AppTab.rewards,
                  onTap: () => onTabSelected(AppTab.rewards),
                  mutedColor: mutedForeground,
                ),
                _NavButton(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  isSelected: currentTab == AppTab.settings,
                  onTap: () => onTabSelected(AppTab.settings),
                  mutedColor: mutedForeground,
                ),
              ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color mutedColor;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTokens.primary.withValues(alpha: 0.18)
                    : Colors.transparent,
                borderRadius: AppTokens.borderRadiusLg,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppTokens.primary : mutedColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTokens.primary : mutedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterPayNavButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _CenterPayNavButton({
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Transform.translate(
        offset: const Offset(0, -14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C3AFF), Color(0xFF00D4A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTokens.primary.withValues(alpha: 0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pay',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? AppTokens.primary
                    : AppTokens.darkMutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
