import 'package:flutter/material.dart';
import 'package:appvet/components/ClothingList.dart';
import 'package:appvet/components/BottomNavBar.dart';
import 'package:appvet/pages/CartPage.dart';
import 'package:appvet/pages/ProfilePage.dart'; // Importez votre page de profil ici

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(
      //  automaticallyImplyLeading: false,
      //title: const Text("STORE CLOTHES"),
      //backgroundColor: appBarColor,
      //actions: [
      // Supprimer l'icône de déconnexion
      //],
      //),
      body: Center(
        child: _selectedIndex == 0
            ? ClothingList() // Page des vêtements
            : _selectedIndex == 1
                ? CartPage() // Page du panier
                : ProfilePage(), // Affiche la page de profil lorsque l'index est 2
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
