import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/course_details.controller.dart';

class ReviewsContent extends StatelessWidget {
  const ReviewsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final CourseDetailsController controller =
        Get.find<CourseDetailsController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.reviews.isEmpty) {
        return const Center(
            child: Text("No reviews available for this course"));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.reviews.length,
        itemBuilder: (context, index) {
          final review = controller.reviews[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          review['userImage'] != null &&
                                  review['userImage'].isNotEmpty
                              ? review['userImage']
                              : 'https://via.placeholder.com/150',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review['userName'] ?? 'Anonymous',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                // Convert rating to double and handle decimal stars
                                ...List.generate(
                                  double.parse(review['rating'] ?? '0').floor(),
                                  (i) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                ),
                                // Show half star if needed
                                if ((double.parse(review['rating'] ?? '0') %
                                        1) >=
                                    0.5)
                                  const Icon(
                                    Icons.star_half,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                // Empty stars to complete 5 stars
                                ...List.generate(
                                  5 -
                                      double.parse(review['rating'] ?? '0')
                                          .ceil(),
                                  (i) => const Icon(
                                    Icons.star_border,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  review['rating'] ?? '0.0',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    review['content'] ?? 'No review content',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
