class Mileage {
  final String? orderNumber;
  final String name;
  final String call;
  final String type;
  final int amount;
  final String? date;

  Mileage({
    this.orderNumber,
    required this.name,
    required this.call,
    required this.type,
    required this.amount,
    this.date,
  });

  factory Mileage.fromJson(Map<String, dynamic> json) {
    return Mileage(
      orderNumber: json['orderNumber'],
      name: json['name'],
      call: json['call'],
      type: json['type'],
      amount: json['amount'],
      date: json['date'],
    );
  }
}
