import 'package:flutter/material.dart';

// Style pour le texte vide de la liste
const emptyListTextStyle = TextStyle(
  fontSize: 26, // Taille plus grande
  fontWeight: FontWeight.w700, // Plus gras
  color: Color.fromARGB(255, 27, 97, 187),
  fontStyle: FontStyle.italic, // Italique pour un effet élégant
);

// Style pour le nom de l'habit
const clothingNameStyle = TextStyle(
  fontSize: 22, // Taille de police plus grande
  fontWeight: FontWeight.bold,
  color: Colors.black87,
  shadows: [
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 5.0, // Ombre plus prononcée
      color: Colors.black26,
    ),
  ],
);

// Style pour le prix de l'habit
const clothingPriceStyle = TextStyle(
  fontSize: 20, // Taille plus grande
  color: Color.fromARGB(255, 16, 65, 54), // Une couleur plus vive
  fontWeight: FontWeight.w600, // Plus gras
  fontStyle: FontStyle.italic, // Italique pour un effet de charme
);

// Style pour la description de l'habit
const clothingDescriptionStyle = TextStyle(
  fontSize: 18, // Taille plus grande
  color: Colors.black54,
  fontStyle: FontStyle.italic, // Italique pour un effet doux
);
