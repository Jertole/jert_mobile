import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/lease_contract_service.dart';
import '../services/terminal_service.dart';
import '../services/session_storage.dart';

enum LedgerEntryType {
  reserve,
  settle,
  refund,
  treasury,
}

class LedgerEntry {
  final String id;
  final DateTime createdAt;
  final LedgerEntryType type;
  final String title;
  final String subtitle;
  final double amount;
  final String network;
  final String assetType;
  final String? txHash;
  final String? terminalId;

  const LedgerEntry({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.network,
    required this.assetType,
    this.txHash,
    this.terminalId,
  });
}

enum PartnerLevel { p1, p2, p3, p4 }

enum KycStatus { none, registered, approved, rejected }

class WalletBalances {
  final double walletJert;
  final double reservedJert;
  final double settledJert;
  final double refundedJert;

  const WalletBalances({
    required this.walletJert,
    required this.reservedJert,
    required this.settledJert,
    required this.refundedJert,
  });

  WalletBalances copyWith({
    double? walletJert,
    double? reservedJert,
    double? settledJert,
    double? refundedJert,
  }) {
    return WalletBalances(
      walletJert: walletJert ?? this.walletJert,
      reservedJert: reservedJert ?? this.reservedJert,
      settledJert: settledJert ?? this.settledJert,
      refundedJert: refundedJert ?? this.refundedJert,
    );
  }
}

class TerminalReserveDraft {
  final String terminalId;
  final int chainId;
  final String networkName;
  final double reserveAmount;
  final String serviceType;

  const TerminalReserveDraft({
    required this.terminalId,
    required this.chainId,
    required this.networkName,
    required this.reserveAmount,
    required this.serviceType,
  });
}

class AppController extends ChangeNotifier {
  bool authed;
  bool walletConnected;
  String walletAddress;
  PartnerLevel partnership;
  KycStatus kycStatus;
  WalletBalances balances;

  final ApiService apiService;
  final LeaseContractService leaseContractService;
  final TerminalService terminalService;
  final SessionStorage sessionStorage;

  final List<LedgerEntry> _ledgerEntries = [];

  String? lastTerminalTxHash;
  String? sessionToken;
  String? userId;
  String? lastReservedTerminalId;
  String? boundWalletAddress;
  String walletChain = 'polygon';

  bool get hasBoundWallet =>
      boundWalletAddress != null && boundWalletAddress!.isNotEmpty;

  AppController({
    required this.authed,
    required this.walletConnected,
    required this.walletAddress,
    required this.partnership,
    required this.kycStatus,
    required this.balances,
    required this.apiService,
    required this.leaseContractService,
    required this.terminalService,
    required this.sessionStorage,
    this.sessionToken,
    this.userId,
  });
  Future<void> persistSession() async {
    if (sessionToken == null ||
        sessionToken!.isEmpty ||
        userId == null ||
        userId!.isEmpty) {
      return;
    }

    await sessionStorage.saveSession(
      sessionToken: sessionToken!,
      userId: userId!,
    );
  }

  Future<void> clearPersistedSession() async {
    await sessionStorage.clearSession();
  }

  Future<StoredSession?> readPersistedSession() async {
    return sessionStorage.readSession();
  }

  void clearSessionState() {
    sessionToken = null;
    userId = null;
    authed = false;
    walletConnected = false;
    kycStatus = KycStatus.none;
    notifyListeners();
  }

  factory AppController.mock() {
    final controller = AppController(
      authed: true,
      walletConnected: true,
      walletAddress: '0x9e9832733b247240fb81d49362b5f679dddf90e',
      partnership: PartnerLevel.p2,
      kycStatus: KycStatus.approved,
      balances: const WalletBalances(
        walletJert: 0,
        reservedJert: 0,
        settledJert: 0,
        refundedJert: 0,
      ),
      apiService: const ApiService(),
      leaseContractService: const LeaseContractService(),
      terminalService: const TerminalService(),
      sessionStorage: SessionStorage(),
      sessionToken: null,
      userId: null,
    );

    controller._addLedgerEntry(
      type: LedgerEntryType.reserve,
      title: 'KYC Approved',
      subtitle: 'Wallet passed compliance review',
      amount: 0,
      network: 'Polygon L2',
      assetType: 'cold',
    );

    return controller;
  }

