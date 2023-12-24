import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product.dart';

class ListeProduits extends StatefulWidget {
  const ListeProduits({Key? key}) : super(key: key);

  @override
  _ListeProduitsState createState() => _ListeProduitsState();
}

class _ListeProduitsState extends State<ListeProduits> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Produits'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('produits').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Une erreur est survenue : ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<Produit> produits = snapshot.data!.docs.map((doc) {
            return Produit.fromFirestore(doc);
          }).toList();

          return DataTable(
            columns: [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Marque')),
              DataColumn(label: Text('Catégorie')),
              DataColumn(label: Text('Désignation')),
              DataColumn(label: Text('Photo')),
              DataColumn(label: Text('Prix')),
              DataColumn(label: Text('Actions')),
            ],
            rows: produits.map((produit) {
              return DataRow(
                cells: [
                  DataCell(Text(produit.id)),
                  DataCell(Text(produit.marque)),
                  DataCell(Text(produit.categorie)),
                  DataCell(Text(produit.designation)),
                  DataCell(Text(produit.photo)),
                  DataCell(Text('${produit.prix} €')),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteProduit(produit),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterProduit,
        tooltip: 'Ajouter un produit',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _ajouterProduit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String marque = '';
        String categorie = '';
        String designation = '';
        String photo = '';
        int prix = 0;

        return AlertDialog(
          title: const Text('Ajouter un produit'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) => marque = value,
                decoration: const InputDecoration(labelText: 'Marque'),
              ),
              TextField(
                onChanged: (value) => categorie = value,
                decoration: const InputDecoration(labelText: 'Catégorie'),
              ),
              TextField(
                onChanged: (value) => designation = value,
                decoration: const InputDecoration(labelText: 'Désignation'),
              ),
              TextField(
                onChanged: (value) => photo = value,
                decoration: const InputDecoration(labelText: 'URL de la photo'),
              ),
              TextField(
                onChanged: (value) => prix = int.tryParse(value) ?? 0,
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await db.collection('produits').add({
                    'marque': marque,
                    'categorie': categorie,
                    'designation': designation,
                    'photo': photo,
                    'prix': prix,
                  });

                  Navigator.pop(context);
                  setState(() {});
                } catch (e) {
                  print('Erreur lors de l\'ajout du produit : $e');
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduit(Produit produit) async {
    try {
      await db.collection('produits').doc(produit.id).delete();
      setState(() {});
    } catch (e) {
      print('Erreur lors de la suppression du produit : $e');
    }
  }
}

class ProduitItem extends StatelessWidget {
  final Produit produit;
  final VoidCallback onDelete;

  const ProduitItem({
    Key? key,
    required this.produit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(produit.designation),
      subtitle: Text('Prix : ${produit.prix} €'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
