import 'package:flutter/material.dart';
import 'core/state/app_controller.dart';
import 'features/auth/kyc_pending_screen.dart';
import 'features/auth/kyc_rejected_screen.dart';
import 'features/auth/welcome_screen.dart';
import 'features/wallet/wallet_screen.dart';
import 'core/services/api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JertApp());
}

class JertApp extends StatelessWidget {
  const JertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JERT Wallet',
      home: const BootstrapScreen(),
    );
  }
}

class BootstrapScreen extends StatefulWidget {
  const BootstrapScreen({super.key});

  @override
  State<BootstrapScreen> createState() => _BootstrapScreenState();
}

class _BootstrapScreenState extends State<BootstrapScreen> {
  late final AppController controller;
  Widget? targetScreen;

  @override
  void initState() {
    super.initState();
    controller = AppController.mock();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final stored = await controller.readPersistedSession();

    if (stored == null) {
      if (!mounted) return;
      setState(() {
        targetScreen = WelcomeScreen(controller: controller);
      });
      return;
    }

    try {
      await controller.setSession(
        sessionToken: stored.sessionToken,
        userId: stored.userId,
      );

      controller.updateAccessState(
        authed: true,
        walletConnected: false,
      );

      final kyc = await controller.apiService.fetchKycStatus(
        bearerToken: stored.sessionToken,
      );

      controller.applyKycStatus(kyc.status);

      if (kyc.status == KycReviewStatus.approved) {
        final summary = await controller.apiService.fetchSummary(
          bearerToken: stored.sessionToken,
        );
        controller.applySummary(summary);

        if (!mounted) return;
        setState(() {
          targetScreen = WalletScreen(controller: controller);
        });
        return;
      }

      if (kyc.status == KycReviewStatus.rejected) {
        if (!mounted) return;
        setState(() {
          targetScreen = KycRejectedScreen(controller: controller);
        });
        return;
      }

      if (!mounted) return;
      setState(() {
        targetScreen = KycPendingScreen(
          controller: controller,
          email: summaryEmailFallback(),
        );
      });
    } catch (_) {
      await controller.clearPersistedSession();
      controller.clearSessionState();

      if (!mounted) return;
      setState(() {
        targetScreen = WelcomeScreen(controller: controller);
      });
    }
  }

  String summaryEmailFallback() {
    return 'session@jert';
  }

  @override
  Widget build(BuildContext context) {
    if (targetScreen == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return targetScreen!;
  }
}
