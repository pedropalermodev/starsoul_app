import 'package:flutter/material.dart';
import 'package:starsoul_app/screens/guest/welcome_page.dart';
import 'package:starsoul_app/screens/authenticated/login_page.dart';
import 'package:starsoul_app/screens/auth/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StarSoul',
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),

      },
      theme: ThemeData(
        fontFamily: 'Poppins'
      ),
    );
  }
}
