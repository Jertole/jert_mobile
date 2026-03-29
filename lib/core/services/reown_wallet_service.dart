import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';

class ReownWalletSession {
  final String address;
  final String chainId;

  const ReownWalletSession({
    required this.address,
    required this.chainId,
  });
}

class ReownSignedMessageResult {
  final String walletAddress;
  final String signature;
  final String chainId;

  const ReownSignedMessageResult({
    required this.walletAddress,
    required this.signature,
    required this.chainId,
  });
}

class ReownWalletService {
  ReownAppKitModal? _modal;

  ReownAppKitModal get modal {
    final instance = _modal;
    if (instance == null) {
      throw Exception('ReownWalletService not initialized');
    }
    return instance;
  }

  Future<void> dispatchEnvelope(String link) async {
    debugPrint('WC dispatchEnvelope link = $link');
    await modal.dispatchEnvelope(link);
  }

  Future<void> init({
    required BuildContext context,
    required String projectId,
    required String redirectUrl,
    required String appName,
    required String appDescription,
    required String appUrl,
    required List<String> appIcons,
  }) async {
    if (_modal != null) return;

    _modal = ReownAppKitModal(
      context: context,
      projectId: projectId,
      metadata: PairingMetadata(
        name: appName,
        description: appDescription,
        url: appUrl,
        icons: appIcons,
        redirect: Redirect(
          native: redirectUrl,
          universal: redirectUrl,
        ),
      ),
      featuredWalletIds: const {},
      includedWalletIds: const {},
    );

    await _modal!.init();
  }

  Future<void> open() async {
    await modal.openModalView();
  }

  bool get isConnected => modal.isConnected;

  bool _isValidWalletAddress(String value) {
    final normalized = value.trim();
    final regex = RegExp(r'^0x[a-fA-F0-9]{40}$');
    return regex.hasMatch(normalized);
  }

  Future<void> waitForSession({
    Duration timeout = const Duration(seconds: 12),
  }) async {
    debugPrint('WC waitForSession start');

    final started = DateTime.now();

    while (modal.session == null) {
      debugPrint(
        'WC waiting... isConnected=$isConnected session=${modal.session != null}',
      );

      await Future.delayed(const Duration(milliseconds: 250));

      if (DateTime.now().difference(started) > timeout) {
        debugPrint('WC waitForSession timeout');
        throw Exception('Wallet session timeout');
      }
    }

    debugPrint('WC waitForSession done session=${modal.session != null}');
  }

  String? get address {
    final session = modal.session;
    if (session == null) return null;

    final namespaces = session.namespaces?.values ?? const [];

    for (final ns in namespaces) {
      final accounts = ns.accounts;
      for (final account in accounts) {
        // expected: eip155:137:0xabc...
        final parts = account.split(':');
        if (parts.length >= 3) {
          final candidate = parts[2].trim();
          if (_isValidWalletAddress(candidate)) {
            return candidate;
          }
        }
      }
    }

    return null;
  }

  String? get chainId {
    final session = modal.session;
    if (session == null) return null;

    final namespaces = session.namespaces?.values ?? const [];

    for (final ns in namespaces) {
      final accounts = ns.accounts;
      for (final account in accounts) {
        // expected: eip155:137:0xabc...
        final parts = account.split(':');
        if (parts.length >= 3) {
          final namespace = parts[0].trim();
          final chain = parts[1].trim();
          if (namespace.isNotEmpty && chain.isNotEmpty) {
            return '$namespace:$chain';
          }
        }
      }
    }

    return null;
  }

  ReownWalletSession requireSession() {
    final addr = address;
    if (addr == null || addr.isEmpty || !_isValidWalletAddress(addr)) {
      throw Exception('Wallet address is not available');
    }

    final chain = chainId;
    if (chain == null || chain.isEmpty) {
      throw Exception('Wallet chain is not available');
    }

    return ReownWalletSession(
      address: addr,
      chainId: chain,
    );
  }

  Future<ReownSignedMessageResult> connectAndSign({
    required String message,
  }) async {
    if (!isConnected) {
      await open();
      await waitForSession();
    }

    final current = requireSession();
    final currentSession = modal.session;
    if (currentSession == null) {
      throw Exception('Wallet session is not available');
    }

    final result = await modal.request(
      topic: currentSession.topic,
      chainId: current.chainId,
      request: SessionRequestParams(
        method: 'personal_sign',
        params: [
          message,
          current.address,
        ],
      ),
    );

    if (result == null) {
      throw Exception('Signature was not returned');
    }

    final signature = result.toString().trim();
    if (signature.isEmpty) {
      throw Exception('Signature was empty');
    }

    return ReownSignedMessageResult(
      walletAddress: current.address,
      signature: signature,
      chainId: current.chainId,
    );
  }

  Future<String> sendTransaction({
    required String to,
    required String data,
    required String value,
  }) async {
    final current = requireSession();
    final currentSession = modal.session;
    if (currentSession == null) {
      throw Exception('Wallet session is not available');
    }

    if (!_isValidWalletAddress(to)) {
      throw Exception('Recipient wallet address is invalid');
    }

    final result = await modal.request(
      topic: currentSession.topic,
      chainId: current.chainId,
      request: SessionRequestParams(
        method: 'eth_sendTransaction',
        params: [
          {
            'from': current.address,
            'to': to,
            'data': data,
            'value': value,
          },
        ],
      ),
    );

    if (result == null) {
      throw Exception('Transaction hash was not returned');
    }

    final txHash = result.toString().trim();
    if (txHash.isEmpty) {
      throw Exception('Transaction hash was empty');
    }

    return txHash;
  }
}
