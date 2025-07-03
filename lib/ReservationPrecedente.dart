import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReservationPrecedente extends StatefulWidget {
  final String userId;

  ReservationPrecedente({Key? key, required this.userId}) : super(key: key);

  @override
  _ReservationPrecedenteState createState() => _ReservationPrecedenteState();
}

class _ReservationPrecedenteState extends State<ReservationPrecedente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réservations précédentes'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('reservations')
            .where('userId', isEqualTo: widget.userId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Une erreur s\'est produite'));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucune réservation trouvée'));
          }

          // Afficher la liste des réservations précédentes
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var reservation = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(
                    'Durée de la réservation: ${reservation['duree_reservation']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.0),
                      Text(
                        'Date de réservation: ${reservation['date_reservation']}',
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Type de place: ${reservation['type_place']}',
                      ),
                    ],
                  ),
                  // Boutons de modification et de suppression
                  trailing: Wrap(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Naviguer vers la page de modification
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModifierReservationPage(
                                reservationId: reservation.id,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Action de suppression ici
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ModifierReservationPage extends StatelessWidget {
  final String reservationId;

  ModifierReservationPage({Key? key, required this.reservationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier la réservation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Action de modification du numéro de téléphone
              },
              child: Text('Modifier numéro de téléphone'),
            ),
            ElevatedButton(
              onPressed: () {
                // Action de modification du nom et prénom
              },
              child: Text('Modifier nom et prénom'),
            ),
            ElevatedButton(
              onPressed: () {
                // Action de modification du type de véhicule
              },
              child: Text('Modifier type de véhicule'),
            ),
            ElevatedButton(
              onPressed: () {
                // Action de modification de la plaque d'immatriculation
              },
              child: Text('Modifier plaque d\'immatriculation'),
            ),
          ],
        ),
      ),
    );
  }
}
