import 'package:flutter/material.dart';
import 'package:starsoul_app/screens/authenticated/daily_page.dart';
import 'package:starsoul_app/screens/authenticated/favorites_page.dart';
import 'package:starsoul_app/screens/authenticated/home_page.dart';
import 'package:starsoul_app/screens/authenticated/notifications_page.dart';
import 'package:starsoul_app/screens/authenticated/settings_page.dart';
import 'package:starsoul_app/widgets/custom_app_bar.dart';
import 'package:starsoul_app/widgets/custom_bottom_navbar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 1;

  final List<Widget> pages = const [
    FavoritesPage(),
    HomePage(),
    DailyPage(),
    NotificationsPage(),
    SettingsPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3C5DB7), Color(0xFF1A2951)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: pages[currentIndex],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
