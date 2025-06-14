import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/components/const_passTextFormField.dart';
import 'package:graduation_project/components/custom_textFormField.dart';
import 'package:graduation_project/controllers/regestration_controller.dart';
import 'package:graduation_project/screens/InstructorApplicationPage.dart';
import 'package:graduation_project/screens/loginScreen.dart';


class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

bool rememberme = false;

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  RegistrationController registerationController = Get.put(RegistrationController());



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Your Account',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/startpage.png",
                  width: 300,
                  height: 300,
                ),
                CustomTextFormField(
                  textEditingController: registerationController.nameController,
                  'name',
                  lable: 'User Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  textEditingController: registerationController.emailController,
                  'email address',
                  lable: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 20),
                CustomPassTextfield(
                  textEditingController: registerationController.passwordController,
                ),
                const SizedBox(height: 20),
               
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      activeColor: Colors.blue,
                      value: rememberme,
                      onChanged: (bool? value) {
                        setState(() {
                          rememberme = value ?? false;
                        });
                      },
                    ),
                    const Text('Remember me'),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
  onPressed: () {
    Get.to(() => const InstructorApplicationPage());
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    minimumSize: Size(screenWidth * 0.8, 50),
  ),
  child: const Text(
    'Sign up',
    style: TextStyle(fontSize: 18, color: Colors.white),
  ),
),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account ? ",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}