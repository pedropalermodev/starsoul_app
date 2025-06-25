import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/services/user_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final desiredWidth = screenWidth * 0.85;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Container(
      child: Column(
        children: [
          Column(
            children: [
              Image.asset('assets/elements/profilePicture.png'),
              SizedBox(height: 18),
              Text(
                '${userProvider.userName ?? 'Error'}',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(
                '${userProvider.userEmail ?? 'Error'}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 30),
              Container(height: 1, width: desiredWidth, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
