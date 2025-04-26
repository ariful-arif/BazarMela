import 'package:bazarmela/view/Role/User/app_home_screen.dart';
import 'package:flutter/material.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AppHomeScreen(),
    Center(child: Text('Search Page')),
    Center(child: Text('Notification Page')),
    Center(child: Text('Profile Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notification",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black38,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
