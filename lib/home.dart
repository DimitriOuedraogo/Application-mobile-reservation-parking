
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projetmobile/ReservationPage.dart';
import 'package:projetmobile/ReservationPrecedente.dart';


class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 late String userName = '';
  late String userEmail = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
  try {
    // Récupérer l'utilisateur actuellement connecté
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Récupérer les données de l'utilisateur à partir de Firestore
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userSnapshot.exists) {
        // Extraire le nom et l'email de l'utilisateur à partir des données récupérées
        setState(() {
          userName = userSnapshot.get('nom');
          userEmail = userSnapshot.get('email');
        });
      }
    }
  } catch (error) {
    print('Erreur lors de la récupération des données utilisateur: $error');
  }
}


  @override
  Widget build(BuildContext context) {
    // Extraire la première lettre du nom de l'utilisateur
    String firstLetter = userName.isNotEmpty ? userName[0] : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        
        automaticallyImplyLeading: false,
        // Afficher la première lettre du nom de l'utilisateur dans le coin supérieur droit
        actions: [
          GestureDetector(
            onTap: () {
              // Afficher le nom complet et l'adresse e-mail de l'utilisateur
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Profil utilisateur'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nom complet: $userName'),
                        SizedBox(height: 8),
                        Text('Adresse e-mail: $userEmail'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Fermer'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 16),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: Center(
                child: Text(
                  firstLetter,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center( // Centre les éléments horizontalement et verticalement
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centre les éléments verticalement
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
              onPressed: () {
                  // Naviguer vers la page de réservation lors de l'appui sur le bouton
                 Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationPage(userId: widget.userId),
      ),
    );
                },
                child: Text('Réserver une place'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {

            // Naviguer vers la page de réservation lors de l'appui sur le bouton
                 Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>ReservationPrecedente(userId: widget.userId),
      ),
    );
                },
                child: Text('Voir les réservations précédentes'),
              ),
              SizedBox(height: 16.0),
             
            ],
          ),
        ),
      ),
    );
  }
}
