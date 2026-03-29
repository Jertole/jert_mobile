import '../state/app_controller.dart';

class TerminalInfo {
  final String id;
  final String name;
  final String country;
  final String networkName;
  final int chainId;
  final String assetType; // cold / lcng / dc
  final List<String> serviceTypes;
  final String pricingNote;

  const TerminalInfo({
    required this.id,
    required this.name,
    required this.country,
    required this.networkName,
    required this.chainId,
    required this.assetType,
    required this.serviceTypes,
    required this.pricingNote,
  });
}

class TerminalReserveResult {
  final bool ok;
  final String message;
  final String terminalId;
  final double reservedAmount;
  final String serviceType;
  final String txHash;

  const TerminalReserveResult({
    required this.ok,
    required this.message,
    required this.terminalId,
    required this.reservedAmount,
    required this.serviceType,
    required this.txHash,
  });
}

class TerminalService {
  const TerminalService();

  List<TerminalInfo> getTerminals() {
    return const [
      TerminalInfo(
        id: 'AKT-COLD-01',
        name: 'Aktobe Cold Terminal 01',
        country: 'Kazakhstan',
        networkName: 'Polygon L2',
        chainId: 137,
        assetType: 'cold',
        serviceTypes: ['cold_storage'],
        pricingNote: 'Cold storage base tariff: 69 JERT per ton-day.',
      ),
      TerminalInfo(
        id: 'AKT-LCNG-01',
        name: 'Aktobe LCNG Station 01',
        country: 'Kazakhstan',
        networkName: 'Polygon L2',
        chainId: 137,
        assetType: 'lcng',
        serviceTypes: ['cold', 'sla'],
        pricingNote:
            'LCNG station service flow, reserve and settlement on Polygon.',
      ),
      TerminalInfo(
        id: 'AKT-DC-01',
        name: 'Aktobe DC Island 01',
        country: 'Kazakhstan',
        networkName: 'Polygon L2',
        chainId: 137,
        assetType: 'dc',
        serviceTypes: ['compute', 'sla'],
        pricingNote:
            'DC island reserve for compute and autonomous SLA capacity.',
      ),
      TerminalInfo(
        id: 'SE-DC-01',
        name: 'Sweden DC Node 01',
        country: 'Sweden',
        networkName: 'Polygon L2',
        chainId: 137,
        assetType: 'dc',
        serviceTypes: ['compute', 'sla'],
        pricingNote:
            'Sweden DC node reserve for compute and autonomous SLA capacity.',
      ),
    ];
  }

  Future<TerminalReserveResult> reserve({
    required TerminalInfo terminal,
    required TerminalReserveDraft draft,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return TerminalReserveResult(
      ok: true,
      message: 'Reserve created successfully on Polygon (mock stage).',
      terminalId: terminal.id,
      reservedAmount: draft.reserveAmount,
      serviceType: draft.serviceType,
      txHash: '0xMOCK${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}
