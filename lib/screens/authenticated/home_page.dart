import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/screens/services/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3C5DB7), Color(0xFF1A2951)],
          ),
        ),

        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),

        child: Column(
          children: [
            SizedBox(height: 40),

            Center(
              child: Image.asset(
                'assets/mark/combinationmark-white.png',
                height: 20,
              ),
            ),

            SizedBox(height: 20),

            Text(
              'Bem-vindo, ${userProvider.userName ?? 'Usuário'}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(color: Color(0xFF1A2951)),
    );
  }
}
