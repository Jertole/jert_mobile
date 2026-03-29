import 'package:flutter/material.dart';

import '../../core/ui/jert_colors.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

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
                            'TERMS OF USE',
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
                          'Access, responsibility, and platform conditions',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.08,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'The JERT wallet and related interfaces are provided for access to the network environment and its infrastructure-related functions. By using the wallet, website, or related services, the user agrees to these terms and acknowledges the infrastructure nature of the system.',
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
                            'Short-form terms summary: operational use only. No public investment solicitation. No financial reliance. Compliance reservation applies where legal, regulatory, security, or infrastructure integrity requirements require limitation or suspension of access.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.92),
                              fontSize: 14,
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const _SectionTitle('Core terms'),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'Eligibility',
                          text:
                              'Users must act lawfully and be permitted to use the service under applicable law.',
                        ),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'User responsibility',
                          text:
                              'Users remain responsible for their device security, credentials, wallet access, and lawful conduct.',
                        ),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'No guarantees',
                          text:
                              'Access to the platform is provided on an as available basis without guarantees of uninterrupted operation.',
                        ),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'Compliance reservation',
                          text:
                              'Access may be limited, suspended, or restricted where necessary for legal, regulatory, or security reasons.',
                        ),
                        const SizedBox(height: 12),
                        const _LegalBulletCard(
                          title: 'No financial reliance',
                          text:
                              'The platform does not provide investment, legal, tax, or financial advice through wallet access.',
                        ),
                        const SizedBox(height: 24),
                        const _SectionTitle('Detailed clauses'),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Acceptable use',
                          body:
                              'The environment is intended to support network operations, infrastructure coordination, and related service access. It must not be used in a manner that suggests public investment solicitation, unauthorized financial promotion, or unlawful jurisdictional targeting.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Prohibited conduct',
                          body:
                              'Fraud, misrepresentation, unlawful use, abuse of APIs, credential sharing, security interference, technical exploitation, or misuse of wallet functions may result in restriction or termination of access.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Jurisdictional restrictions',
                          body:
                              'Certain features may be unavailable where access would create legal or regulatory conflict. Users remain responsible for determining whether platform access is lawful in their jurisdiction.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Service evolution',
                          body:
                              'Features may be modified, postponed, limited, or removed as the network develops. The operator may adapt the service where infrastructure, compliance, vendor, or technical needs require it.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'Third-party dependencies',
                          body:
                              'Some functions may rely on infrastructure providers, hosting providers, network services, wallet environments, or blockchain systems outside direct operational control.',
                        ),
                        const SizedBox(height: 12),
                        const _ExpandableLegalCard(
                          title: 'No investment offering',
                          body:
                              'Nothing on the JERT website, mobile wallet, or related interfaces should be interpreted as an offer of securities, deposit-taking activity, collective investment participation, or any guaranteed financial opportunity.',
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
