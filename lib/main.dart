import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/controllers/theme_controller.dart';
import 'package:graduation_project/screens/splash_screen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
   MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeController.theme,
        home: SplashScreen(),
      );
    });
  }
}
