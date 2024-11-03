import 'dart:convert'; // Pour le décodage base64
import 'dart:typed_data'; // Pour Uint8List
import 'package:appvet/styles/HomePageStyle.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appvet/styles/ClothingListStyle.dart';
import 'package:appvet/pages/ClothingDetailPage.dart'; // Importez votre page de détails ici

class ClothingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Liste des Vêtements"), // Titre de l'AppBar
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("clothing").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child:
                  Text("Aucun vêtement disponible", style: emptyListTextStyle),
            );
          }

          return ListView(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0), // Padding vertical
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

              if (data == null) {
                return const Text("Document incomplet",
                    style: emptyListTextStyle);
              }

              // Récupérer les données
              String id = doc.id; // ID du document pour la navigation
              String titre =
                  data["titre"]?.toString() ?? "Titre non disponible";
              String price = data["price"]?.toString() ?? "Prix non disponible";
              String taille = data["taille"] ?? "Taille non disponible";
              String base64Image = data["image"] ?? "";

              Uint8List imageBytes;
              try {
                imageBytes = base64Decode(base64Image);
              } catch (e) {
                print("Erreur lors du décodage de l'image : $e");
                imageBytes = Uint8List(0); // Image vide en cas d'erreur
              }

              return Card(
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0), // Espacement des cartes
                elevation: 6, // Élément d'élévation pour l'effet d'ombre
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Coins arrondis
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10.0), // Padding interne
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10.0), // Coins arrondis pour l'image
                    child: Image.memory(
                      imageBytes,
                      width: 80, // Largeur de l'image
                      height: 80, // Hauteur de l'image
                      fit: BoxFit.cover, // Remplir le conteneur
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.error), // Gestion d'erreur pour l'image
                    ),
                  ),
                  title: Text(titre, style: clothingNameStyle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Prix : $price MAD", style: clothingPriceStyle),
                      const SizedBox(
                          height:
                              4), // Espacement entre le prix et la description
                      Text(taille, style: clothingDescriptionStyle),
                    ],
                  ),
                  onTap: () {
                    // Naviguer vers la page de détails en passant l'ID du vêtement
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClothingDetailPage(clothingId: id),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
