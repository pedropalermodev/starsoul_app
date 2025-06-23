import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double iconSize = 24.0;

    return Container(
      width: double.infinity,
      height: 135, 
      padding: const EdgeInsets.only(bottom: 8),
      color: const Color(0xFF1A2951),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 90,
              color: const Color(0xFF1A2951),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  navItem(
                    index: 0,
                    label: 'Favoritos',
                    iconPath: 'assets/navbar/favorite-unselect.png',
                    activeIconPath: 'assets/navbar/favorite-select.png',
                  ),
                  navItem(
                    index: 1,
                    label: 'Inicial',
                    iconPath: 'assets/navbar/home-unselect.png',
                    activeIconPath: 'assets/navbar/home-select.png',
                  ),
                  const SizedBox(width: 10), // Espaço para o botão central
                  navItem(
                    index: 3,
                    label: 'Notificações',
                    iconPath: 'assets/navbar/notify-unselect.png',
                    activeIconPath: 'assets/navbar/notify-select.png',
                  ),
                  navItem(
                    index: 4,
                    label: 'Config.',
                    iconPath: 'assets/navbar/config-unselect.png',
                    activeIconPath: 'assets/navbar/config-select.png',
                  ),
                ],
              ),
            ),
          ),

          // Botão central flutuante
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () => onTap(2), // Página Inicial
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF613EEA),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFA9C0FF),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/navbar/book.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget navItem({
    required int index,
    required String label,
    required String iconPath,
    required String activeIconPath,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            isSelected ? activeIconPath : iconPath,
            width: 24,
            height: 24,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF386BF6) : Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}