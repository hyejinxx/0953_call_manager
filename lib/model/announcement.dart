class Announcement {
  String title;
  String description;
  String date;
  String createdAt;
  String? image;

  Announcement(
      {required this.title,
      required this.description,
      required this.date,
      required this.createdAt,
      required this.image});

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      title: json['title'],
      description: json['description'],
      date: json['date'],
      createdAt: json['createdAt'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'date': date,
    'createdAt': createdAt,
    'image': image,
  };
}
