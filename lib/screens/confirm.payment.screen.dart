import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/confirm_payment_controller.dart';
import '../controllers/transaction_controller.dart';
import '../controllers/enrolled_courses_controller.dart';
import '../screens/course_content.dart';
import '../screens/e_receipt_screen.dart';

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
  final ConfirmPaymentController _payCtrl = Get.put(ConfirmPaymentController());
  final TransactionController _txCtrl = Get.find<TransactionController>();
  final EnrolledCoursesController _enrolledCtrl = Get.find<EnrolledCoursesController>();
  int _activeIndex = 0;

  Future<void> _processPayment() async {
    final success = await _payCtrl.processPayment(widget.courseId);
    if (success) {
      // Refresh transactions and enrolled courses after successful payment
      await _txCtrl.fetchTransactions();
      await _enrolledCtrl.fetchEnrolledCourses();
      _showSuccessDialog(_payCtrl.receiptData.value);
    } else {
      final msg = _payCtrl.errorMessage.value;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  void _showSuccessDialog(Map<String, dynamic> data) {
    final already = data['Status']?.toString().toLowerCase() == 'already enrolled';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 60, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              already ? 'Already Enrolled!' : 'Payment Successful!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              already
                  ? 'You are already enrolled in this course.'
                  : 'You have successfully made payment with ${widget.providerName}.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildActionButtons(data, already),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> data, bool already) {
    return Column(
      children: [
        _buildDialogButton(
          label: 'View Course',
          selected: _activeIndex == 0,
          onTap: () {
            setState(() => _activeIndex = 0);
            Navigator.pop(context);           // close dialog
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => CourseContent(
                  id: widget.courseId,
                  title: 'Course Content',
                  progress: 0.0,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildDialogButton(
          label: 'View E-Receipt',
          selected: _activeIndex == 1,
          onTap: () {
            setState(() => _activeIndex = 1);
            Navigator.pop(context);
            Get.off(() => ReceiptScreen(), arguments: data);
          },
        ),
      ],
    );
  }

  Widget _buildDialogButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.blue : Colors.grey.shade300,
        foregroundColor: selected ? Colors.white : Colors.blue,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
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
              controller: _payCtrl.phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'Eg. 01012345678',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_payCtrl.phoneController.text.trim().isNotEmpty) {
                    _processPayment();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid phone number')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
