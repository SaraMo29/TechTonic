import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
// Removed file_picker import
import 'dart:io';

class MoreCourseDetailsScreen extends StatefulWidget {
  final String title, subTitle, category, language, level;
  final String courseId;

  const MoreCourseDetailsScreen({
    super.key,
    required this.title,
    required this.subTitle,
    required this.category,
    required this.language,
    required this.level,
    required this.courseId,
  });

  @override
  State<MoreCourseDetailsScreen> createState() =>
      _MoreCourseDetailsScreenState();
}

class _MoreCourseDetailsScreenState extends State<MoreCourseDetailsScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();
  final TextEditingController whatWillBeTaughtController =
      TextEditingController();
  final TextEditingController priceAmountController = TextEditingController();

  String selectedCategory = '';
  String selectedCurrency = 'USD';
  bool isLoading = false;
  File? thumbnailFile;
  File? videoFile;
  String? thumbnailUrl;
  String? videoUrl;

  final Map<String, String> categoryMap = {
    'Software Development Tools': '682f436141b9d1788bf006f6',
    'Programming Languages': '682f437241b9d1788bf006fa',
    'Network & Security': '682f439b41b9d1788bf006fe',
    'Mobile Development': '682f43a941b9d1788bf00702',
  };

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.category;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    requirementsController.dispose();
    whatWillBeTaughtController.dispose();
    priceAmountController.dispose();
    super.dispose();
  }

  Future<void> pickThumbnail() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          thumbnailFile = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error picking image: $e")),
        );
      }
    }
  }

  Future<void> pickVideo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10),
      );

      if (video != null) {
        setState(() {
          videoFile = File(video.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error picking video: $e")),
        );
      }
    }
  }

  Future<void> updateCourseDetails() async {
    if (thumbnailFile == null || videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload both thumbnail and video")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            'https://nafsi.onrender.com/api/v1/course/${widget.courseId}'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Add files
      request.files.add(
        await http.MultipartFile.fromPath(
          'thumbnail',
          thumbnailFile!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'videoTrailer',
          videoFile!.path,
          contentType: MediaType('video', 'mp4'),
        ),
      );

      // Add text fields
      request.fields.addAll({
        'title': widget.title,
        'subTitle': widget.subTitle,
        'category': categoryMap[selectedCategory] ?? '',
        'language': widget.language,
        'level': widget.level,
        'courseDescription': descriptionController.text,
        'whatWillBeTaught': whatWillBeTaughtController.text,
        'requirements': requirementsController.text,
        'price[currency]': selectedCurrency,
        'price[amount]': priceAmountController.text,
      });

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseData);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Course details updated successfully!")),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error updating course: $responseData")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Course Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("More About Your Course",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: categoryMap.keys.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Course Thumbnail',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (thumbnailFile != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          thumbnailFile!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: pickThumbnail,
                      icon: const Icon(Icons.image),
                      label: const Text("Upload Thumbnail"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Course Video Trailer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (videoFile != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.video_file),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                videoFile!.path.split('/').last,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: pickVideo,
                      icon: const Icon(Icons.video_library),
                      label: const Text("Upload Video"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Course Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: whatWillBeTaughtController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'What Will Be Taught',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: requirementsController,
              decoration: const InputDecoration(
                labelText: 'Requirements',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedCurrency,
                    decoration: const InputDecoration(
                      labelText: 'Currency',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                      DropdownMenuItem(value: 'EGP', child: Text('EGP')),
                    ],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedCurrency = newValue;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: priceAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: updateCourseDetails,
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Save & Finish"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
