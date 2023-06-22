class Withdraw {
  final String? num;
  final String userCall;
  final int amount;
  final String bank;
  final String account;
  final String name;
  String status;
  final String createdAt;

  Withdraw({
    this.num,
    required this.userCall,
    required this.amount,
    required this.bank,
    required this.account,
    required this.name,
    required this.status,
    required this.createdAt,
  });

  factory Withdraw.fromJson(Map<String, dynamic> json) {
    return Withdraw(
      num: json['num'],
      userCall: json['userCall'],
      amount: json['amount'],
      bank: json['bank'],
      account: json['account'],
      name: json['name'],
      status: json['status'],
      createdAt: json['createdAt'],
    );
  }

  factory Withdraw.fromDB(db) => Withdraw(
        num: db['num'],
    userCall: db['userCall'],
        amount: db['amount'],
        bank: db['bank'],
        account: db['account'],
        name: db['name'],
        status: db['status'],
        createdAt: db['createdAt'],
      );

  Map<String, dynamic> toJson() => {
        'num': num,
        'userCall': userCall,
        'amount': amount,
        'bank': bank,
        'account': account,
        'name': name,
        'status': status,
        'createdAt': createdAt,
      };
}
