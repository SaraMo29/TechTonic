import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import 'edit_profile_screen.dart';
import 'notification_screen.dart';
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
    final loginController = Get.find<LoginController>();
    return Obx(
      () => Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: loginController.userProfileImage.value.isNotEmpty
                ? NetworkImage(loginController.userProfileImage.value)
                : null,
            child: loginController.userProfileImage.value.isEmpty
                ? Icon(Icons.person, size: 40)
                : null,
          ),
          SizedBox(height: 12),
          Text(
            loginController.userName.value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            loginController.userEmail.value,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
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
