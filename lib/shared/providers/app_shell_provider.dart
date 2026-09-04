import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/entities/app_user.dart';
import '../widgets/app_bottom_nav.dart';

class AppRoleNotifier extends Notifier<UserRole> {
  @override
  UserRole build() => UserRole.parent;

  void setRole(UserRole role) {
    state = role;
  }

  void toggleRole() {
    state = state == UserRole.parent ? UserRole.student : UserRole.parent;
  }
}

final appRoleProvider =
    NotifierProvider<AppRoleNotifier, UserRole>(AppRoleNotifier.new);

class ActiveTabNotifier extends Notifier<AppTab> {
  @override
  AppTab build() => AppTab.home;

  void setTab(AppTab tab) {
    state = tab;
  }
}

final activeTabProvider =
    NotifierProvider<ActiveTabNotifier, AppTab>(ActiveTabNotifier.new);
