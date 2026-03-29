import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/api_service.dart';
import '../../core/state/app_controller.dart';
import '../../core/ui/jert_button.dart';
import '../../core/ui/jert_colors.dart';
import '../../core/ui/jert_panel.dart';
import '../../core/ui/jert_scaffold_background.dart';
import '../wallet/wallet_screen.dart';
import 'kyc_rejected_screen.dart';
import 'welcome_screen.dart';

class KycPendingScreen extends StatefulWidget {
  final AppController controller;
  final String email;

  const KycPendingScreen({
    super.key,
    required this.controller,
    required this.email,
  });

  @override
  State<KycPendingScreen> createState() => _KycPendingScreenState();
}

class _KycPendingScreenState extends State<KycPendingScreen> {
  bool loading = false;
  String statusText = 'UNDER REVIEW';
  String? errorText;

  Timer? _pollTimer;
  bool _redirecting = false;

  @override
  void initState() {
    super.initState();
    _refreshStatus(showLoader: false);
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!_redirecting) {
        _refreshStatus(showLoader: false);
      }
    });
  }

  Future<void> _refreshStatus({bool showLoader = true}) async {
    final token = widget.controller.sessionToken;
    if (token == null || token.isEmpty) {
      if (!mounted) return;
      setState(() {
        errorText = 'Missing session token.';
        loading = false;
      });
      return;
    }

    if (showLoader && mounted) {
      setState(() {
        loading = true;
        errorText = null;
      });
    } else if (mounted) {
      setState(() {
        errorText = null;
      });
    }

    try {
      final kycResult = await widget.controller.apiService.fetchKycStatus(
        bearerToken: token,
      );

      widget.controller.applyKycStatus(kycResult.status);

      if (!mounted) return;

      setState(() {
        statusText = _statusLabel(kycResult.status);
      });

      if (kycResult.status == KycReviewStatus.approved) {
        await _openAuthorizedDashboard();
        return;
      }

      if (kycResult.status == KycReviewStatus.rejected) {
        await _openRejectedScreen();
        return;
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorText = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted && showLoader) {
        setState(() {
          loading = false;
        });
      } else if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> _openAuthorizedDashboard() async {
    if (_redirecting) return;
    _redirecting = true;
    _pollTimer?.cancel();

    final token = widget.controller.sessionToken;
    if (token == null || token.isEmpty) return;

    try {
      final summary = await widget.controller.apiService.fetchSummary(
        bearerToken: token,
      );

      widget.controller.applySummary(summary);
      widget.controller.updateAccessState(
        authed: true,
        walletConnected: false,
        kycStatus: KycStatus.approved,
      );

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => WalletScreen(controller: widget.controller),
        ),
        (route) => false,
      );
    } catch (e) {
      _redirecting = false;
      if (!mounted) return;
      setState(() {
        errorText = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _openRejectedScreen() async {
    if (_redirecting) return;
    _redirecting = true;
    _pollTimer?.cancel();

    widget.controller.updateAccessState(
      authed: true,
      walletConnected: false,
      kycStatus: KycStatus.rejected,
    );

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => KycRejectedScreen(controller: widget.controller),
      ),
      (route) => false,
    );
  }

  String _statusLabel(KycReviewStatus status) {
    switch (status) {
      case KycReviewStatus.underReview:
        return 'UNDER REVIEW';
      case KycReviewStatus.approved:
        return 'APPROVED';
      case KycReviewStatus.rejected:
        return 'REJECTED';
      case KycReviewStatus.unknown:
        return 'UNKNOWN';
    }
  }

  Color _statusColor(KycReviewStatus status) {
    switch (status) {
      case KycReviewStatus.underReview:
        return const Color(0xFFFF4D4F);
      case KycReviewStatus.approved:
        return JertColors.neonCyan;
      case KycReviewStatus.rejected:
        return const Color(0xFFFF6B6B);
      case KycReviewStatus.unknown:
        return JertColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStatus = widget.controller.kycStatus == KycStatus.approved
        ? KycReviewStatus.approved
        : widget.controller.kycStatus == KycStatus.rejected
            ? KycReviewStatus.rejected
            : KycReviewStatus.underReview;

    final statusColor = _statusColor(currentStatus);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('KYC Review'),
      ),
      extendBodyBehindAppBar: true,
      body: JertScaffoldBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'KYC request submitted',
                  style: TextStyle(
                    color: JertColors.textPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your access request is being reviewed.',
                  style: TextStyle(
                    color: JertColors.textSecondary,
                    fontSize: 15,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                JertPanel(
                  borderColor: statusColor.withValues(alpha: 0.45),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.18),
                      blurRadius: 18,
                      spreadRadius: 0,
                    ),
                  ],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current status',
                        style: TextStyle(
                          color: JertColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _infoRow('Email', widget.email),
                      _infoRow(
                        'Session',
                        widget.controller.sessionToken == null
                            ? 'missing'
                            : 'active',
                      ),
                    ],
                  ),
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    errorText!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                JertPrimaryButton(
                  text: loading ? 'Refreshing...' : 'Refresh Status',
                  onPressed:
                      loading ? null : () => _refreshStatus(showLoader: true),
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
                    onPressed: () async {
                      final navigator = Navigator.of(context);

                      _pollTimer?.cancel();
                      await widget.controller.clearPersistedSession();
                      widget.controller.clearSessionState();

                      if (!mounted) return;

                      navigator.pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => WelcomeScreen(
                            controller: widget.controller,
                          ),
                        ),
                        (route) => false,
                      );
                    },
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: JertColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: JertColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
