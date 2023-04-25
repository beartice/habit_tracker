import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/mood_tracker_page.dart';
import 'package:habit_tracker/pages/wellness_tracker_page.dart';

import 'habit_tracker_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _pageViewController = PageController();

  //changes index when you tap navbar
  void _onItemTapped(int index) {
    _pageViewController.animateToPage(index,
        duration: Duration(milliseconds: 100), curve: Curves.bounceOut);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  static const List<Widget> _pages = <Widget>[
    HabitTrackerPage(),
    MoodTrackerPage(),
    WellnessTrackerPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Habit"),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_emotions), label: "Mood"),
          BottomNavigationBarItem(
              icon: Icon(Icons.medical_services), label: "Wellness")
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: PageView(
        controller: _pageViewController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
