import 'package:flutter/material.dart';

import '../../core/ui/jert_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                            'PRIVACY POLICY',
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
                          'Minimal data logic. Technical necessity. Responsible processing.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.08,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'JERT follows a minimal-data approach. Information may be processed where necessary for website security, wallet functionality, technical diagnostics, service improvement, lawful compliance, and abuse prevention.',
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
                            'Privacy summary. Data may be processed strictly to operate the wallet and website environment, preserve security, investigate technical issues, comply with lawful requirements, and maintain the integrity of the infrastructure platform.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.92),
                              fontSize: 14,
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const _SectionTitle('Core privacy logic'),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'May include',
                          text:
                              'Technical logs, browser or device information, IP metadata, wallet interaction events, session identifiers, and security records.',
                        ),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'Purpose',
                          text:
                              'Security, uptime, diagnostics, authentication, access control, lawful compliance, and abuse prevention.',
                        ),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'Approach',
                          text:
                              'Minimization, necessity, proportionality, and controlled retention where appropriate.',
                        ),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'Exclusions',
                          text:
                              'No unnecessary profiling, no broad commercial resale of user data, and no excessive tracking logic by default.',
                        ),
                        const SizedBox(height: 24),
                        const _SectionTitle('Detailed privacy points'),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Information we may process',
                          body:
                              'The application or related infrastructure may process email address, wallet address, authentication-related identifiers, session metadata, device information, and technical logs necessary for account security and service operation.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Purpose of processing',
                          body:
                              'Collected data is used for user authentication, security and fraud prevention, access to JERT infrastructure services, communication regarding account status, diagnostics, abuse prevention, and lawful compliance where required.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Blockchain transparency',
                          body:
                              'Transactions performed on public blockchain networks may be publicly visible. Wallet addresses and transaction hashes may remain accessible on decentralized networks and cannot be deleted by the platform operator.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Data sharing',
                          body:
                              'JERT does not sell or rent user data. Information may only be processed by infrastructure systems, security services, hosting environments, or lawful providers necessary to operate and protect the service.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Data storage and retention',
                          body:
                              'Operational data may be processed by secure infrastructure servers used by the JERT Network. These systems are designed for authentication, security monitoring, operational integrity, and technical continuity. Retention should remain limited to what is reasonably necessary for those purposes.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'User-facing privacy points',
                          body:
                              'Users may contact the operator regarding questions related to processing logic, access restrictions, or general privacy requests where applicable. Jurisdiction-specific notices may be added later if the platform expands into additional regulated regions.',
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
