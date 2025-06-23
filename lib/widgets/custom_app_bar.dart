import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const CustomAppBar({super.key, this.height = 80});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF3C5DB7),
      elevation: 0,
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Image.asset('assets/mark/combinationmark-white.png', height: 20),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
