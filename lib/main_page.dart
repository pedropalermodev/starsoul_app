import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starsoul_app/screens/authenticated/daily_page.dart';
import 'package:starsoul_app/screens/authenticated/favorites_page.dart';
import 'package:starsoul_app/screens/authenticated/home_page.dart';
import 'package:starsoul_app/screens/authenticated/meditation_tips_page.dart';
import 'package:starsoul_app/screens/authenticated/settings_page.dart';
import 'package:starsoul_app/services/content_provider.dart';
import 'package:starsoul_app/services/favorites_provider.dart';
import 'package:starsoul_app/services/history_provider.dart';
import 'package:starsoul_app/services/user_provider.dart';
import 'package:starsoul_app/widgets/custom_app_bar.dart';
import 'package:starsoul_app/widgets/custom_bottom_navbar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> with WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this);

    appBars = [
      CustomAppBar(title: 'Favoritos', currentIndex: currentIndex),
      CustomAppBar(showLogo: true, currentIndex: currentIndex),
      CustomAppBar(title: 'Diário', currentIndex: currentIndex),
      CustomAppBar(showLogo: true, currentIndex: currentIndex),
      CustomAppBar(
        title: 'Configurações',
        currentIndex: currentIndex,
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
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/welcome', (route) => false);
              }
            },
          ),
        ],
      ),
    ];
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 🔥 Quando o app volta para frente (ex: depois de usar o Chrome)
      _refreshAllProviders();
    }
  }

  Future<void> _refreshAllProviders() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final historyProvider = Provider.of<HistoryProvider>(
      context,
      listen: false,
    );
    final contentProvider = Provider.of<ContentProvider>(
      context,
      listen: false,
    );
    final favoritesProvider = Provider.of<FavoritesProvider>(
      context,
      listen: false,
    );

    final token = userProvider.userToken;

    if (token != null) {
      await Future.wait([
        userProvider.loadUserFromToken(),
        historyProvider.loadHistory(token, forceRefresh: true),
        contentProvider.loadContents(forceRefresh: true),
        favoritesProvider.loadFavorites(token, forceRefresh: true),
      ]);
    }
  }

  Future<bool?> _showConfirmLogoutDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Confirmar Saída',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Tem certeza de que deseja sair da sua conta?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Sair', style: TextStyle(color: Colors.white)),
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
    final Color backgroundColor =
        currentIndex == 3 ? const Color(0xFF233A66) : Colors.transparent;

    final BoxDecoration backgroundDecoration =
        currentIndex == 3
            ? const BoxDecoration(color: Color(0xFF233A66))
            : const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF3C5DB7), Color(0xFF1A2951)],
              ),
            );

    PreferredSizeWidget currentAppBar = CustomAppBar(
      title:
          currentIndex == 0
              ? 'Favoritos'
              : currentIndex == 1
              ? null
              : currentIndex == 2
              ? 'Diário'
              : currentIndex == 3
              ? null
              : 'Configurações',
      showLogo: currentIndex == 1 || currentIndex == 3,
      currentIndex: currentIndex,
      actions:
          currentIndex == 4
              ? [
                IconButton(
                  icon: const Icon(Icons.exit_to_app, color: Colors.white),
                  onPressed: () async {
                    final shouldLogout = await _showConfirmLogoutDialog(
                      context,
                    );
                    if (shouldLogout == true) {
                      await clearAllCache();
                      final userProvider = Provider.of<UserProvider>(
                        context,
                        listen: false,
                      );
                      await userProvider.logout();
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/welcome', (route) => false);
                    }
                  },
                ),
              ]
              : null,
    );

    return Scaffold(
      appBar: currentAppBar,
      body: Container(
        width: double.infinity,
        decoration: backgroundDecoration,
        child:
            currentIndex == 3
                ? pages[currentIndex] // sem refresh e sem padding
                : RefreshIndicator(
                  strokeWidth: 2.5,
                  displacement: 30,
                  color: const Color.fromARGB(255, 37, 43, 97),
                  backgroundColor: Colors.white,
                  onRefresh: _refreshAllProviders,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: pages[currentIndex],
                  ),
                ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}

Future<void> clearAllCache() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('contents_cache');
  await prefs.remove('cached_notes');
  await prefs.remove('history_cache');
  await prefs.remove('favorites_cache');
  print('Todos os caches foram limpos com sucesso!');
}
