import 'package:flutter/material.dart';

import '../../core/ui/jert_colors.dart';

class TokenomicsScreen extends StatelessWidget {
  const TokenomicsScreen({super.key});

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
                            'SECTION 02 • COLD ENERGY SWAP PRICE MODEL',
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
                          'Recovered LNG cold\nbecomes the first\nprice anchor.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            height: 1.02,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'The model anchors JERT to a measurable cold-energy recovery logic linked to LNG and CO₂ avoidance.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.82),
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 22),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.18,
                          children: const [
                            _TokenMetricCard(
                              title: '100 JERT',
                              value: '142 kWh Cold',
                              text:
                                  'Primary physical anchor based on recoverable cold from 1 tonne LNG.',
                            ),
                            _TokenMetricCard(
                              title: '1 JERT',
                              value: '1.42 kWh',
                              text: 'Primary cold energy value per token.',
                            ),
                            _TokenMetricCard(
                              title: '1 JERT',
                              value: '0.0055 MMBtu',
                              text:
                                  'Secondary LNG linked reference for investor readability.',
                            ),
                            _TokenMetricCard(
                              title: '1 JERT',
                              value: '0.30–0.55 kg CO₂',
                              text:
                                  'Derived avoided-emission value from not producing equivalent cold electrically.',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _NeonInfoCard(
                          child: Text(
                            'Tokenomics summary. Canonical issuance exists once on Ethereum mainnet. Polygon PoS supports Middle Corridor infrastructure settlement. Arbitrum supports EU infrastructure settlement. Total supply remains 1,000,000,000,000 JERT with bridge-based extension across infrastructure layers.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.92),
                              fontSize: 14,
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const _SectionTitle('Core tokenomics'),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'Token type',
                          text:
                              'JERT is a tokenized infrastructure capacity unit and settlement token for network services.',
                        ),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'Total supply',
                          text:
                              '1,000,000,000,000 JERT total canonical supply.',
                        ),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'Canonical issuance',
                          text:
                              'Ethereum mainnet is the primary issuance layer.',
                        ),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'Bridge logic',
                          text:
                              'Polygon PoS and Arbitrum are settlement layers connected through bridge logic, not separate primary issuance systems.',
                        ),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'Utility model',
                          text:
                              'JERT is used for access to cold energy, compute capacity, logistics participation, and SLA infrastructure.',
                        ),
                        const SizedBox(height: 24),
                        const _SectionTitle('Infrastructure settlement model'),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Cold energy settlement',
                          body:
                              'JERT may be used as a settlement unit for cold energy and infrastructure usage related to LNG cold recovery, industrial cooling, and cold-chain capacity.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Compute settlement',
                          body:
                              'JERT may be used to settle AI compute access, VRAM rental, autonomous compute node participation, and infrastructure resource coordination across JERT DC environments.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Logistics and SLA',
                          body:
                              'JERT may support settlement logic for logistics participation, node-level coordination, service-level infrastructure commitments, and container-day operational logic.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'No investment promises',
                          body:
                              'The token does not represent dividends, profit participation, repayment claims, deposit rights, or any guaranteed yield. Token usage is operational and infrastructure-linked.',
                        ),
                        const SizedBox(height: 24),
                        const _SectionTitle('Launch and market access'),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'DEX launch policy',
                          body:
                              'Planned DEX launch uses Uniswap v3 with pair JERT / ETH and 1% fee tier. Launch allocation is 100,000,000,000 JERT, representing 10% of total supply.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Price discovery ranges',
                          body:
                              'Initial price discovery structure may be split into sequential ranges: 0.000001–0.000002 ETH, 0.000002–0.000004 ETH, 0.000004–0.000007 ETH, and 0.000007–0.000010 ETH.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Institutional custody',
                          body:
                              'Liquidity positions may be held by institutional custodians such as BitGo Trust Company or Anchorage Digital. LP positions may be used as collateral for infrastructure financing rather than speculative liquidity mining.',
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

class _TokenMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String text;

  const _TokenMetricCard({
    required this.title,
    required this.value,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
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
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.78),
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
