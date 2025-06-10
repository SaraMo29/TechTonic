// lesson.dart
class Lesson {
  final String id;
  final String name;
  final int durationMinutes;
  final bool isFree;
  final String fileUrl;

  Lesson({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.isFree,
    required this.fileUrl,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['_id'],
      name: json['name'],
      durationMinutes: json['duration']['minutes'],
      isFree: json['isFree'],
      fileUrl: json['file']['path'],
    );
  }
}
