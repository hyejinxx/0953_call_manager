class FAQ {
  final String question;
  String answer;
  final String createdAt;
  final String writer;
  final String state;
  final String? image;

  FAQ({
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.writer,
    required this.state,
    this.image,
  });

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      question: json['question'],
      answer: json['answer'],
      createdAt: json['createdAt'],
      writer: json['writer'],
      state: json['state'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'answer': answer,
        'createdAt': createdAt,
        'writer': writer,
        'state': state,
        'image': image,
      };
}
