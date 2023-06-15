class Mileage {
  final String name;
  final String call;
  final String type;
  final int amount;
  final String date;

  Mileage({
    required this.name,
    required this.call,
    required this.type,
    required this.amount,
    required this.date,
  });

  factory Mileage.fromJson(Map<String, dynamic> json) {
    return Mileage(
      name: json['name'],
      call: json['call'],
      type: json['type'],
      amount: json['amount'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'call': call,
    'type': type,
    'amount': amount,
    'date': date,
  };
}
