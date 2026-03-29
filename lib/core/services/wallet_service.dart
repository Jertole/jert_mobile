import 'package:flutter/foundation.dart';

class WalletConnectResult {
  final String walletAddress;
  final String signature;

  const WalletConnectResult({
    required this.walletAddress,
    required this.signature,
  });
}

class WalletService {
  const WalletService();

  Future<WalletConnectResult> connectAndSign({
    required String message,
  }) async {
    if (kIsWeb) {
      throw Exception(
        'Wallet signing is not connected yet on web build. Next step: wire MetaMask / WalletConnect signer.',
      );
    }

    throw Exception(
      'Wallet signing is not connected yet on this platform. Next step: wire MetaMask / WalletConnect signer.',
    );
  }
}
