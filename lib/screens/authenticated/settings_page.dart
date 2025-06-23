import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/screens/services/user_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Container(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await userProvider.logout();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/welcome', (route) => false);
            },
            child: const Text('Sair da Conta'),
          ),
        ],
      ),
    );
  }
}
