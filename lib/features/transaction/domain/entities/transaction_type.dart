enum TransactionType {
  income,
  expense,
  subscription;

  String get label {
    switch (this) {
      case TransactionType.income:
        return 'INCOME';
      case TransactionType.expense:
        return 'EXPENSE';
      case TransactionType.subscription:
        return 'SUBSCRIPTION';
    }
  }

  bool get isDebit => this == expense || this == subscription;
}
