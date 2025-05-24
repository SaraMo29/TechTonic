import 'package:flutter/material.dart';
import 'package:graduation_project/components/notification_card.dart';
import 'package:graduation_project/components/notification_item.dart';
import 'package:graduation_project/screens/home_screen.dart';


class Notifyscreen extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem("Payment Successful!", "You have made a course payment", Icons.payment, Colors.blue, "Today"),
    NotificationItem("Today's Special Offers", "You get a special promo today!", Icons.local_offer, Colors.yellow, "Today"),
    NotificationItem("New Category Courses!", "Now the Java course is available", Icons.category, Colors.red, "Yesterday"),
    NotificationItem("Credit Card Connected!", "Credit Card has been linked!", Icons.credit_card, Colors.blue, "Yesterday"),
    NotificationItem("Account Setup Successful!", "Your account has been created!", Icons.account_circle, Colors.green, "December 22, 2024"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification", style:  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
                     Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  HomeScreen(),
                    ),
                  );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return NotificationCard(notification: notifications[index]);
          },
        ),
      ),
    );
  }
}
