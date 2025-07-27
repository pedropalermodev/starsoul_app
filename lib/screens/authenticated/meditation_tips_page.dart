import 'package:flutter/material.dart';

class MeditationTipsPage extends StatefulWidget {
  const MeditationTipsPage({super.key});

  @override
  State<MeditationTipsPage> createState() => _MeditationTipsPageState();
}

class _MeditationTipsPageState extends State<MeditationTipsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('Página de dicas de meditação')])
      );
  }
}
