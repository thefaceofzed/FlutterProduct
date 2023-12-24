import 'package:cloud_firestore/cloud_firestore.dart';

class Produit {
  final String id;
  final String marque;
  final String categorie;
  final String designation;
  final String photo;
  final int prix;

  Produit({
    required this.id,
    required this.marque,
    required this.categorie,
    required this.designation,
    required this.photo,
    required this.prix,
  });

  factory Produit.fromFirestore(DocumentSnapshot document) {
    return Produit(
      id: document.id,
      marque: document['marque'] ?? '',
      categorie: document['categorie'] ?? '',
      designation: document['designation'] ?? '',
      photo: document['photo'] ?? '',
      prix: document['prix'] ?? 0,
    );
  }
}
