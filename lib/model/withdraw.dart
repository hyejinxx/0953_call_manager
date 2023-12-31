class Withdraw {
  final String userCall;
  final int amount;
  final String bank;
  final String account;
  final String name;
  String status;
  final String createdAt;
  int? sumMileage;

  Withdraw({
    required this.userCall,
    required this.amount,
    required this.bank,
    required this.account,
    required this.name,
    required this.status,
    required this.createdAt,
    this.sumMileage,
  });

  factory Withdraw.fromJson(Map<String, dynamic> json) {
    return Withdraw(
      userCall: json['userCall'],
      amount: json['amount'],
      bank: json['bank'],
      account: json['account'],
      name: json['name'],
      status: json['status'],
      createdAt: json['createdAt'],
      sumMileage: json['sumMileage'],
    );
  }

  factory Withdraw.fromDB(db) => Withdraw(
    userCall: db['userCall'],
    amount: db['amount'],
    bank: db['bank'],
    account: db['account'],
    name: db['name'],
    status: db['status'],
    createdAt: db['createdAt'],
    sumMileage: db['sumMileage'],
  );

  Map<String, dynamic> toJson() => {
    'userCall': userCall,
    'amount': amount,
    'bank': bank,
    'account': account,
    'name': name,
    'status': status,
    'createdAt': createdAt,
    'sumMileage': sumMileage,
  };
}