  bool get canUseTerminal =>
      authed && walletConnected && kycStatus == KycStatus.approved;
  void updateAccessState({
    bool? authed,
    bool? walletConnected,
    KycStatus? kycStatus,
  }) {
    if (authed != null) {
      this.authed = authed;
    }
    if (walletConnected != null) {
      this.walletConnected = walletConnected;
    }
    if (kycStatus != null) {
      this.kycStatus = kycStatus;
    }
    notifyListeners();
  }

  String get partnershipLabel {
    switch (partnership) {
      case PartnerLevel.p1:
        return 'P1';
      case PartnerLevel.p2:
        return 'P2';
      case PartnerLevel.p3:
        return 'P3';
      case PartnerLevel.p4:
        return 'P4';
    }
  }

  List<LedgerEntry> get ledgerEntries => List.unmodifiable(_ledgerEntries);

  List<TerminalInfo> get terminals => terminalService.getTerminals();

  Future<void> setSession({
    required String sessionToken,
    required String userId,
  }) async {
    this.sessionToken = sessionToken;
    this.userId = userId;
    await persistSession();
    notifyListeners();
  }

  void applyKycStatus(KycReviewStatus status) {
    switch (status) {
      case KycReviewStatus.underReview:
        kycStatus = KycStatus.registered;
        break;
      case KycReviewStatus.approved:
        kycStatus = KycStatus.approved;
        break;
      case KycReviewStatus.rejected:
        kycStatus = KycStatus.rejected;
        break;
      case KycReviewStatus.unknown:
        kycStatus = KycStatus.none;
        break;
    }
    notifyListeners();
  }

  void applySummary(SummaryResult summary) {
    walletAddress = userId ?? walletAddress;

    balances = balances.copyWith(
      walletJert: summary.balanceJert,
      reservedJert: summary.reservedJert,
    );

    final partnershipRaw = (summary.partnership ?? '').toUpperCase().trim();
    switch (partnershipRaw) {
      case 'P1':
        partnership = PartnerLevel.p1;
        break;
      case 'P2':
        partnership = PartnerLevel.p2;
        break;
      case 'P3':
        partnership = PartnerLevel.p3;
        break;
      case 'P4':
        partnership = PartnerLevel.p4;
        break;
    }

    final complianceKyc =
        (summary.compliance['kyc'] ?? '').toString().toUpperCase().trim();

    switch (complianceKyc) {
      case 'UNDER_REVIEW':
        kycStatus = KycStatus.registered;
        break;
      case 'APPROVED':
        kycStatus = KycStatus.approved;
        break;
      case 'REJECTED':
        kycStatus = KycStatus.rejected;
        break;
    }

    notifyListeners();
  }

  void applyWalletStatus(WalletStatusResult result) {
    if (result.bound &&
        result.walletAddress != null &&
        result.walletAddress!.isNotEmpty) {
      boundWalletAddress = result.walletAddress;
      walletChain = result.chain;
      walletConnected = true;
    } else {
      boundWalletAddress = null;
      walletChain = result.chain;
      walletConnected = false;
    }
    notifyListeners();
  }

  void applyWalletBind(WalletBindResult result) {
    boundWalletAddress = result.walletAddress;
    walletChain = result.chain;
    walletConnected = true;
    notifyListeners();
  }

  void clearWalletBinding() {
    boundWalletAddress = null;
    walletConnected = false;
    walletChain = 'polygon';
    notifyListeners();
  }

  void _addLedgerEntry({
    required LedgerEntryType type,
    required String title,
    required String subtitle,
    required double amount,
    required String network,
    required String assetType,
    String? txHash,
    String? terminalId,
  }) {
    _ledgerEntries.insert(
      0,
      LedgerEntry(
        id: '${DateTime.now().microsecondsSinceEpoch}_${type.name}',
        createdAt: DateTime.now(),
        type: type,
        title: title,
        subtitle: subtitle,
        amount: amount,
        network: network,
        assetType: assetType,
        txHash: txHash,
        terminalId: terminalId,
      ),
    );
  }

