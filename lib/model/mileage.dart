class Mileage {
  final String orderNumber;
  final String name;
  final String call;
  final String type;
  final int amount;
  final String date;

  Mileage({
    required this.orderNumber,
    required this.name,
    required this.call,
    required this.type,
    required this.amount,
    required this.date,
  });

  factory Mileage.fromJson(Map<String, dynamic> json) {
    return Mileage(
      orderNumber: json['orderNumber'],
      name: json['name'],
      call: json['call'],
      type: json['type'],
      amount: int.parse(json['amount'].toDouble()),
      date: json['date'],
    );
  }

  factory Mileage.fromDB(db){
    return Mileage(
      orderNumber: db['orderNumber'],
      name: db['name'],
      call: db['call'],
      type: db['type'],
      amount: db['amount'],
      date: db['date'],
    );
  }

  Map<String, dynamic> toJson() => {
    'orderNumber': orderNumber,
    'name': name,
    'call': call,
    'type': type,
    'amount': amount,
    'date': date,
  };
}

