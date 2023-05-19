import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hearty_app/screens/activity_screen.dart';
import 'package:hearty_app/screens/food_screen.dart';
import 'package:hearty_app/screens/signin_screen.dart';
import 'package:hearty_app/screens/signup_screen.dart';
import 'package:hearty_app/screens/sleep_screen.dart';
import 'package:hearty_app/screens/survey_screen.dart';

import 'home_screen.dart';

class Navigate extends StatefulWidget {
  @override
  _NavigateState createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeScreen(),
    FoodScreen(),
    ActivityScreen(),
    SleepScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color whichScreen() {
      if (_currentIndex == 0) {
        return Color.fromARGB(234, 246, 174, 245);
      }
      if (_currentIndex == 1) {
        return Color.fromARGB(255, 248, 178, 88);
      }
      if (_currentIndex == 2) {
        return Color.fromARGB(220, 119, 208, 228);
      } else {
        return Color.fromARGB(220, 45, 7, 114);
      }
    }

    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: whichScreen(),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_sharp),
            label: 'Food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk_sharp),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Transform.rotate(
              angle: -3.14 / 4,
              child: Icon(Icons.nightlight_round_sharp),
            ),
            label: 'Sleep',
          ),
        ],
      ),
    );
  }
}
