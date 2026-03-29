class LeaseContractService {
  const LeaseContractService();

  Future<String> reserveOnPolygon({
    required String walletAddress,
    required String terminalId,
    required double amountJert,
    required String serviceType,
    required int chainId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return '0xLEASE${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<bool> settleUsage({
    required String leaseId,
    required double usedJert,
    required double refundJert,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return true;
  }

  Future<bool> refundUnused({
    required String leaseId,
    required double refundJert,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return true;
  }
}
