import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

class SwitchThemeButton extends StatelessWidget {
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IconButton(
        icon: Icon(
          themeController.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
          color:
              themeController.isDarkMode.value ? Colors.yellow : Colors.black,
        ),
        onPressed: () {
          themeController.toggleTheme();
        },
      );
    });
  }
}
