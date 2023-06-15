import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String call;
  final String password;
  final String? destination1;
  final String? destination2;
  final String createdAt;
  final String? store;
  final String? city;
  final String? storecall;
  final int mileage;
  final String? recommendUser;
  final String? memo;

  User({
    required this.name,
    required this.call,
    required this.password,
    this.destination1,
    this.destination2,
    required this.createdAt,
    this.store,
    this.city,
    this.storecall,
    required this.mileage,
    this.recommendUser,
    this.memo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      call: json['call'],
      password: json['password'],
      destination1: json['destination1'],
      destination2: json['destination2'],
      createdAt: json['createdAt'],
      store: json['store'],
      city: json['city'],
      storecall: json['storecall'],
      mileage: json['mileage'],
      recommendUser: json['recommendUser'],
      memo: json['memo'],
    );
  }

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    return User(
      name: data['name'],
      call: data['call'],
      password: data['password'],
      destination1: data['destination1'],
      destination2: data['destination2'],
      createdAt: data['createdAt'],
      store: data['store'],
      city: data['city'],
      storecall: data['storecall'],
      mileage: data['mileage'],
      recommendUser: data['recommendUser'],
      memo: data['memo'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'call': call,
    'password': password,
    'destination1': destination1,
    'destination2': destination2,
    'createdAt': createdAt,
    'store': store,
    'city': city,
    'storecall': storecall,
    'mileage': mileage,
    'recommendUser': recommendUser,
    'memo': memo,
  };
}