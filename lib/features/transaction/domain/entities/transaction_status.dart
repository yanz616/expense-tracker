enum TransactionStatus {
  pending,
  settled;

  String get label {
    switch (this) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.settled:
        return 'Settled';
    }
  }
}
