import 'package:flutter/material.dart';
import '../../core/state/app_controller.dart';
import '../../core/ui/jert_scaffold_background.dart';
import '../../core/ui/jert_button.dart';
import '../../core/ui/jert_colors.dart';
import '../../core/ui/jert_panel.dart';
import 'auth_screen.dart';
import '../legal/legal_consent_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final AppController controller;

  const WelcomeScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JertScaffoldBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: JertColors.cyanSoftGlow,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/jert_logo_neon.webp',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0x22121212),
                            alignment: Alignment.center,
                            child: const Text(
                              'J',
                              style: TextStyle(
                                color: JertColors.neonCyan,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'JERT',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                        color: JertColors.neonCyan,
                        shadows: [
                          Shadow(
                            color: Color(0xAA2CF6FF),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  'Authorized access to infrastructure',
                  style: TextStyle(
                    fontSize: 34,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                    color: JertColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Cold terminals, LCNG stations, data-center nodes and treasury settlement through the JERT network.',
                  style: TextStyle(
                    color: JertColors.textSecondary,
                    fontSize: 16,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                const JertPanel(
                  padding: EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Access flow',
                        style: TextStyle(
                          color: JertColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Create account or sign in\n'
                        '2. Complete access profile\n'
                        '3. Connect wallet\n'
                        '4. Enter Authorized Dashboard',
                        style: TextStyle(
                          color: JertColors.textSecondary,
                          height: 1.5,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                JertPrimaryButton(
                  text: 'Create Account',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LegalConsentScreen(
                          controller: controller,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: JertColors.textPrimary,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                      backgroundColor: Colors.white.withValues(alpha: 0.03),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AuthScreen(
                            controller: controller,
                            mode: AuthMode.signIn,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
