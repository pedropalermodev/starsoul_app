import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/main_page.dart';
import 'package:starsoul_app/screens/services/user_provider.dart';
import 'package:starsoul_app/screens/guest/loading_page.dart';
import 'package:starsoul_app/screens/guest/welcome_page.dart';
import 'package:starsoul_app/screens/auth/login_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StarSoul',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingPage(),
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/main': (context) => const MainPage(),
      },
      theme: ThemeData(fontFamily: 'Poppins'),
    );
  }
}
