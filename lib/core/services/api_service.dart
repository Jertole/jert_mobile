import 'dart:convert';
import 'package:http/http.dart' as http;

enum KycReviewStatus {
  underReview,
  approved,
  rejected,
  unknown,
}

class SessionAuthResult {
  final bool ok;
  final String sessionToken;
  final String userId;
  final String status;

  const SessionAuthResult({
    required this.ok,
    required this.sessionToken,
    required this.userId,
    required this.status,
  });
}

class KycSubmitResult {
  final bool ok;
  final String status;

  const KycSubmitResult({
    required this.ok,
    required this.status,
  });
}

class KycStatusResult {
  final bool ok;
  final KycReviewStatus status;
  final String partnershipRaw;

  const KycStatusResult({
    required this.ok,
    required this.status,
    required this.partnershipRaw,
  });
}

class SummaryResult {
  final bool ok;
  final String userId;
  final String network;
  final String? partnership;
  final Map<String, dynamic> compliance;
  final double balanceJert;
  final double reservedJert;
  final List<dynamic> lastEvents;

  const SummaryResult({
    required this.ok,
    required this.userId,
    required this.network,
    required this.partnership,
    required this.compliance,
    required this.balanceJert,
    required this.reservedJert,
    required this.lastEvents,
  });
}

class WalletStatusResult {
  final bool ok;
  final bool bound;
  final String? walletAddress;
  final String chain;
  final String status;
  final String kycStatus;

  const WalletStatusResult({
    required this.ok,
    required this.bound,
    required this.walletAddress,
    required this.chain,
    required this.status,
    required this.kycStatus,
  });

  factory WalletStatusResult.fromJson(Map<String, dynamic> json) {
    return WalletStatusResult(
      ok: json['ok'] == true,
      bound: json['bound'] == true,
      walletAddress: json['wallet_address']?.toString(),
      chain: (json['chain'] ?? 'polygon').toString(),
      status: (json['status'] ?? 'NOT_BOUND').toString(),
      kycStatus: (json['kyc_status'] ?? 'NONE').toString(),
    );
  }
}

class WalletChallengeResult {
  final bool ok;
  final String chain;
  final String nonce;
  final String message;

  const WalletChallengeResult({
    required this.ok,
    required this.chain,
    required this.nonce,
    required this.message,
  });

