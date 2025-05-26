import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void handleLogin() {}

  void handleRegister() {}

  // - - - -

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/welcome.png'),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 120, bottom: 120),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/mark/combinationmark-white.png',
                          height: 25,
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Bem vindo a StarSoul!',
                          style: TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                      ],
                    ),
                  ),

                  // - - - - - - - - -
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed:
                              () => Navigator.of(context).pushNamed('/login'),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Já possuo uma conta',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 51, 72, 129),
                                ),
                              ),
                              SizedBox(width: 8),
                              Image.asset(
                                'assets/elements/arrow-welcome.png',
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),

                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pushNamed('/'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Color(0xFF1A2951)),
                                ),
                            child: Text(
                              'Criar uma conta 🔗',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
