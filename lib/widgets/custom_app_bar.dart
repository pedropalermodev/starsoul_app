import 'package:flutter/material.dart';
import 'package:starsoul_app/main_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final double height;
  final bool showLogo;
  final int? currentIndex;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.height = 80,
    this.showLogo = false,
    this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {

    final Color backgroundColor =
        currentIndex == 3 ? const Color(0xFF233A66) : const Color(0xFF3C5DB7);

    return AppBar(
      backgroundColor: backgroundColor,
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
                    style: TextStyle(
                        color: currentIndex == 3 ? Colors.black : Colors.white,
                        fontSize: 18),
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
