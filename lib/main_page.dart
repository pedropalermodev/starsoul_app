import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/screens/authenticated/daily_page.dart';
import 'package:starsoul_app/screens/authenticated/favorites_page.dart';
import 'package:starsoul_app/screens/authenticated/home_page.dart';
import 'package:starsoul_app/screens/authenticated/meditation_tips_page.dart';
import 'package:starsoul_app/screens/authenticated/settings_page.dart';
import 'package:starsoul_app/services/user_provider.dart';
import 'package:starsoul_app/widgets/custom_app_bar.dart';
import 'package:starsoul_app/widgets/custom_bottom_navbar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 1;
  late List<PreferredSizeWidget> appBars;

  final List<Widget> pages = const [
    FavoritesPage(),
    HomePage(),
    DailyPage(),
    MeditationTipsPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    appBars = [
      const CustomAppBar(title: 'Favoritos'),
      const CustomAppBar(showLogo: true),
      const CustomAppBar(title: 'Diário'),
      const CustomAppBar(title: 'Dicas de Meditação'),
      CustomAppBar(
        title: 'Configurações',
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () async {
              final shouldLogout = await _showConfirmLogoutDialog(context);
              if (shouldLogout == true) {
                final userProvider = Provider.of<UserProvider>(
                  context,
                  listen: false,
                );
                await userProvider.logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/welcome', (route) => false);
              }
            },
          ),
        ],
      ),
    ];
  }

  Future<bool?> _showConfirmLogoutDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Saída'),
          content: const Text('Tem certeza de que deseja sair da sua conta?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBars[currentIndex],
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: (pages[currentIndex]),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}