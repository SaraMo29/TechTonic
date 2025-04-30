import 'package:flutter/material.dart';
import '../controllers/confirm_payment_controller.dart';
import 'confirm.payment.screen.dart';

class EnrollCourseScreen extends StatefulWidget {
  final String courseId;

  const EnrollCourseScreen({Key? key, required this.courseId})
      : super(key: key);

  @override
  State<EnrollCourseScreen> createState() => _EnrollCourseScreenState();
}

class _EnrollCourseScreenState extends State<EnrollCourseScreen> {
  int selectedMethodIndex = 0;

  final List<Map<String, String>> paymentMethods = [
    {"name": "PayPal", "icon": "assets/images/paypal.png"},
    {"name": "Google Pay", "icon": "assets/images/google_pay.webp"},
    {"name": "Apple Pay", "icon": "assets/images/apple_pay.jpg"},
    {"name": "Vodafone Cash", "icon": "assets/images/vodafon.jpg"},
    {"name": "Etisalat Cash", "icon": "assets/images/Etisalat.jpg"},
  ];

  void _handleEnroll() {
    final selectedMethod = paymentMethods[selectedMethodIndex]['name'];

    if (selectedMethod == 'Vodafone Cash' ||
        selectedMethod == 'Etisalat Cash') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmPaymentScreen(
              providerName: selectedMethod!, courseId: widget.courseId),
        ),
      );
    } else {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: const Text("You have successfully enrolled in the course."),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enroll Course')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Select the payment method you want to use',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...List.generate(paymentMethods.length, (index) {
              final method = paymentMethods[index];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: method['icon']!.contains('http')
                      ? Image.network(method['icon']!, width: 32, height: 32)
                      : Image.asset(method['icon']!, width: 32, height: 32),
                  title: Text(method['name']!),
                  trailing: Radio<int>(
                    value: index,
                    groupValue: selectedMethodIndex,
                    onChanged: (value) {
                      setState(() {
                        selectedMethodIndex = value!;
                      });
                    },
                  ),
                ),
              );
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleEnroll,
                child: const Text('Enroll Course - \$40',
                    style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
