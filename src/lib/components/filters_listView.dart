import 'package:flutter/material.dart';

class FiltersListview extends StatefulWidget {
  @override
  _FiltersListview createState() => _FiltersListview();
}

class _FiltersListview extends State<FiltersListview> {
  int selectedIndex = 0; 

  final List<String> filters = [
    "All",
    "Front End",
    "Back End",
    "UI/UX",
    "Full Stack",
    "Cyber Security",
    "Flutter",
    "Programming",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white, 
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.blue, 
                  width: 2, 
                ),
              ),
              child: Text(
                filters[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.blue, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

