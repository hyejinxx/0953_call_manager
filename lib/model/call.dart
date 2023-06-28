
class Call {
  final String orderNumber;
  final String name;
  final String call;
  final String? startAddress;
  final String? endAddress;
  final int price;
  final String? company;
  final String date;
  final String time;
  int? mileage;
  int? bonusMileage;
  int? sumMileage;

  Call({
    required this.orderNumber,
    required this.name,
    required this.call,
    this.startAddress,
    this.endAddress,
    required this.price,
    this.company,
    required this.date,
    required this.time,
    this.mileage,
    this.bonusMileage,
    this.sumMileage,
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
      sumMileage: json['sumMileage'],
    );
  }

  factory Call.fromDB(db){
    return Call(
      orderNumber: db['orderNumber'],
      name: db['name'],
      call: db['call'],
      startAddress: db['startAddress'],
      endAddress: db['endAddress'],
      price: db['price'],
      company: db['company'],
      date: db['date'],
      time: db['time'],
      mileage: db['mileage'],
      bonusMileage: db['bonusMileage'],
      sumMileage: db['sumMileage'],
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
    'sumMileage': sumMileage,
  };
}
