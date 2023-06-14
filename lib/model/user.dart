class User{
  String name;
  String call;
  String password;
  String address;
  String createdAt;
  int mileage;
  String? recommendUser;

  User({
    required this.name,
    required this.call,
    required this.password,
    required this.address,
    required this.createdAt,
    required this.mileage,
    this.recommendUser,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      call: json['call'],
      password: json['password'],
      address: json['address'],
      createdAt: json['createdAt'],
      mileage: json['mileage'],
      recommendUser: json['recommendUser'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'call': call,
    'password': password,
    'address': address,
    'createdAt': createdAt,
    'mileage': mileage,
    'recommendUser': recommendUser,
  };
}