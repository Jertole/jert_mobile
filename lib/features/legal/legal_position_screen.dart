import 'package:flutter/material.dart';

import '../../core/ui/jert_colors.dart';

class LegalPositionScreen extends StatelessWidget {
  const LegalPositionScreen({super.key});

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
                            'LEGAL POSITION',
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
                          'Infrastructure first. Financial logic excluded.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.08,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'JERT is structured as a tokenized infrastructure capacity unit supporting coordination within the Green Cold Energy Network. Its purpose is operational and infrastructural in nature.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.82),
                            fontSize: 15,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _NeonInfoCard(
                          child: Text(
                            'Legal Position Summary. JERT is structured as a digital infrastructure coordination unit used to support access to energy, compute and logistics capacity across the network. JERT is not presented as a financial instrument, security, investment product, or payment system.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.92),
                              fontSize: 14,
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        const _SectionTitle('Core legal characteristics'),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'JERT Is',
                          text:
                              'Infrastructure coordination logic tied to network usage and operational access.',
                        ),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'JERT Is Not',
                          text:
                              'A security, financial instrument, payment system, or investment product.',
                        ),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'Usage Scope',
                          text:
                              'Energy capacity, compute environments, logistics participation, and node-level coordination.',
                        ),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'Core Principle',
                          text:
                              'Operational infrastructure access over speculative or financial purpose.',
                        ),
                        const SizedBox(height: 24),
                        const _SectionTitle('Detailed position'),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Infrastructure usage model',
                          body:
                              'JERT is aligned with infrastructure access and coordination across distributed network components. The token supports structured interaction between network participants and infrastructure resources.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Non-financial positioning',
                          body:
                              'JERT does not represent equity, debt, profit participation, dividend rights, deposit rights, repayment claims, or any guaranteed financial opportunity. No promise of return, yield, appreciation, or financial performance is made through JERT itself.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Operational role',
                          body:
                              'JERT supports access logic, internal settlement logic, and coordination logic inside the network environment. It is intended for infrastructure usage across energy, compute, cold-chain, and logistics environments.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Restricted interpretation',
                          body:
                              'Any use of JERT remains subject to applicable law, compliance controls, sanctions logic, KYC requirements, technical restrictions, and platform-level limitations where required.',
                        ),
                        const SizedBox(height: 28),
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

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: JertColors.neonCyan,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _NeonInfoCard extends StatelessWidget {
  final Widget child;

  const _NeonInfoCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: JertColors.neonCyan.withValues(alpha: 0.22),
        ),
        color: JertColors.neonCyan.withValues(alpha: 0.08),
      ),
      child: child,
    );
  }
}

class _LegalBulletCard extends StatelessWidget {
  final String title;
  final String text;

  const _LegalBulletCard({
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
        ),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: JertColors.neonCyan,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 15,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableLegalCard extends StatelessWidget {
  final String title;
  final String body;

  const _ExpandableLegalCard({
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.10),
          ),
          color: Colors.white.withValues(alpha: 0.04),
        ),
        child: ExpansionTile(
          collapsedIconColor: JertColors.neonCyan,
          iconColor: JertColors.neonCyan,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            Text(
              body,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.80),
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