  factory WalletChallengeResult.fromJson(Map<String, dynamic> json) {
    return WalletChallengeResult(
      ok: json['ok'] == true,
      chain: (json['chain'] ?? 'polygon').toString(),
      nonce: (json['nonce'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
    );
  }
}

class WalletBindResult {
  final bool ok;
  final String status;
  final String walletAddress;
  final String chain;

  const WalletBindResult({
    required this.ok,
    required this.status,
    required this.walletAddress,
    required this.chain,
  });

  factory WalletBindResult.fromJson(Map<String, dynamic> json) {
    return WalletBindResult(
      ok: json['ok'] == true,
      status: (json['status'] ?? 'UNKNOWN').toString(),
      walletAddress: (json['wallet_address'] ?? '').toString(),
      chain: (json['chain'] ?? 'polygon').toString(),
    );
  }
}

class ApiService {
  static const String baseUrl = 'https://api.jert.kz';

  const ApiService();

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Map<String, String> _jsonHeaders({String? bearerToken}) {
    return {
      'Content-Type': 'application/json',
      if (bearerToken != null && bearerToken.isNotEmpty)
        'Authorization': 'Bearer $bearerToken',
    };
  }

  Map<String, dynamic> _decodeJson(http.Response response) {
    final body = response.body.trim();

    if (body.isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw Exception('Invalid JSON response format');
  }

  Future<Map<String, dynamic>> _readJson(http.Response response) async {
    if (response.body.isEmpty) {
      return {};
    }
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    throw Exception('Invalid API response format.');
  }

  String _extractError(Map<String, dynamic> json) {
    final error = json['error'];
    if (error is String && error.trim().isNotEmpty) {
      return error;
    }
    return 'Unknown API error.';
  }

  KycReviewStatus _mapKycStatus(String raw) {
    switch (raw.toUpperCase()) {
      case 'UNDER_REVIEW':
        return KycReviewStatus.underReview;
      case 'APPROVED':
        return KycReviewStatus.approved;
      case 'REJECTED':
        return KycReviewStatus.rejected;
      default:
        return KycReviewStatus.unknown;
    }
  }

  Future<SessionAuthResult> register({
    required String accountType,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      _uri('/v1/session/register'),
      headers: _jsonHeaders(),
      body: jsonEncode({
        'account_type': accountType,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    final json = await _readJson(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_extractError(json));
    }

    final token = (json['session_token'] ?? '').toString();
    final userId = (json['user_id'] ?? '').toString();
    final status = (json['status'] ?? '').toString();

    if (token.isEmpty || userId.isEmpty) {
      throw Exception('Missing session token or user id.');
    }

    return SessionAuthResult(
      ok: true,
      sessionToken: token,
      userId: userId,
      status: status,
    );
  }

  Future<SessionAuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      _uri('/v1/session/login'),
      headers: _jsonHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final json = await _readJson(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_extractError(json));
    }

    final token = (json['session_token'] ?? '').toString();
    final userId = (json['user_id'] ?? '').toString();
    final status = (json['status'] ?? '').toString();

    if (token.isEmpty || userId.isEmpty) {
      throw Exception('Missing session token or user id.');
    }

    return SessionAuthResult(
      ok: true,
      sessionToken: token,
      userId: userId,
      status: status,
    );
  }

  Future<KycSubmitResult> submitKyc({
    required String bearerToken,
  }) async {
    final response = await http.post(
      _uri('/v1/kyc/submit'),
      headers: _jsonHeaders(bearerToken: bearerToken),
    );

    final json = await _readJson(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_extractError(json));
    }

    return KycSubmitResult(
      ok: true,
      status: (json['status'] ?? '').toString(),
    );
  }

  Future<KycStatusResult> fetchKycStatus({
    required String bearerToken,
  }) async {
    final response = await http.get(
      _uri('/v1/kyc/status'),
      headers: _jsonHeaders(bearerToken: bearerToken),
    );

    final json = await _readJson(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_extractError(json));
    }

    final rawStatus = (json['status'] ?? '').toString();
    final partnershipRaw = (json['partnership'] ?? '').toString();

    return KycStatusResult(
      ok: true,
      status: _mapKycStatus(rawStatus),
      partnershipRaw: partnershipRaw,
    );
  }

  Future<WalletStatusResult> fetchWalletStatus({
    required String bearerToken,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/wallet/status'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
    );

    final json = _decodeJson(response);

    if (response.statusCode >= 400) {
      throw Exception(
          (json['error'] ?? 'Failed to fetch wallet status').toString());
    }

    return WalletStatusResult.fromJson(json);
  }

  Future<WalletChallengeResult> fetchWalletChallenge({
    required String bearerToken,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/v1/wallet/challenge'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
    );

    final json = _decodeJson(response);

    if (response.statusCode >= 400) {
      throw Exception(
          (json['error'] ?? 'Failed to fetch wallet challenge').toString());
    }

    return WalletChallengeResult.fromJson(json);
  }

  Future<WalletBindResult> bindWallet({
    required String bearerToken,
    required String walletAddress,
    required String message,
    required String signature,
    String chain = 'polygon',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/v1/wallet/bind'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'wallet_address': walletAddress,
        'message': message,
        'signature': signature,
        'chain': chain,
      }),
    );

    final json = _decodeJson(response);

    if (response.statusCode >= 400) {
      throw Exception((json['error'] ?? 'Failed to bind wallet').toString());
    }

    return WalletBindResult.fromJson(json);
  }

  Future<Map<String, dynamic>> buildErc20Transfer({
    required String bearerToken,
    required String to,
    required String amountJert,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/v1/chain/tx/erc20-transfer'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'to': to,
        'amount_jert': amountJert,
      }),
    );

    final decoded = _decodeJson(response);
    final json = Map<String, dynamic>.from(decoded);

    if (response.statusCode >= 400) {
      throw Exception(
        (json['error'] ?? 'Failed to build ERC20 transfer').toString(),
      );
    }

    final payload = json['payload'];
    if (payload is Map) {
      return Map<String, dynamic>.from(payload);
    }

    return json;
  }

  Future<void> notifyTxReceipt({
    required String bearerToken,
    required String txHash,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/v1/chain/tx/receipt'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'txHash': txHash,
      }),
    );

    final json = _decodeJson(response);

    if (response.statusCode >= 400) {
      throw Exception(
          (json['error'] ?? 'Failed to notify tx receipt').toString());
    }
  }

  Future<SummaryResult> fetchSummary({
    required String bearerToken,
  }) async {
    final response = await http.get(
      _uri('/v1/summary'),
      headers: _jsonHeaders(bearerToken: bearerToken),
    );

    final json = await _readJson(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_extractError(json));
    }

    return SummaryResult(
      ok: true,
      userId: (json['user_id'] ?? '').toString(),
      network: (json['network'] ?? '').toString(),
      partnership: json['partnership']?.toString(),
      compliance: (json['compliance'] as Map?)?.cast<String, dynamic>() ?? {},
      balanceJert: ((json['balance_jert'] ?? 0) as num).toDouble(),
      reservedJert: ((json['reserved_jert'] ?? 0) as num).toDouble(),
      lastEvents: (json['last_events'] as List?) ?? const [],
    );
  }

  Future<void> createTerminalReserveRecord({
    required String walletAddress,
    required String terminalId,
    required double reservedJert,
    required String serviceType,
  }) async {
    return;
  }
}
