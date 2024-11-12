import 'package:flutter/material.dart';
import 'package:graduation_project/home.dart';
import 'package:graduation_project/reusable_componnent/const_page_view_model.dart';
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
                imagePath: "lib/assets/page1.jpg"),
            ConstPageViewModel.createPage(
                body: "Explore different learning tracks",
                imagePath: "lib/assets/page2.jpg"),
            ConstPageViewModel.createPage(
                body: "Start your learning journey with TechTonic right now!",
                imagePath: "lib/assets/page3.jpg"),
          ],
          onDone: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => Home()),
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
          // Adjust the padding for size
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
