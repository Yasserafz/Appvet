import 'package:flutter/material.dart';
import 'package:appvet/styles/BottomNavBarStyle.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Acheter',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Panier',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor:
          selectedItemColor, // Vérifiez que cela est défini dans BottomNavBarStyle.dart
      unselectedItemColor:
          unselectedItemColor, // Vérifiez que cela est défini dans BottomNavBarStyle.dart
      type: BottomNavigationBarType.fixed, // Ajouté pour la navigation fixe
      onTap: onTap,
    );
  }
}
