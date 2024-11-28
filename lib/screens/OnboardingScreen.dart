import 'package:flutter/material.dart';
import 'package:graduation_project/screens/loginScreen.dart';
import 'package:graduation_project/components/const_page_view_model.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
          pages: [
            ConstPageViewModel.createPage(
                body: "Learn anytime and anywhere easily and conveniently",
                imagePath: "assets/images/page1.jpg"),
            ConstPageViewModel.createPage(
                body: "Explore different learning tracks",
                imagePath: "assets/images/page2.jpg"),
            ConstPageViewModel.createPage(
                body: "Start your learning journey with TechTonic right now!",
                imagePath: "assets/images/page3.jpg"),
          ],
          onDone: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const Loginscreen()),
            );
          },
          showNextButton: true,
          next: const Text("Next", style: TextStyle(color: Colors.white)),
          done: const Text("Get Started",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          showBackButton: true,
          back: const Text(
            "Back",
            style: TextStyle(color: Colors.white),
          ),
          dotsDecorator: DotsDecorator(
            activeColor: Colors.blue,
            size: const Size.square(8.0),
            activeSize: const Size(18.0, 8.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          globalBackgroundColor: Colors.white,
          nextFlex: 0,
          skipOrBackFlex: 0,
          dotsFlex: 2,
          nextStyle: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          doneStyle: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          backStyle: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          )),
    );
  }
}
