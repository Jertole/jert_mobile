import 'package:flutter/material.dart';
import 'dart:async';
import 'package:app_links/app_links.dart';

import '../../core/state/app_controller.dart';
import '../activity/activity_screen.dart';
import 'modals/terminal_modal.dart';
import '../../core/services/reown_wallet_service.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletScreen extends StatefulWidget {
  final AppController controller;

  const WalletScreen({super.key, required this.controller});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late final ReownWalletService _walletService;

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;
  bool _walletBindingInProgress = false;
  bool _walletStatusLoading = false;
  String? _walletErrorText;

  AppController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _walletService = ReownWalletService();
    _appLinks = AppLinks();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _walletService.init(
        context: context,
        projectId: 'c2a869f1814cf6f72afd2a20da5ca352',
        redirectUrl: 'jertmobile://wc',
        appName: 'JERT Wallet',
        appDescription: 'JERT mobile wallet',
        appUrl: 'https://token.jert.kz',
        appIcons: const ['https://jert.kz/favicon.png'],
      );

      final initialUri = await _appLinks.getInitialLink();
      debugPrint('DEEPLINK initialUri = $initialUri');

      if (initialUri != null && initialUri.scheme == 'jertmobile') {
        await _walletService.dispatchEnvelope(initialUri.toString());
      }

      _linkSub = _appLinks.uriLinkStream.listen((uri) async {
        debugPrint('DEEPLINK stream uri = $uri');

        if (uri.scheme != 'jertmobile') return;

        final link = uri.toString();
        await _walletService.dispatchEnvelope(link);

        if (!mounted) return;
        await _refreshWalletStatus(showLoader: false);
      });

      if (!mounted) return;
      await _refreshWalletStatus(showLoader: false);
    });
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  Future<void> _refreshWalletStatus({bool showLoader = true}) async {
    final token = controller.sessionToken;
    if (token == null || token.isEmpty) {
      return;
    }

    if (showLoader && mounted) {
      setState(() {
        _walletStatusLoading = true;
        _walletErrorText = null;
      });
    }

    try {
      final result = await controller.apiService.fetchWalletStatus(
        bearerToken: token,
      );
      controller.applyWalletStatus(result);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _walletErrorText = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _walletStatusLoading = false;
        });
      }
    }
  }

  Future<void> _connectWallet() async {
    final token = controller.sessionToken;
    if (token == null || token.isEmpty) {
      setState(() {
        _walletErrorText = 'Missing session token.';
      });
      return;
    }

    setState(() {
      _walletBindingInProgress = true;
      _walletErrorText = null;
    });

    try {
      final challenge = await controller.apiService.fetchWalletChallenge(
        bearerToken: token,
      );

      final signed = await _walletService.connectAndSign(
        message: challenge.message,
      );
      debugPrint('JERT signed.walletAddress = ${signed.walletAddress}');
      debugPrint('JERT signed.signature = ${signed.signature}');
      debugPrint('JERT challenge.chain = ${challenge.chain}');
      final bindResult = await controller.apiService.bindWallet(
        bearerToken: token,
        walletAddress: signed.walletAddress.trim().toLowerCase(),
        message: challenge.message,
        signature: signed.signature,
        chain: challenge.chain,
      );

      controller.applyWalletBind(bindResult);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wallet connected and bound successfully.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _walletErrorText = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _walletBindingInProgress = false;
        });
      }
    }
  }

  Future<void> _openBuy() async {
    final url = Uri.parse(
      'https://app.uniswap.org/#/swap?outputCurrency=JERT_TOKEN',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open Buy page');
    }
  }

  Future<void> _openSell() async {
    final url = Uri.parse(
      'https://app.uniswap.org/#/swap?inputCurrency=JERT_TOKEN',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open Sell page');
    }
  }

  Future<void> _openTransferFlow(BuildContext parentContext) async {
    final token = controller.sessionToken;
    if (token == null || token.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(content: Text('Missing session token.')),
      );
      return;
    }

    if (!controller.walletConnected || !controller.hasBoundWallet) {
      if (!mounted) return;
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(content: Text('Connect and bind wallet first.')),
      );
      return;
    }

    final toController = TextEditingController();
    final amountController = TextEditingController(text: '100');

    try {
      final confirmed = await showDialog<bool>(
        context: parentContext,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: const Color(0xFF0B1117),
            title: const Text(
              'Transfer JERT',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: toController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Recipient address',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFF2CF6FF)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Amount JERT',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFF2CF6FF)),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Send'),
              ),
            ],
          );
        },
      );

      if (confirmed != true) {
        return;
      }

      final to = toController.text.trim();
      final amount = amountController.text.trim();

      if (to.isEmpty || amount.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipient and amount are required.')),
        );
        return;
      }

      final payload = await controller.apiService.buildErc20Transfer(
        bearerToken: token,
        to: to,
        amountJert: amount,
      );

      final txHash = await _walletService.sendTransaction(
        to: (payload['to'] ?? '').toString(),
        data: (payload['data'] ?? '0x').toString(),
        value: (payload['value'] ?? '0x0').toString(),
      );

      try {
        await controller.apiService.notifyTxReceipt(
          bearerToken: token,
          txHash: txHash,
        );
      } catch (_) {
        // best effort, same idea as web flow
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transfer sent: ${_short(txHash)}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      toController.dispose();
      amountController.dispose();
    }
  }

  Future<void> _openSettlementFlow(BuildContext parentContext) async {
    final usedController = TextEditingController(text: '500');
    final refundController = TextEditingController(text: '100');

    final result = await showDialog<_SettlementInputResult>(
      context: parentContext,
      builder: (dialogContext) {
        String? errorText;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF10161F),
              title: const Text(
                'Complete Settlement',
                style: TextStyle(color: Colors.white),
              ),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: usedController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Used JERT',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.03),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: refundController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Refund JERT',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.03),
                      ),
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        errorText!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final used = double.tryParse(usedController.text.trim());
                    final refund =
                        double.tryParse(refundController.text.trim());

                    if (used == null || refund == null) {
                      setState(() {
                        errorText = 'Enter valid numeric values.';
                      });
                      return;
                    }

                    if (used < 0 || refund < 0) {
                      setState(() {
                        errorText = 'Values cannot be negative.';
                      });
                      return;
                    }

                    if (used == 0 && refund == 0) {
                      setState(() {
                        errorText =
                            'At least one value must be greater than zero.';
                      });
                      return;
                    }

                    Navigator.of(dialogContext).pop(
                      _SettlementInputResult(used: used, refund: refund),
                    );
                  },
                  child: const Text('Complete'),
                ),
              ],
            );
          },
        );
      },
    );

    usedController.dispose();
    refundController.dispose();

    if (result == null || !parentContext.mounted) return;

    try {
      await controller.mockSettleUsage(
        usedJert: result.used,
        refundJert: result.refund,
      );

      if (!parentContext.mounted) return;
      await _showSettlementReceipt(
        parentContext,
        usedJert: result.used,
        refundJert: result.refund,
      );
    } catch (e) {
      if (!parentContext.mounted) return;
      ScaffoldMessenger.of(parentContext).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  Future<void> _showSettlementReceipt(
    BuildContext parentContext, {
    required double usedJert,
    required double refundJert,
  }) async {
    final tx = controller.lastTerminalTxHash ??
        '0xLEASE${DateTime.now().millisecondsSinceEpoch}';
    final wallet = controller.boundWalletAddress ?? controller.walletAddress;

    await showDialog<void>(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF10161F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
          'Settlement Receipt',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _receiptLine('Wallet', wallet),
              const SizedBox(height: 6),
              _receiptLine('TX', tx),
              const SizedBox(height: 18),
              _receiptLine('Used JERT', usedJert.toStringAsFixed(2)),
              _receiptLine('Refund JERT', refundJert.toStringAsFixed(2)),
              _receiptLine(
                'Reserved balance now',
                controller.balances.reservedJert.toStringAsFixed(2),
              ),
              _receiptLine(
                'Settled total now',
                controller.balances.settledJert.toStringAsFixed(2),
              ),
              _receiptLine(
                'Refunded total now',
                controller.balances.refundedJert.toStringAsFixed(2),
              ),
              const SizedBox(height: 18),
              const Text(
                'Status: settlement completed successfully.',
                style: TextStyle(
                  color: Color(0xFF2CF6FF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(parentContext).push(
                MaterialPageRoute(
                  builder: (_) => ActivityScreen(controller: controller),
                ),
              );
            },
            child: const Text(
              'Open Ledger',
              style: TextStyle(color: Color(0xFF2CF6FF)),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2CF6FF),
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Close',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _receiptLine(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.white70, fontSize: 14),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final balances = controller.balances;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2CF6FF).withValues(alpha: 0.45),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ],
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
                            color: Color(0xFF2CF6FF),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'JERT',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: Color(0xFF2CF6FF),
                    shadows: [Shadow(color: Color(0xAA2CF6FF), blurRadius: 18)],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.receipt_long),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ActivityScreen(controller: controller),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/jert_bg_city.webp',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFF08111A)),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.35),
                        const Color(0xFF060A10).withValues(alpha: 0.82),
                        const Color(0xFF08111A).withValues(alpha: 0.94),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.75),
                        radius: 1.1,
                        colors: [
                          const Color(0xFF2CF6FF).withValues(alpha: 0.10),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    const SizedBox(height: 8),
                    _HeaderGlowCard(controller: controller),
                    const SizedBox(height: 16),
                    _WalletConnectionCard(
                      controller: controller,
                      statusLoading: _walletStatusLoading,
                      bindingInProgress: _walletBindingInProgress,
                      walletErrorText: _walletErrorText,
                      onConnect: _connectWallet,
                      onRefresh: () => _refreshWalletStatus(showLoader: true),
                    ),
                    const SizedBox(height: 16),
                    _BalanceCard(
                      title: 'Available JERT',
                      value: balances.walletJert,
                      subtitle: 'Available for reserve or transfer',
                    ),
                    const SizedBox(height: 12),
                    _BalanceCard(
                      title: 'Reserved JERT',
                      value: balances.reservedJert,
                      subtitle: 'Locked in active reserve / escrow flow',
                    ),
                    const SizedBox(height: 12),
                    _BalanceCard(
                      title: 'Settled JERT',
                      value: balances.settledJert,
                      subtitle: 'Transferred to treasury after measured usage',
                    ),
                    const SizedBox(height: 12),
                    _BalanceCard(
                      title: 'Refunded JERT',
                      value: balances.refundedJert,
                      subtitle: 'Returned after final settlement',
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ActionCard(
                      title: 'Buy',
                      subtitle:
                          'Acquire JERT to access infrastructure services and network capacity.',
                      accentColor: const Color(0xFFB0BEC5),
                      onTap: _openBuy,
                    ),
                    _ActionCard(
                      title: 'Sell',
                      subtitle:
                          'Redeem JERT after infrastructure usage and settlement.',
                      accentColor: const Color(0xFFFFB347),
                      onTap: _openSell,
                    ),
                    _ActionCard(
                      title: 'Transfer',
                      subtitle: 'Send JERT to another wallet.',
                      accentColor: const Color(0xFF66BB6A),
                      onTap: () async {
                        await _openTransferFlow(context);
                      },
                    ),
                    _ActionCard(
                      title: 'Terminal',
                      subtitle:
                          'Reserve infrastructure capacity and initiate escrow settlement.',
                      accentColor: const Color(0xFF2CF6FF),
                      glow: true,
                      onTap: () async {
                        final result = await showModalBottomSheet<bool>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: const Color(0xFF0B1117),
                          builder: (_) => TerminalModal(controller: controller),
                        );

                        if (context.mounted && result == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Reserve created successfully.'),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Settlement',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SettlementCard(
                      controller: controller,
                      onCompleteSettlement: () => _openSettlementFlow(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SettlementInputResult {
  final double used;
  final double refund;

  const _SettlementInputResult({required this.used, required this.refund});
}

class _HeaderGlowCard extends StatelessWidget {
  final AppController controller;

  const _HeaderGlowCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xAA121A22),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2CF6FF).withValues(alpha: 0.12),
            blurRadius: 28,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Partner Level: ${controller.partnershipLabel}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              controller.hasBoundWallet
                  ? 'Bound wallet: ${_short(controller.boundWalletAddress)}'
                  : 'Wallet: ${controller.walletAddress}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 6),
            Text(
              'KYC: ${controller.kycStatus.name.toUpperCase()}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletConnectionCard extends StatelessWidget {
  final AppController controller;
  final bool statusLoading;
  final bool bindingInProgress;
  final String? walletErrorText;
  final VoidCallback onConnect;
  final VoidCallback onRefresh;

  const _WalletConnectionCard({
    required this.controller,
    required this.statusLoading,
    required this.bindingInProgress,
    required this.walletErrorText,
    required this.onConnect,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final connected = controller.hasBoundWallet;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xAA121A22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: connected
              ? const Color(0xFF2CF6FF).withValues(alpha: 0.35)
              : Colors.white.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2CF6FF)
                .withValues(alpha: connected ? 0.14 : 0.08),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Wallet Connection',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (statusLoading)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              connected
                  ? 'Connected: ${controller.boundWalletAddress}'
                  : 'Wallet not connected',
              style: TextStyle(
                color: connected ? const Color(0xFF2CF6FF) : Colors.white70,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Chain: ${controller.walletChain.toUpperCase()}',
              style: const TextStyle(color: Colors.white60),
            ),
            if (walletErrorText != null) ...[
              const SizedBox(height: 12),
              Text(
                walletErrorText!,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _NeonBlueButton(
                    text: bindingInProgress
                        ? 'Connecting...'
                        : connected
                            ? 'Wallet Connected'
                            : 'Connect Wallet',
                    onTap: (bindingInProgress || connected) ? null : onConnect,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 110,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.16),
                      ),
                      backgroundColor: Colors.white.withValues(alpha: 0.03),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: bindingInProgress ? null : onRefresh,
                    child: const Text(
                      'Refresh',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NeonBlueButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const _NeonBlueButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8FE6FF), Color(0xFF34D3FF)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF34D3FF).withValues(alpha: 0.45),
              blurRadius: 14,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 10,
              right: 10,
              top: 6,
              child: Container(
                height: 14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.55),
                      Colors.white.withValues(alpha: 0.10),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onTap,
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: onTap == null ? Colors.black54 : Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String title;
  final double value;
  final String subtitle;

  const _BalanceCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xAA121A22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(
              value.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: Colors.white60)),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color accentColor;
  final bool glow;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.accentColor,
    this.glow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xAA121A22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withValues(alpha: 0.32)),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.12),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: ListTile(
        leading: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: accentColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.45),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        title: Text(
          title,
          style: TextStyle(color: accentColor, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing: Icon(Icons.chevron_right, color: accentColor),
        onTap: onTap,
      ),
    );
  }
}

class _SettlementCard extends StatelessWidget {
  final AppController controller;
  final VoidCallback onCompleteSettlement;

  const _SettlementCard({
    required this.controller,
    required this.onCompleteSettlement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xAA121A22),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: const Color(0xFF34D3FF).withValues(alpha: 0.30)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF34D3FF).withValues(alpha: 0.10),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Complete reserve settlement and open receipt.',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.lastTerminalTxHash == null
                  ? 'No active reserve yet.'
                  : 'Last lease tx: ${controller.lastTerminalTxHash}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 14),
            _NeonBlueButton(
              text: 'Complete Settlement',
              onTap: controller.balances.reservedJert > 0
                  ? onCompleteSettlement
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

String _short(String? addr) {
  if (addr == null || addr.length < 10) return addr ?? '';
  return '${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}';
}
