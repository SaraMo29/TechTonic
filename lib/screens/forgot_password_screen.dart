// screens/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/components/custom_textFormField.dart';
import 'package:graduation_project/controllers/login_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset('assets/images/forgot_password.jpg')),
            const SizedBox(height: 20),
            const Text("Enter your email to reset your password", style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            CustomTextFormField(
              textEditingController: loginController.emailController,
              'email adress',
              lable: 'Email',
              icon: Icons.email,
            ),
            const Spacer(),
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: loginController.isLoading.value ? null : loginController.sendOtp,
                child: loginController.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Continue", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}