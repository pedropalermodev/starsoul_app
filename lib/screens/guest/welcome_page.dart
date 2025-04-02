import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  void handleLogin() {

  }

  void handleRegister() {

  }

  // - - - - 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/welcome.png'),
          )
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
                      SizedBox(height: 15,),
                      Text(
                        'Bem vindo a StarSoul!',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF)
                        ),
                      ),
                    ],
                  ),
                ),

                // - - - - - - - - - 

                Container(
                  child: Column(
                    children: [
                      Text(
                        'Começar',
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),

                      SizedBox(height: 10,),

                      SizedBox(
                        width: 45,
                        height: 45,
                        child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pushNamed('/user_experience'), 
                        child: Center(
                          child: Container(
                            width: 45,
                            height: 45,
                            padding: EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/elements/arrow-welcome.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
                        )
                      ),

                      SizedBox(height: 20,),

                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pushNamed('/login'), 
                        child: Center(
                          child: Text(
                            'Já possuo uma conta',
                            style: TextStyle( color: Color(0xFFFFFFFF)),
                            ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(Color(0xFF1A2951)),
                        ),
                      )
                      )
                    ],
                  ),
                )
              ],
            ),
            ),
          ),
        ),
      ),
    ) ;
  }
}