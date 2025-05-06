import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/login_controller.dart'; // <-- Add this import

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final EditProfileController controller = Get.put(EditProfileController());

  @override
  void initState() {
    super.initState();
    // Set token here from your login controller
    final loginController = Get.find<LoginController>();
    controller.setToken(loginController.token.value);
    // Optionally, set initial values for name, gender, and profileImageUrl
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Obx(() => ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: controller.profileImageFile != null
                          ? FileImage(controller.profileImageFile!)
                          : (controller.profileImageUrl.value.isNotEmpty
                              ? NetworkImage(controller.profileImageUrl.value)
                              : null) as ImageProvider?,
                      child: controller.profileImageFile == null && controller.profileImageUrl.value.isEmpty
                          ? Icon(Icons.person, size: 50, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () async {
                          await controller.pickImage();
                          setState(() {});
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.camera_alt,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              TextFormField(
                initialValue: controller.name.value,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => controller.name.value = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Gender:'),
                  Radio<String>(
                    value: 'male',
                    groupValue: controller.gender.value,
                    onChanged: (value) {
                      controller.gender.value = value ?? '';
                    },
                  ),
                  Text('Male'),
                  Radio<String>(
                    value: 'female',
                    groupValue: controller.gender.value,
                    onChanged: (value) {
                      controller.gender.value = value ?? '';
                    },
                  ),
                  Text('Female'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await controller.updateProfile();
                    setState(() {});
                  }
                },
                child: Text('Update'),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to Change Password screen
                },
                child: Text(
                  'Change Password',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
