import 'package:flutter/material.dart';
import '../../core/state/app_controller.dart';
import '../../core/ui/jert_colors.dart';
import '../../core/ui/jert_panel.dart';
import '../../core/ui/jert_scaffold_background.dart';

class KycRejectedScreen extends StatelessWidget {
  final AppController controller;
  final String? reason;

  const KycRejectedScreen({
    super.key,
    required this.controller,
    this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('KYC Rejected'),
      ),
      extendBodyBehindAppBar: true,
      body: JertScaffoldBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Access request rejected',
                  style: TextStyle(
                    color: JertColors.textPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your infrastructure access request was rejected during manual compliance review.',
                  style: TextStyle(
                    color: JertColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                JertPanel(
                  borderColor: Colors.redAccent.withValues(alpha: 0.4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          color: JertColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'REJECTED',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        reason == null || reason!.trim().isEmpty
                            ? 'No additional reason provided yet.'
                            : reason!,
                        style: const TextStyle(
                          color: JertColors.textPrimary,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
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
                    child: const Text(
                      'Back to Start',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
