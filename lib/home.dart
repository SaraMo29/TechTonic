import 'package:flutter/material.dart';
import 'package:graduation_project/reusable_componnent/const_textFormField.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print('Form is valid!');
      //Navigator.of(context).push(MaterialPageRoute(
      //builder: (context) => viewText(
      //  email: _emailController.text, phone: _phoneController.text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 16.0,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('lib/assets/app_icon.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              const Text(
                "Login To Your Account",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              const SizedBox(
                height: 16.0,
              ),
              CustomTextFormField(
                hintText: "Enter your Email",
                label: "Email",
                prefixIcon: Icons.email,
                controller: _emailController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
