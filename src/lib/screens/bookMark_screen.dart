import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/components/cours_card.dart';
import 'package:graduation_project/controllers/book_mark_controller.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final BookmarkController controller = Get.find<BookmarkController>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Bookmark'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: '3D Design'),
              Tab(text: 'Business'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildCourseList(controller, 'All'),
            buildCourseList(controller, '3D Design'),
            buildCourseList(controller, 'Business'),
          ],
        ),
      ),
    );
  }

  Widget buildCourseList(BookmarkController controller, String? category) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.errorMessage.value.isNotEmpty) {
        return Center(child: Text(controller.errorMessage.value));
      }
      final filteredCourses = controller.filterCoursesByCategory(category);
      if (filteredCourses.isEmpty) {
        return const Center(child: Text('No courses found'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredCourses.length,
        itemBuilder: (context, index) {
          final course = filteredCourses[index];
          return CourseCard(
            id: course['id'] ?? '',
            title: course['title'] ?? 'Untitled',
            price: course['price'] ?? '0',
            discountPrice: course['discountPrice'],
            image: course['image'] ?? '',
            rating: course['rating'] ?? '0.0',
            students: course['students'],
            instructorName: course['instructorName'] ?? 'Unknown Instructor',
            isBookMarked: course['isBookMarked'] ?? true,
            onBookmarkToggle: () => controller.toggleBookmark(
                course['id'], course['isBookMarked'] ?? true),
          );
        },
      );
    });
  }
}