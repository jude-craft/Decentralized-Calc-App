class TransactionResult {
  final BigInt result;
  final String? transactionHash;
  final bool isSuccess;
  final String? errorMessage;

  TransactionResult({
    required this.result,
    this.transactionHash,
    this.isSuccess = true,
    this.errorMessage,
  });

  factory TransactionResult.error(String message) {
    return TransactionResult(
      result: BigInt.zero,
      isSuccess: false,
      errorMessage: message,
    );
  }
}