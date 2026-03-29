import 'package:flutter/material.dart';
import '../../core/state/app_controller.dart';

class ActivityScreen extends StatelessWidget {
  final AppController controller;

  const ActivityScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final entries = controller.ledgerEntries;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Activity Ledger'),
            backgroundColor: const Color(0xFF0E1620),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/jert_bg_city.webp',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF08111A),
                  ),
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
              if (entries.isEmpty)
                const Center(
                  child: Text(
                    'No ledger entries yet.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                )
              else
                ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: entries.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _LedgerHeaderCard(controller: controller);
                    }

                    final entry = entries[index - 1];
                    return _LedgerEntryCard(entry: entry);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _LedgerHeaderCard extends StatelessWidget {
  final AppController controller;

  const _LedgerHeaderCard({required this.controller});

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
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'JERT Activity Ledger',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Wallet: ${controller.walletAddress}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 6),
            Text(
              'Partner Level: ${controller.partnershipLabel}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _LedgerEntryCard extends StatelessWidget {
  final LedgerEntry entry;

  const _LedgerEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(entry);
    final icon = _entryIcon(entry.type);
    final amountText = _amountText(entry);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xAA121A22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.32)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.10),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(color: accent.withValues(alpha: 0.40)),
                  ),
                  child: Icon(icon, color: accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  amountText,
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _tag(_typeLabel(entry.type), accent),
                _tag(entry.network, Colors.white70),
                _tag(
                    _assetLabel(entry.assetType), _assetColor(entry.assetType)),
                if (entry.terminalId != null)
                  _tag(entry.terminalId!, Colors.white70),
              ],
            ),
            const SizedBox(height: 14),
            _infoRow('Created', _formatDateTime(entry.createdAt)),
            if (entry.txHash != null) _infoRow('TX', entry.txHash!),
          ],
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
            width: 72,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _amountText(LedgerEntry entry) {
    switch (entry.type) {
      case LedgerEntryType.reserve:
      case LedgerEntryType.settle:
      case LedgerEntryType.treasury:
        return '-${entry.amount.toStringAsFixed(2)}';
      case LedgerEntryType.refund:
        return '+${entry.amount.toStringAsFixed(2)}';
    }
  }

  String _typeLabel(LedgerEntryType type) {
    switch (type) {
      case LedgerEntryType.reserve:
        return 'RESERVE';
      case LedgerEntryType.settle:
        return 'SETTLE';
      case LedgerEntryType.refund:
        return 'REFUND';
      case LedgerEntryType.treasury:
        return 'TREASURY';
    }
  }

  IconData _entryIcon(LedgerEntryType type) {
    switch (type) {
      case LedgerEntryType.reserve:
        return Icons.lock_outline;
      case LedgerEntryType.settle:
        return Icons.receipt_long_outlined;
      case LedgerEntryType.refund:
        return Icons.keyboard_return_outlined;
      case LedgerEntryType.treasury:
        return Icons.account_balance_wallet_outlined;
    }
  }

  Color _accentColor(LedgerEntry entry) {
    switch (entry.type) {
      case LedgerEntryType.reserve:
        return _assetColor(entry.assetType);
      case LedgerEntryType.settle:
        return const Color(0xFFFFB347);
      case LedgerEntryType.refund:
        return const Color(0xFF66BB6A);
      case LedgerEntryType.treasury:
        return const Color(0xFFB388FF);
    }
  }

  Color _assetColor(String assetType) {
    switch (assetType) {
      case 'cold':
        return const Color(0xFF2CF6FF);
      case 'lcng':
        return const Color(0xFFFFB347);
      case 'dc':
        return const Color(0xFFB388FF);
      default:
        return Colors.white70;
    }
  }

  String _assetLabel(String assetType) {
    switch (assetType) {
      case 'cold':
        return 'COLD';
      case 'lcng':
        return 'LCNG';
      case 'dc':
        return 'DC';
      default:
        return assetType.toUpperCase();
    }
  }

  String _formatDateTime(DateTime value) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${value.year}-${two(value.month)}-${two(value.day)} '
        '${two(value.hour)}:${two(value.minute)}:${two(value.second)}';
  }
}
