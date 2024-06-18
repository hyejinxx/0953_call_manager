class Mileage {
  final String orderNumber;
  final String name;
  final String call;
  final String type;
  final int amount;
  final String date;
  final String startAddress;
  final String endAddress;
  int sumMileage;

  Mileage({
    required this.orderNumber,
    required this.name,
    required this.call,
    required this.type,
    required this.amount,
    required this.date,
    required this.startAddress,
    required this.endAddress,
    required this.sumMileage,
  });

  factory Mileage.fromJson(Map<String, dynamic> json) {
    return Mileage(
      orderNumber: json['orderNumber'],
      name: json['name'],
      call: json['call'],
      type: json['type'],
      amount: json['amount'],
      date: json['date'],
      startAddress: json['startAddress'],
      endAddress: json['endAddress'],
      sumMileage: json['sumMileage'],
    );
  }

  factory Mileage.fromDB(db) {
    return Mileage(
      orderNumber: db['orderNumber'],
      name: db['name'],
      call: db['call'],
      type: db['type'],
      amount: db['amount'],
      date: db['date'],
      startAddress: db['startAddress'],
      endAddress: db['endAddress'],
      sumMileage: db['sumMileage'],
    );
  }

  Map<String, dynamic> toJson() => {
        'orderNumber': orderNumber,
        'name': name,
        'call': call,
        'type': type,
        'amount': amount,
        'date': date,
        'startAddress': startAddress,
        'endAddress': endAddress,
        'sumMileage': sumMileage,
      };
}
