import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/screens/services/user_provider.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserStatus();
    });
  }

  Future<void> _checkUserStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUserFromToken(); // Carrega os dados do token

    if (userProvider.isAuthenticated) {
      Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
    } else {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/welcome', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3C5DB7), Color(0xFF1A2951)],
          ),
        ),
        child: Center(
          child: Image.asset('assets/mark/logo.png', width: 150, height: 150),
        ),
      ),
    );
  }
}
