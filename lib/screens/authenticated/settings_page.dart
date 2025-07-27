import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starsoul_app/screens/authenticated/history_page.dart';
import 'package:starsoul_app/screens/authenticated/personalInfo_page.dart';
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
              SizedBox(height: 15),

              // SizedBox(
              //   width: double.infinity,
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       'Configurações',
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),

              // SizedBox(height: 15),

              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => PersonalInfoPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },

                child: Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0 , bottom: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.manage_accounts,
                        color: Colors.white,
                        size: 24.0,
                      ),

                      SizedBox(width: 10),

                      Text(
                        'Informações pessoais',
                        style: TextStyle(color: Colors.white),
                      ),

                      Spacer(),

                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,

                        size: 14.0,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 5),

              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => HistoryPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0 , bottom: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.history, color: Colors.white, size: 24.0),

                      SizedBox(width: 10),

                      Text(
                        'Veja seu histórico',
                        style: TextStyle(color: Colors.white),
                      ),

                      Spacer(),

                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 14.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
