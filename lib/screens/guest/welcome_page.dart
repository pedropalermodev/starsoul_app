import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/services/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.isAuthenticated) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    });
  }

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
                            onPressed: () {
                              final Uri url = Uri.parse(
                                'https://starsoul.netlify.app/sign-up',
                              );
                              launchUrl(url);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Color(0xFF1A2951),
                              ),
                            ),
                            child: Text(
                              'Criar uma conta',
                              style: TextStyle(color: Colors.white),
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
