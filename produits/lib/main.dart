import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './Model/list_products.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisez Firebase en premier
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: '1:649003480596:android:bfb5d47bbbad074d651901',
      apiKey: 'AIzaSyA8m1OaHGDFaahiJNkWWBeX6TpqhqoiPn4',
      projectId: 'atelier4-i-elfarouki-iir5g2',
      messagingSenderId: 'atelier4-i-elfarouki-iir5g2.appspot.com',
    ),
  );


  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'ismailfarouki120@gmail.com',
      password: '1234zed',
    );

    runApp(const MyApp());
  } catch (e) {
    // Gérez les erreurs d'authentification ici
    print('Erreur d\'authentification : $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ListeProduits(),
    );
  }
}
