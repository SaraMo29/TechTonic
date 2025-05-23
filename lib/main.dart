import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/controllers/book_mark_controller.dart';
import 'package:graduation_project/controllers/login_controller.dart';
import 'package:graduation_project/controllers/theme_controller.dart';
import 'package:graduation_project/screens/loginScreen.dart';
import 'package:graduation_project/screens/splash_screen.dart';
import 'package:graduation_project/screens/forgot_password_screen.dart';
import 'package:graduation_project/screens/otp_verification_screen.dart';
import 'package:graduation_project/screens/create_new_password_screen.dart';
import 'package:graduation_project/screens/home_screen.dart';

void main() {
  Get.put(LoginController());
  Get.put(BookmarkController());
  runApp(MyApp());
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
        initialRoute: '/splash', 
        getPages: [
          GetPage(name: '/splash', page: () => SplashScreen()),
          GetPage(name: '/login', page: () => Loginscreen()), 
          GetPage(name: '/forgot-password', page: () => ForgotPasswordScreen()),
          GetPage(name: '/otp-verification', page: () => OtpVerificationScreen()),
          GetPage(name: '/create-new-password', page: () => CreateNewPasswordScreen()),
          GetPage(name: '/home', page: () => HomeScreen()),
        ],
      );
    });
  }
}
