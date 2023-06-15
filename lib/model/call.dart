class Call {
  final String orderNumber;
  final String name;
  final String call;
  final String? startAddress;
  final String? endAddress;
  final int price;
  final String? company;
  final String? date;
  final String? time;
  final int? mileage;
  final int? bonusMileage;

  Call({
    required this.orderNumber,
    required this.name,
    required this.call,
    this.startAddress,
    this.endAddress,
    required this.price,
    this.company,
    this.date,
    this.time,
    this.mileage,
    this.bonusMileage,
  });

  factory Call.fromJson(Map<String, dynamic> json) {
    return Call(
      orderNumber: json['orderNumber'],
      name: json['name'],
      call: json['call'],
      startAddress: json['startAddress'],
      endAddress: json['endAddress'],
      price: json['price'],
      company: json['company'],
      date: json['date'],
      time: json['time'],
      mileage: json['mileage'],
      bonusMileage: json['bonusMileage'],
    );
  }

  Map<String, dynamic> toJson() => {
    'orderNumber': orderNumber,
    'name': name,
    'call': call,
    'startAddress': startAddress,
    'endAddress': endAddress,
    'price': price,
    'company': company,
    'date': date,
    'time': time,
    'mileage': mileage,
    'bonusMileage': bonusMileage,
  };
}
