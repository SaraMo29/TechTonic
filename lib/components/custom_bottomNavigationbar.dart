import 'package:flutter/material.dart';
import 'package:graduation_project/screens/home_screen.dart';
import 'package:graduation_project/screens/my_courses_screen.dart';
import 'package:graduation_project/screens/profile_screen.dart';
import 'package:graduation_project/screens/transaction_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      showUnselectedLabels: true,
      iconSize: 32,
      selectedItemColor: Colors.blue,
      selectedFontSize: 18,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyCoursesScreen()),
            );
            break;
            case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TransactionScreen()),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment),
          label: 'My Course',
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Transaction',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}