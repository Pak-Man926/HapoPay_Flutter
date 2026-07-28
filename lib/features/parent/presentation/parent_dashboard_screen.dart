import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/action_card.dart';
import '../../auth/providers/auth_provider.dart';

import '../../../shared/widgets/theme_toggle.dart';

class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider.select((s) => s.user));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: ThemeToggle(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user?.fullName ?? 'Parent'}',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your family accounts',
              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 32),
            ActionCard(
              title: 'Family Ledger',
              subtitle: 'View all student transactions',
              icon: Icons.history,
              onTap: () => context.push('/parent/ledger'),
            ),
            const SizedBox(height: 16),
            ActionCard(
              title: 'Spending Limits',
              subtitle: 'Set daily and weekly caps',
              icon: Icons.speed,
              onTap: () => context.push('/parent/limits'),
            ),
            const SizedBox(height: 16),
            ActionCard(
              title: 'Card Lock',
              subtitle: 'Suspend payment capabilities',
              icon: Icons.lock_outline,
              onTap: () => context.push('/parent/limits'),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
