import 'package:flutter/material.dart';
import 'package:starsoul_app/screens/guest/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      theme: ThemeData(
        fontFamily: 'Poppins'
      ),
    );
  }
}
