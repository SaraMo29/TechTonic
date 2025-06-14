import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:graduation_project/controllers/regestration_controller.dart';

class InstructorApplicationPage extends StatelessWidget {
  const InstructorApplicationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegistrationController registerationController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Become an Instructor'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Text(
                'Ready to teach and earn? Turn your knowledge into impact—join us as an instructor today!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the extra info screen before final registration
                  Get.toNamed(
                    '/instructor-extra-info',
                    arguments: {
                      'name': registerationController.nameController.text.trim(),
                      'email': registerationController.emailController.text.trim(),
                      'password': registerationController.passwordController.text.trim(),
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Share Your Knowledge',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Spacer(flex: 2),
              Align(
                alignment: Alignment.bottomLeft,
                child: TextButton(
                  onPressed: () {
                    // Register as normal user
                    registerationController.registerWithEmail('user');
                  },
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