  Future<TerminalReserveResult> reserveJertForTerminal(
    TerminalReserveDraft draft,
  ) async {
    if (!canUseTerminal) {
      throw Exception('KYC approval and connected wallet are required.');
    }

    if (draft.reserveAmount <= 0) {
      throw Exception('Reserve amount must be greater than zero.');
    }

    if (draft.reserveAmount > balances.walletJert) {
      throw Exception('Insufficient JERT balance.');
    }

    final terminal = terminals.firstWhere(
      (t) => t.id == draft.terminalId,
      orElse: () => throw Exception('Terminal not found.'),
    );

    final txHash = await leaseContractService.reserveOnPolygon(
      walletAddress: walletAddress,
      terminalId: draft.terminalId,
      amountJert: draft.reserveAmount,
      serviceType: draft.serviceType,
      chainId: draft.chainId,
    );

    await apiService.createTerminalReserveRecord(
      walletAddress: walletAddress,
      terminalId: draft.terminalId,
      reservedJert: draft.reserveAmount,
      serviceType: draft.serviceType,
    );

    final result = await terminalService.reserve(
      terminal: terminal,
      draft: draft,
    );

    balances = balances.copyWith(
      walletJert: balances.walletJert - draft.reserveAmount,
      reservedJert: balances.reservedJert + draft.reserveAmount,
    );

    lastTerminalTxHash = txHash;
    lastReservedTerminalId = draft.terminalId;

    _addLedgerEntry(
      type: LedgerEntryType.reserve,
      title: 'Terminal Reserve Created',
      subtitle:
          '${terminal.id} • ${draft.serviceType} • ${draft.reserveAmount.toStringAsFixed(2)} JERT',
      amount: draft.reserveAmount,
      network: draft.networkName,
      assetType: terminal.assetType,
      txHash: txHash,
      terminalId: terminal.id,
    );

    notifyListeners();

    return TerminalReserveResult(
      ok: result.ok,
      message: result.message,
      terminalId: result.terminalId,
      reservedAmount: result.reservedAmount,
      serviceType: result.serviceType,
      txHash: txHash,
    );
  }

  Future<void> mockSettleUsage({
    required double usedJert,
    required double refundJert,
  }) async {
    final totalDelta = usedJert + refundJert;

    if (totalDelta <= 0) {
      throw Exception('Settlement delta must be greater than zero.');
    }

    if (totalDelta > balances.reservedJert) {
      throw Exception('Not enough reserved JERT for this settlement.');
    }

    final nextReserved = balances.reservedJert - totalDelta;
    final tx = lastTerminalTxHash;
    final reserveNetwork = 'Polygon L2';

    String reserveAsset = 'cold';
    if (lastReservedTerminalId != null) {
      try {
        final terminal =
            terminals.firstWhere((t) => t.id == lastReservedTerminalId);
        reserveAsset = terminal.assetType;
      } catch (_) {}
    }

    balances = balances.copyWith(
      reservedJert: nextReserved < 0 ? 0 : nextReserved,
      settledJert: balances.settledJert + usedJert,
      refundedJert: balances.refundedJert + refundJert,
      walletJert: balances.walletJert + refundJert,
    );

    if (usedJert > 0) {
      _addLedgerEntry(
        type: LedgerEntryType.settle,
        title: 'Usage Settled',
        subtitle: 'Measured usage transferred from reserve',
        amount: usedJert,
        network: reserveNetwork,
        assetType: reserveAsset,
        txHash: tx,
        terminalId: lastReservedTerminalId,
      );

      _addLedgerEntry(
        type: LedgerEntryType.treasury,
        title: 'Treasury Allocation',
        subtitle: 'Settled JERT moved to treasury',
        amount: usedJert,
        network: reserveNetwork,
        assetType: reserveAsset,
        txHash: tx,
        terminalId: lastReservedTerminalId,
      );
    }

    if (refundJert > 0) {
      _addLedgerEntry(
        type: LedgerEntryType.refund,
        title: 'Unused Reserve Refunded',
        subtitle: 'Unused JERT returned after final settlement',
        amount: refundJert,
        network: reserveNetwork,
        assetType: reserveAsset,
        txHash: tx,
        terminalId: lastReservedTerminalId,
      );
    }

    notifyListeners();
  }
}
