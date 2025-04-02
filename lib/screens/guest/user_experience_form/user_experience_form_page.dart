import 'package:flutter/material.dart';

class UserExperienceFormPage extends StatefulWidget {
  const UserExperienceFormPage({super.key});

  @override
  State<UserExperienceFormPage> createState() => _UserExperienceFormPageState();
}

class _UserExperienceFormPageState extends State<UserExperienceFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Text('Pagina de Experinecia de Usuario'
        ),
      ),
    );
  }
}