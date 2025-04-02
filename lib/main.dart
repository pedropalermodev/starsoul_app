import 'package:flutter/material.dart';
import 'package:starsoul_app/screens/authenticated/login_page.dart';
import 'package:starsoul_app/screens/guest/user_experience_form/user_experience_form_page.dart';
import 'package:starsoul_app/screens/guest/welcome_page.dart';

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
        '/user_experience': (context) => UserExperienceFormPage(),
        '/login': (context) => LoginPage(),
      },
      theme: ThemeData(
        fontFamily: 'Poppins'
      ),
    );
  }
}
