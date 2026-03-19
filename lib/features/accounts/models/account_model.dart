class Account {
  final int? id;
  final String accountName;
  final String holderName;
  final String accountNumber;
  final double balance;

  Account({
    this.id,
    required this.accountName,
    required this.holderName,
    required this.accountNumber,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'account_name': accountName,
      'holder_name': holderName,
      'account_number': accountNumber,
      'balance': balance,
    };
  }
}


