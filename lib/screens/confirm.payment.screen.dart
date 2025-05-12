import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/confirm_payment_controller.dart';
import 'course_content.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  final String providerName;
  final String courseId;

  const ConfirmPaymentScreen({
    Key? key,
    required this.providerName,
    required this.courseId,
  }) : super(key: key);

  @override
  State<ConfirmPaymentScreen> createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  int activeButtonIndex = 0;
  final ConfirmPaymentController controller =
      Get.put(ConfirmPaymentController());

  Future<void> _processPayment() async {
    bool success = await controller.processPayment(widget.courseId);

    if (success) {
      _showSuccessDialog(controller.getReceiptData());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.errorMessage.value)),
      );
    }
  }

  void _showSuccessDialog(Map<String, dynamic> receiptData) {
    final bool isAlreadyEnrolled =
        receiptData['Status']?.toLowerCase() == 'already enrolled';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 60, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              isAlreadyEnrolled ? 'Already Enrolled!' : 'Payment Successful!',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              isAlreadyEnrolled
                  ? 'You are already enrolled in this course.'
                  : 'You have successfully made payment and enrolled the course with ${widget.providerName}.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() => activeButtonIndex = 0);
                    // Navigate to course content screen
                    Navigator.pop(context); // Close the dialog first
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseContent(
                          id: widget.courseId,
                          title: 'Course Content', // You might want to pass the actual course title here
                          progress: 0.0, // Initial progress for a newly enrolled course
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeButtonIndex == 0
                        ? Colors.blue
                        : Colors.grey.shade300,
                    foregroundColor:
                        activeButtonIndex == 0 ? Colors.white : Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('View Course'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() => activeButtonIndex = 1);
                    _showReceiptDetails(receiptData);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeButtonIndex == 1
                        ? Colors.blue
                        : Colors.grey.shade300,
                    foregroundColor:
                        activeButtonIndex == 1 ? Colors.white : Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('View E-Receipt'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReceiptDetails(Map<String, dynamic> receiptData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('E-Receipt',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: receiptData.entries
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Text(
                            '${e.key}: ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Text('${e.value ?? "N/A"}')),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm with ${widget.providerName}'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your phone number to confirm payment',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'Eg. 01012345678',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.phoneController.text.trim().isNotEmpty) {
                    _processPayment();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter a valid phone number')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
