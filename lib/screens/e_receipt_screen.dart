import 'package:flutter/material.dart';

class EReceiptScreen extends StatelessWidget {
  final String courseTitle;

  const EReceiptScreen({Key? key, required this.courseTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Receipt"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.qr_code, size: 100, color: Colors.black),
            ),
            const SizedBox(height: 24),
            buildRow("Course", courseTitle),
            buildRow("Category", "UI/UX Design"),
            buildRow("Name", "Andrew Ainsley"),
            buildRow("Email", "andrew_ainsley@domain.com"),
            buildRow("Price", "\$40.00"),
            buildRow("Payment", "Credit Card"),
            buildRow("Date", "Dec 14, 2024 | 14:27 PM"),
            buildRow("Transaction ID", "SK7263727399"),
            buildRow("Status", "Paid"),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
