import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Map<String, bool> switches = {
    'General Notification': true,
    'Sound': false,
    'Vibrate': false,
    'Special Offers': true,
    'Promo & Discount': false,
    'Payments': true,
    'Cashback': false,
    'App Updates': true,
    'New Service Available': false,
    'New Tips Available': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: ListView(
        children: switches.entries.map((entry) {
          return SwitchListTile(
            title: Text(entry.key),
            value: entry.value,
            onChanged: (val) {
              setState(() {
                switches[entry.key] = val;
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
