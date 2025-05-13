import 'package:flutter/material.dart';
import 'e_receipt_screen.dart';

class TransactionScreen extends StatelessWidget {
  final List<Map<String, String>> transactions = [
    {"title": "Mastering Figma A to Z"},
    {"title": "Mastering Blender 3D"},
    {"title": "Build Personal Branding"},
    {"title": "Complete UI Designer"},
    {"title": "Full-Stack Web Developer"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage("assets/images/startpage.png"),
                ),
                title: Text(
                  transactions[index]['title']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EReceiptScreen(
                          courseTitle: transactions[index]['title']!,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text("E-Receipt"),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
                indent: 16,
                endIndent: 16,
              ),
            ],
          );
        },
      ),
    );
  }
}
