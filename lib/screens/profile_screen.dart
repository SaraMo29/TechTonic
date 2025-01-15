import 'package:flutter/material.dart';
import 'package:graduation_project/screens/loginScreen.dart';
import 'package:graduation_project/screens/startPage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          UserHeader(),
          UserOption(icon: Icons.edit, text: 'Edit Profile'),
          UserOption(icon: Icons.notifications, text: 'Notification'),
          UserOption(icon: Icons.payment, text: 'Payment'),
          UserOption(icon: Icons.security, text: 'Security'),
          UserOption(icon: Icons.privacy_tip, text: 'Privacy Policy'),
          UserOption(icon: Icons.help, text: 'Help Center'),
          UserOption(icon: Icons.people, text: 'Invite Friends'),
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => StartPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class UserHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage('assets/images/myphoto.jpg'),
      ),
      title: const Text('Sara Mohamed'),
      subtitle: Text('sara_mohamed@gmail.com'),
    );
  }
}

class UserOption extends StatelessWidget {
  final IconData icon;
  final String text;

  UserOption({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      leading: Icon(icon),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
