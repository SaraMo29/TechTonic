class Mentor {
  final String name;
  final String image;
  final String job;

  Mentor({
    required this.name,
    required this.image,
    required this.job,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      job: json['job'] ?? '',
    );
  }
}
