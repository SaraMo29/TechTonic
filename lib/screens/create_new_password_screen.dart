// screens/create_new_password_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/components/const_passTextFormField.dart';
import 'package:graduation_project/components/custom_textFormField.dart';
import 'package:graduation_project/controllers/login_controller.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  _CreateNewPasswordScreenState createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final LoginController loginController = Get.find();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String email = Get.arguments['email'];
    final String otp = Get.arguments['otp'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Password", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
            Center(child: Image.asset("assets/images/forgot_password_code.jpg")),
            const SizedBox(height: 20),
            const Text("Create Your New Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            CustomPassTextfield(
              textEditingController: _passwordController,
              
              
              
            ),
            const SizedBox(height: 10),
            CustomPassTextfield(
              textEditingController: _confirmPasswordController,
              
        
            ),
            const SizedBox(height: 20),
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: loginController.isLoading.value
                    ? null
                    : () {
                        final password = _passwordController.text;
                        final confirmPassword = _confirmPasswordController.text;
                        if (password != confirmPassword || password.length < 8) {
                          Get.snackbar("Error", "Passwords must match and be at least 8 characters");
                        } else {
                          loginController.resetPassword(email, otp, password);
                        }
                      },
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