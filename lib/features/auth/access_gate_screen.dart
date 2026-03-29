import 'package:flutter/material.dart';
import '../../core/state/app_controller.dart';
import '../../core/ui/jert_button.dart';
import '../../core/ui/jert_colors.dart';
import '../../core/ui/jert_panel.dart';
import '../../core/ui/jert_scaffold_background.dart';
import '../wallet/wallet_screen.dart';

class AccessGateScreen extends StatelessWidget {
  final AppController controller;

  const AccessGateScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final canContinue = controller.canUseTerminal;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Access Gate'),
      ),
      extendBodyBehindAppBar: true,
      body: JertScaffoldBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Access verification',
                  style: TextStyle(
                    color: JertColors.textPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your infrastructure access depends on authentication, wallet connection and KYC status.',
                  style: TextStyle(
                    color: JertColors.textSecondary,
                    fontSize: 15,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                _StatusPanel(
                  title: 'Account Status',
                  value:
                      controller.authed ? 'Authenticated' : 'Not authenticated',
                  ok: controller.authed,
                  accent: JertColors.neonCyan,
                ),
                const SizedBox(height: 12),
                _StatusPanel(
                  title: 'Wallet Connection',
                  value: controller.walletConnected
                      ? 'Connected'
                      : 'Not connected',
                  ok: controller.walletConnected,
                  accent: JertColors.glossBlueBottom,
                ),
                const SizedBox(height: 12),
                _StatusPanel(
                  title: 'KYC Status',
                  value: controller.kycStatus.name.toUpperCase(),
                  ok: controller.kycStatus == KycStatus.approved,
                  accent: controller.kycStatus == KycStatus.approved
                      ? JertColors.cold
                      : JertColors.lcng,
                ),
                const SizedBox(height: 18),
                JertPanel(
                  borderColor: JertColors.borderCyan,
                  boxShadow: JertColors.cyanSoftGlow,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: canContinue
                              ? JertColors.neonCyan
                              : JertColors.lcng,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (canContinue
                                      ? JertColors.neonCyan
                                      : JertColors.lcng)
                                  .withValues(alpha: 0.45),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          canContinue
                              ? 'Access granted. You can enter the Authorized Dashboard.'
                              : 'Access not ready yet. Complete all required steps before entering.',
                          style: const TextStyle(
                            color: JertColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                JertPrimaryButton(
                  text: 'Open Authorized Dashboard',
                  onPressed: canContinue
                      ? () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => WalletScreen(
                                controller: controller,
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  final String title;
  final String value;
  final bool ok;
  final Color accent;

  const _StatusPanel({
    required this.title,
    required this.value,
    required this.ok,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return JertPanel(
      borderColor: accent.withValues(alpha: 0.30),
      boxShadow: [
        BoxShadow(
          color: accent.withValues(alpha: 0.10),
          blurRadius: 16,
          spreadRadius: 1,
        ),
      ],
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: accent.withValues(alpha: 0.35)),
            ),
            child: Icon(
              ok ? Icons.check_rounded : Icons.hourglass_bottom_rounded,
              color: accent,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: JertColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: JertColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
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
