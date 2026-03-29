import 'package:flutter/material.dart';

import '../../core/state/app_controller.dart';
import '../../core/ui/jert_button.dart';
import '../../core/ui/jert_colors.dart';
import '../auth/auth_screen.dart';

import 'legal_position_screen.dart';
import 'terms_of_use_screen.dart';
import 'privacy_policy_screen.dart';
import 'tokenomics_screen.dart';

class LegalConsentScreen extends StatefulWidget {
  final AppController controller;

  const LegalConsentScreen({
    super.key,
    required this.controller,
  });

  @override
  State<LegalConsentScreen> createState() => _LegalConsentScreenState();
}

class _LegalConsentScreenState extends State<LegalConsentScreen> {
  bool _confirmed = false;

  void _openLegalPosition() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LegalPositionScreen(),
      ),
    );
  }

  void _openTermsOfUse() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const TermsOfUseScreen(),
      ),
    );
  }

  void _openPrivacyPolicy() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PrivacyPolicyScreen(),
      ),
    );
  }

  void _openTokenomics() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const TokenomicsScreen(),
      ),
    );
  }

  void _continueToRegister() {
    if (!_confirmed) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AuthScreen(
          controller: widget.controller,
          mode: AuthMode.register,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/jert_legal_bg.webp',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.78),
                  Colors.black.withValues(alpha: 0.65),
                  Colors.black.withValues(alpha: 0.72),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color:
                                  JertColors.neonCyan.withValues(alpha: 0.35),
                            ),
                            color: JertColors.neonCyan.withValues(alpha: 0.08),
                          ),
                          child: Text(
                            'LEGAL CONFIRMATION',
                            style: TextStyle(
                              color: JertColors.neonCyan,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Review legal documents before registration',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.08,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Before creating an account, please review the legal documents related to the JERT wallet and infrastructure access.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.78),
                            fontSize: 15,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _LegalActionButton(
                          title: 'Legal',
                          onPressed: _openLegalPosition,
                        ),
                        const SizedBox(height: 12),
                        _LegalActionButton(
                          title: 'Terms of Use',
                          onPressed: _openTermsOfUse,
                        ),
                        const SizedBox(height: 12),
                        _LegalActionButton(
                          title: 'Privacy Policy',
                          onPressed: _openPrivacyPolicy,
                        ),
                        const SizedBox(height: 12),
                        _LegalActionButton(
                          title: 'Tokenomics',
                          onPressed: _openTokenomics,
                        ),
                        const SizedBox(height: 22),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.10),
                            ),
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _confirmed,
                                activeColor: JertColors.neonCyan,
                                checkColor: Colors.black,
                                side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.45),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _confirmed = value ?? false;
                                  });
                                },
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'I confirm that I have reviewed the Legal, Terms of Use, Privacy Policy and Tokenomics documents and agree to proceed to registration.',
                                    style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.90),
                                      fontSize: 14,
                                      height: 1.45,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(54),
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.22),
                                  ),
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.04),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: JertPrimaryButton(
                                text: 'Continue',
                                onPressed:
                                    _confirmed ? _continueToRegister : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _LegalActionButton({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: JertColors.neonCyan.withValues(alpha: 0.50),
          ),
          backgroundColor: JertColors.neonCyan.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: JertColors.neonCyan,
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
