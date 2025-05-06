import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'notification_screen.dart';
import 'security_screen.dart';
import 'privacy_policy_screen.dart';
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
          UserOption(
            icon: Icons.edit,
            text: 'Edit Profile',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => EditProfileScreen()));
            },
          ),
          UserOption(
            icon: Icons.notifications,
            text: 'Notification',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => NotificationScreen()));
            },
          ),
          UserOption(
            icon: Icons.security,
            text: 'Security',
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SecurityScreen()));
            },
          ),
          UserOption(
            icon: Icons.privacy_tip,
            text: 'Privacy Policy',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => PrivacyPolicyScreen()));
            },
          ),
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
      title: Text('Sara Mohamed'),
      subtitle: Text('sara_mohamed@gmail.com'),
    );
  }
}

class UserOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const UserOption({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      leading: Icon(icon),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
