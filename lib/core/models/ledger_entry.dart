class LedgerEntry {
  final String id;
  final String category;
  final String title;
  final String description;
  final double jertDelta;
  final DateTime createdAt;
  final String source;
  final Map<String, dynamic>? quantity;
  final String? txHash;
  final String? terminalId;
  final String? status;

  const LedgerEntry({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.jertDelta,
    required this.createdAt,
    required this.source,
    this.quantity,
    this.txHash,
    this.terminalId,
    this.status,
  });
}
