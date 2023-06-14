class Call {
  final String name;
  final String call;

  Call({required this.name, required this.call});

  factory Call.fromJson(Map<String, dynamic> json) {
    return Call(
      name: json['name'],
      call: json['call'],
    );
  }
}
