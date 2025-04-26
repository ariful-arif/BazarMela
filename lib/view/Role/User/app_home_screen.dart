import 'package:flutter/material.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Center(child: Text('Home Page')),
            Center(child: Text('Search Page')),
            Center(child: Text('Notification Page')),
            Center(child: Text('Profile Page')),
          ],
        ),
      ),
    );
  }
}
