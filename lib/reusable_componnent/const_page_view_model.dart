import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class ConstPageViewModel {
  static PageViewModel createPage(
      {required String body, required String imagePath}) {
    return PageViewModel(
      title: "",
      body: body,
      image: Center(
        child: Image.asset(imagePath, height: 300.0),
      ),
      decoration: const PageDecoration(
        bodyTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        imagePadding: EdgeInsets.only(top: 40.0),
        bodyPadding: EdgeInsets.symmetric(horizontal: 20.0),
      ),
    );
  }
}
