class Withdraw{
  final String usercall;
  final String amount;
  final String bank;
  final String account;
  final String status;
  final String createdAt;

  Withdraw({
    required this.usercall,
    required this.amount,
    required this.bank,
    required this.account,
    required this.status,
    required this.createdAt,
  });

  factory Withdraw.fromJson(Map<String, dynamic> json) {
    return Withdraw(
      usercall: json['usercall'],
      amount: json['amount'],
      bank: json['bank'],
      account: json['account'],
      status: json['status'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() => {
    'usercall': usercall,
    'amount': amount,
    'bank': bank,
    'account': account,
    'status': status,
    'createdAt': createdAt,
  };
}