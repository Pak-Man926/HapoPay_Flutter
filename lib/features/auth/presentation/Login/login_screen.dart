import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapopay/core/constants/constants.dart';
import 'package:hapopay/features/auth/presentation/Login/widgets/role_tab.dart';
import 'package:hapopay/features/auth/presentation/Login/widgets/social_button.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/hapo_pay_logo.dart';
import '../../../../shared/widgets/theme_toggle.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.parent;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _localError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRoleChanged(UserRole newRole) {
    setState(() {
      _selectedRole = newRole;
      if (newRole == UserRole.parent) {
        _emailController.text;
      } else {
        _emailController.text;
      }
    });
  }

  Future<void> _handleLogin() async {
    // -------------------------------------------------------------------------
    // REAL BACKEND AUTHENTICATION (Uncomment when ready to connect to API)
    // -------------------------------------------------------------------------
    /*
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _localError = 'Please enter your email and password.';
      });
      return;
    }

    setState(() {
      _localError = null;
    });

    await ref.read(authProvider.notifier).login(email, password);

    if (!mounted) return;

    final authState = ref.read(authProvider);
    if (authState.isAuthenticated) {
      context.go(authState.user?.isParent == true ? '/parent' : '/student');
    } else if (authState.errorMessage != null) {
      setState(() {
        _localError = authState.errorMessage;
      });
    }
    */

    // -------------------------------------------------------------------------
    // DIRECT UI PREVIEW BYPASS
    // -------------------------------------------------------------------------
    setState(() {
      _isLoading = true;
      _localError = null;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (_selectedRole == UserRole.parent) {
      context.go('/parent');
    } else {
      context.go('/student');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final isLoading = ref.watch(authProvider.select((s) => s.isLoading)); // Real auth loading state
    final isLoading = _isLoading;

    final backgroundColor =
        isDark ? AppTokens.darkBackground : AppTokens.lightBackground;
    final foregroundColor =
        isDark ? AppTokens.darkForeground : AppTokens.lightForeground;
    final mutedForeground =
        isDark ? AppTokens.darkMutedForeground : AppTokens.lightMutedForeground;
    final cardColor = isDark ? AppTokens.darkCard : AppTokens.lightCard;
    final borderColor = isDark ? AppTokens.darkBorder : AppTokens.lightBorder;
    final secondaryBg =
        isDark ? AppTokens.darkSecondary : AppTokens.lightSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Top ambient radial gradient glow
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.3, -0.8),
                    radius: 1.0,
                    colors: [
                      AppTokens.primary.withValues(alpha: isDark ? 0.22 : 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Row: Theme Toggle
                  Align(
                    alignment: Alignment.topRight,
                    child: ThemeToggle(),
                  ),

                  const Spacing.vertical(12),

                  // Logo & Heading
                  Center(
                    child: Column(
                      children: [
                        //Logo
                        const HapoPayLogo(size: 68),
                        const Spacing.vertical(16),
                        Text(
                          'Welcome back',
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: foregroundColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacing.vertical(4),
                        Text(
                          'Sign in to your HapoPay account',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacing.vertical(28),

                  // Role selector tabs (Parent / Student)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: secondaryBg,
                      borderRadius: AppTokens.borderRadiusLg,
                    ),
                    child: Row(
                      children: [
                        RoleTab(
                          label: 'Parent',
                          emoji: '👤',
                          isSelected: _selectedRole == UserRole.parent,
                          onTap: () => _onRoleChanged(UserRole.parent),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 4),
                        RoleTab(
                          label: 'Student',
                          emoji: '🎒',
                          isSelected: _selectedRole == UserRole.student,
                          onTap: () => _onRoleChanged(UserRole.student),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),

                  const Spacing.vertical(24),

                  // Form Fields
                  // Email Field
                  Text(
                    'EMAIL',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: mutedForeground,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacing.vertical(6),
                  //Email textfield
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: foregroundColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'you@example.com',
                      prefixIcon: Icon(
                        Icons.mail_outline_rounded,
                        color: mutedForeground,
                        size: 20,
                      ),
                    ),
                  ),

                  const Spacing.vertical(18),

                  // Password Field
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PASSWORD',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: mutedForeground,
                          letterSpacing: 0.5,
                        ),
                      ),
                      //Forgot password prompt
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Password reset instructions sent to email.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot your password?',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTokens.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacing.vertical(6),
                  //Password textfield
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleLogin(),
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: foregroundColor,
                    ),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: mutedForeground,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: mutedForeground,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),

                  // Error Message Banner (if any)
                  if (_localError != null) ...[
                    const Spacing.vertical(14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTokens.warning.withValues(alpha: 0.12),
                        borderRadius: AppTokens.borderRadiusMd,
                        border: Border.all(
                          color: AppTokens.warning.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              color: AppTokens.warning, size: 18),
                          const Spacing.horizontal(8),
                          Expanded(
                            child: Text(
                              _localError!,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppTokens.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Spacing.vertical(22),

                  // Sign In CTA Button
                  AppPrimaryButton(
                    label: 'Sign In',
                    isLoading: isLoading,
                    onPressed: _handleLogin,
                  ),

                  const Spacing.vertical(24),

                  // Divider ("or continue with")
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: borderColor, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'or continue with',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: mutedForeground,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: borderColor, thickness: 1),
                      ),
                    ],
                  ),

                  const Spacing.vertical(20),

                  // Social Auth Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SocialButton(
                          icon: SvgPicture.asset(
                            "assets/svg/google.svg",
                            height: 20,
                            width: 20,
                          ),
                          label: 'Google',
                          cardColor: cardColor,
                          borderColor: borderColor,
                          foregroundColor: foregroundColor,
                          onTap: _handleLogin,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SocialButton(
                          icon: Icon(
                            Icons.apple,
                            size: 22,
                            color: foregroundColor, // Matches the text color
                          ),
                          label: 'Apple',
                          cardColor: cardColor,
                          borderColor: borderColor,
                          foregroundColor: foregroundColor,
                          onTap: _handleLogin,
                        ),
                      ),
                    ],
                  ),

                  const Spacing.vertical(32),

                  // Footer Link to Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: mutedForeground,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/register'),
                        child: Text(
                          'Sign up',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTokens.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacing.vertical(16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
