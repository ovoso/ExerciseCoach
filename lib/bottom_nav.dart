import 'package:exercisecoach/exercise_info_page.dart';
import 'package:exercisecoach/profile_screen.dart';
import 'package:exercisecoach/screens/bmi/calculate_BMI.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// Stateful widget for the bottom navigation bar
class BottomNav extends StatefulWidget {
  BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  // Keeps track of the selected page displayed
  int _currentIndex = 0;
  late PageController _pageController;
  late List<Widget> _screens;

  // Handles the tap event on the navigation bar items
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      // Animate to the selected page
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    // Initialize the list of screens
    _screens = [
      const ExerciseInfoPage(),
      const BMI(),
      const ProfileScreen(userId: 'your_user_id_here'),
    ];
    // Initialize the page controller with the initial page
    _pageController = PageController(initialPage: _currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bottom navigation bar with curved design
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFF40D876),
        buttonBackgroundColor: const Color(0xFF40D876),
        color: const Color(0xFF212121),
        onTap: _onItemTapped,
        items: const [
          Icon(
            Icons.home,
            color: Color(0xFFFAFAFA),
          ),
          Icon(
            Icons.bar_chart,
            color: Color(0xFFFAFAFA),
          ),
          Icon(
            Icons.person,
            color: Color(0xFFFAFAFA),
          ),
        ],
      ),
      // PageView to handle page transitions
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(), // Disable manual scrolling
        controller: _pageController,
        children: _screens,
      ),
    );
  }
}
