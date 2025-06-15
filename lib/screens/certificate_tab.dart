import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/certificate_controller.dart';

class CertificateTab extends StatelessWidget {
  final String courseId;
  final double progress;
  final CertificateController certificateController =
      Get.put(CertificateController());

  CertificateTab({
    Key? key,
    required this.courseId,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = progress >= 1.0;

    return Obx(() => Center(
          child: isCompleted
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emoji_events, size: 80),
                    const SizedBox(height: 12),
                    const Text(
                      "Congratulations!\nYou've earned a certificate.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    certificateController.isLoading.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => certificateController
                                .downloadCertificate(courseId, progress),
                            child: const Text('Download Certificate'),
                          ),
                    if (certificateController.errorMessage.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          certificateController.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    if (certificateController.downloadSuccess.value)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Certificate sent to your email.',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                  ],
                )
              : const Text('Complete the course to unlock your certificate.'),
        ));
  }
}
