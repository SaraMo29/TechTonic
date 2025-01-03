import 'package:flutter/material.dart';
import 'package:graduation_project/components/switch_theme_button.dart';
import 'package:graduation_project/screens/create_account_screen.dart';
import 'package:graduation_project/screens/loginScreen.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SwitchThemeButton(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                "assets/images/startpage.png",
                width: 350,
                height: 350,
              ),
              const SizedBox(height: 20),
              const Text(
                "Let's you in",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Loginscreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "  Sign in with password  ",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account ?",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  Builder(builder: (context) {
                    return TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateAccountScreen()),
                        );
                      },
                      child: const Text(
                        "Sign UP ",
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    );
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
