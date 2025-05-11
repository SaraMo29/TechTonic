import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String? currentPassword;
  String? newPassword;
  String? confirmPassword;
  bool _obscureText = true;

  final ChangePasswordController changePasswordController = Get.put(ChangePasswordController());

  // Add controllers
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  suffixIcon: _toggleVisibility(),
                ),
                onSaved: (value) => currentPassword = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: _toggleVisibility(),
                ),
                onSaved: (value) => newPassword = value,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  suffixIcon: _toggleVisibility(),
                ),
                onSaved: (value) => confirmPassword = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: changePasswordController.isLoading.value
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          await changePasswordController.changePassword(
                            currentPassword: (currentPassword ?? '').trim(),
                            newPassword: newPasswordController.text.trim(),
                            confirmPassword: confirmPasswordController.text.trim(),
                          );
                        }
                      },
                child: changePasswordController.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Update Password'),
              )),
            ],
          ),
        ),
      ),
    );
  }

  IconButton _toggleVisibility() {
    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }
}
