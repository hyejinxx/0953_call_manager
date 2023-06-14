class StoreUser{
  String name;
  String call;
  String password;
  String address;
  String createdAt;

  StoreUser({
    required this.name,
    required this.call,
    required this.password,
    required this.address,
    required this.createdAt,
  });

  factory StoreUser.fromJson(Map<String, dynamic> json) {
    return StoreUser(
      name: json['name'],
      call: json['call'],
      password: json['password'],
      address: json['address'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'call': call,
    'password': password,
    'address': address,
    'createdAt': createdAt,
  };
}