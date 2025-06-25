import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final double height;
  final bool showLogo;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.height = 80,
    this.showLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF3C5DB7),
      elevation: 0,
      centerTitle: showLogo,
      title:
          showLogo
              ? Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Image.asset(
                  'assets/mark/combinationmark-white.png',
                  height: 20,
                ),
              )
              : title != null && title!.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.only(top: 25, left: 5),
                child: Text(
                  title!,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
              : null,
      actions:
          actions
              ?.map(
                (widget) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: widget,
                ),
              )
              .toList(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
