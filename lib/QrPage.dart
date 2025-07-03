import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QrPage extends StatelessWidget {
  final String reservationId;

  const QrPage({Key? key, required this.reservationId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code de réservation'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('reservations')
            .doc(reservationId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Une erreur s\'est produite'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Aucune réservation trouvée'));
          }

          // Récupérer les données de la réservation
          Map<String, dynamic> reservationData =
              snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Afficher les autres informations de la réservation
                Text(
                  'Informations de réservation :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildReservationInfo('Nom et prénom', reservationData['nom'] ?? ''),
                _buildReservationInfo('Numéro de téléphone', reservationData['numero'] ?? ''),
                _buildReservationInfo('Date de réservation', reservationData['date_reservation'] ?? ''),
                _buildReservationInfo('Heure de réservation', reservationData['heure_reservation'] ?? ''),
                _buildReservationInfo('Durée de réservation', reservationData['duree_reservation'] ?? ''),
                _buildReservationInfo('Type de véhicule', reservationData['type_vehicule'] ?? ''),
                _buildReservationInfo('Plaque d\'immatriculation', reservationData['plaque_immatriculation'] ?? ''),
                _buildReservationInfo('Type de place', reservationData['type_place'] ?? ''),
                SizedBox(height: 20),
               
                Image.asset(
                  'assets/Qr_code.jpg',
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReservationInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
