import 'package:graduation_project/Models/lessons.dart';

class LessonSection {
  final String id;
  final String title;
  final int durationMinutes;
  final List<Lesson> lessons;

  LessonSection({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.lessons,
  });

  factory LessonSection.fromJson(Map<String, dynamic> json) {
    var modulesList = json['modules'] as List? ?? []; 
    List<Lesson> lessons = modulesList
        .map((lessonJson) => Lesson.fromJson(lessonJson))
        .toList();

    return LessonSection(
      id: json['_id'],
      title: json['title'],
      durationMinutes: json['sectionDuration']['minutes'],
      lessons: lessons,
    );
  }
}
