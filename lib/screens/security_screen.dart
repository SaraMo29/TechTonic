import 'package:flutter/material.dart';

class SecurityScreen extends StatefulWidget {
  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool rememberMe = true;
  bool faceID = false;
  bool biometricID = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Security')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Remember me'),
            value: rememberMe,
            onChanged: (val) => setState(() => rememberMe = val),
          ),
          SwitchListTile(
            title: Text('Face ID'),
            value: faceID,
            onChanged: (val) => setState(() => faceID = val),
          ),
          SwitchListTile(
            title: Text('Biometric ID'),
            value: biometricID,
            onChanged: (val) => setState(() => biometricID = val),
          ),
          ListTile(
            title: Text('Google Authenticator'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                // Action for changing password
              },
              child: Text('Change Password'),
            ),
          ),
        ],
      ),
    );
  }
}
