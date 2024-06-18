import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String call;
  final String password;
  final String? destination;
  final String createdAt;
  final String? store;
  final String? storeCall;
  final String? storeAddress;
  final int mileage;
  final String? recommendUser;
  final String? memo;

  User({
    required this.name,
    required this.call,
    required this.password,
    this.destination,
    required this.createdAt,
    this.store,
    this.storeCall,
    this.storeAddress,
    required this.mileage,
    this.recommendUser,
    this.memo,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        call: json['call'],
        password: json['password'],
        destination: json['destination'],
        createdAt: json['createdAt'],
        store: json['store'],
        storeCall: json['storeCall'],
        storeAddress: json['storeAddress'],
        mileage: json['mileage'],
        recommendUser: json['recommendUser'],
        memo: json['memo'],
      );

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    return User(
      name: data['name'],
      call: data['call'],
      password: data['password'],
      destination: data['destination'],
      createdAt: data['createdAt'],
      store: data['store'],
      storeCall: data['storeCall'],
      storeAddress: data['storeAddress'],
      mileage: data['mileage'],
      recommendUser: data['recommendUser'],
      memo: data['memo'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'call': call,
        'password': password,
        'destination': destination,
        'createdAt': createdAt,
        'store': store,
        'storeCall': storeCall,
        'storeAddress': storeAddress,
        'mileage': mileage,
        'recommendUser': recommendUser,
        'memo': memo,
      };
}
