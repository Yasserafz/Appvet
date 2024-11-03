import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Ajoutez cette ligne
import 'package:appvet/styles/ClothingDetailPageStyle.dart';

class ClothingDetailPage extends StatelessWidget {
  final String clothingId;

  const ClothingDetailPage({Key? key, required this.clothingId})
      : super(key: key);

  Future<void> _addToCart(
      BuildContext context, Map<String, dynamic> data) async {
    // Remplacez par l'ID de l'utilisateur connecté
    String userId = FirebaseAuth
        .instance.currentUser!.uid; // Récupérez l'ID de l'utilisateur connecté

    try {
      await FirebaseFirestore.instance.collection('carts').doc(userId).set(
        {
          'products': FieldValue.arrayUnion([
            {
              'id': clothingId,
              'titre': data['titre'],
              'price': data['price'],
              'image': data['image'],
              'taille': data['taille'],
            }
          ])
        },
        SetOptions(
            merge:
                true), // Utilisez merge pour ne pas écraser les données existantes
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit ajouté au panier!')),
      );
    } catch (e) {
      print("Erreur lors de l'ajout au panier : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'ajout au panier')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails du Vêtement"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("clothing")
            .doc(clothingId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Vêtement non trouvé"));
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          String titre = data["titre"] ?? "Titre non disponible";
          String price = data["price"]?.toString() ?? "Prix non disponible";
          String taille = data["taille"] ?? "Taille non disponible";
          String marque = data["marque"] ?? "Marque non disponible";
          String categorie = data["categorie"] ?? "Catégorie non disponible";
          String base64Image = data["image"] ?? "";

          Uint8List imageBytes;
          try {
            imageBytes = base64Decode(base64Image);
          } catch (e) {
            print("Erreur lors du décodage de l'image : $e");
            imageBytes = Uint8List(0); // Image vide en cas d'erreur
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.memory(
                      imageBytes,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(titre, style: clothingTitleStyle),
                  Text("Catégorie: $categorie", style: clothingCategoryStyle),
                  Text("Marque: $marque", style: clothingDetailStyle),
                  Text("Taille: $taille", style: clothingDetailStyle),
                  Text("Prix: $price MAD", style: clothingDetailStyle),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _addToCart(context, data); // Ajoute au panier
                    },
                    child: const Text("Ajouter au Panier"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Retourne à la liste
                    },
                    child: const Text("Retour"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
