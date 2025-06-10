import 'package:flutter/material.dart';
import 'notification_item.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0, top: 16.0),
          child: Text(
            notification.date,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[600]),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: notification.color.withOpacity(0.2),
              child: Icon(notification.icon, color: notification.color),
            ),
            title: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(notification.subtitle),
          ),
        ),
      ],
    );
  }
}
