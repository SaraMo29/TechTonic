import 'package:flutter/material.dart';
import 'package:graduation_project/components/const_passTextFormField.dart';
import 'package:graduation_project/components/custom_button.dart';
import 'package:graduation_project/components/custom_textFormField.dart';
import 'package:graduation_project/screens/create_account_screen.dart';
import 'package:graduation_project/screens/home_screen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<Loginscreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Login to your Account',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/startpage.png",
                width: 300,
                height: 300,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    const CustomTextFormField(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const CustomPassTextfield(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        const Text(
                          'Remember me',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomButton(
                      onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                  },
                      textButton: 'Sign In',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an Account?",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateAccountScreen(),
                              ),
                            );
                          },
                          child: TextButton(
                            child: const Text(
                              "Sign up",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateAccountScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
