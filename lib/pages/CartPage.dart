import 'package:appvet/styles/CartPageStyle.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userCart =
        await FirebaseFirestore.instance.collection('carts').doc(userId).get();

    if (userCart.exists) {
      List<dynamic> products = userCart['products'] ?? [];
      setState(() {
        cartItems =
            products.map((item) => item as Map<String, dynamic>).toList();
        _calculateTotal();
      });
    }
  }

  void _calculateTotal() {
    totalPrice = cartItems.fold(0.0, (sum, item) {
      double price = (item['price'] is String)
          ? double.tryParse(item['price']) ?? 0.0
          : item['price']?.toDouble() ??
              0.0; // Assurez-vous que c'est un double
      return sum + price;
    });
  }

  void _removeItem(String itemId) {
    setState(() {
      cartItems.removeWhere((item) => item['id'] == itemId);
      _calculateTotal();
    });
    _updateCartInFirestore();
  }

  Future<void> _updateCartInFirestore() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('carts').doc(userId).update({
      'products': cartItems,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CartPageStyles.appBarColor,
        title: const Text("Mon Panier"), // Titre de l'AppBar
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Votre panier est vide."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        child: ListTile(
                          leading: Image.memory(
                            base64Decode(item['image']),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item['titre']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Taille: ${item['taille']}"),
                              Text("Prix: ${item['price']} MAD"),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => _removeItem(item['id']),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Total: $totalPrice MAD",
                      style: CartPageStyles
                          .totalPriceStyle()), // Utiliser le style
                ),
              ],
            ),
    );
  }
}
