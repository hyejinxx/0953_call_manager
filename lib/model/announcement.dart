class Announcement {
  String title;
  String content;
  String date;
  String createdAt;
  String? image;

  Announcement({required this.title, required this.content, required this.date, required this.createdAt, required this.image});

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      title: json['title'],
      content: json['content'],
      date: json['date'],
      createdAt: json['createdAt'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'date': date,
        'createdAt': createdAt,
        'image': image,
      };
}
