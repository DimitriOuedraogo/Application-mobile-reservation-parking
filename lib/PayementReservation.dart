import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projetmobile/QrPage.dart';

class PayementReservation extends StatefulWidget {
  final String reservationId;
  // Déclarez un TextEditingController pour gérer le champ de texte de l'OTP
  final TextEditingController otpController = TextEditingController();

  PayementReservation({Key? key, required this.reservationId})
      : super(key: key);

  @override
  _PaymentReservationState createState() => _PaymentReservationState();
}

class _PaymentReservationState extends State<PayementReservation> {
  TextEditingController otpController = TextEditingController();
  int totalPrice = 0; // Prix total initialisé à 0

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facture de réservation'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('reservations')
            .doc(widget.reservationId)
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

          // Calculer le prix total en fonction de la durée de réservation
          int totalPrice =
              calculateTotalPrice(reservationData['duree_reservation']);

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête de la facture avec le nom de l'application
                Text(
                  'FasoParking',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // Informations de la réservation
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informations de réservation',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildInfoRow(
                        'Nom et prénom', reservationData['nom'] ?? 'N/A'),
                    _buildInfoRow('Numéro de téléphone',
                        reservationData['numero'] ?? 'N/A'),
                    _buildInfoRow('Date de réservation',
                        reservationData['date_reservation'] ?? 'N/A'),
                    _buildInfoRow('Heure de réservation',
                        reservationData['heure_reservation'] ?? 'N/A'),
                    _buildInfoRow('Durée de réservation',
                        reservationData['duree_reservation'] ?? 'N/A'),
                    _buildInfoRow('Type de véhicule',
                        reservationData['type_vehicule'] ?? 'N/A'),
                    _buildInfoRow('Plaque d\'immatriculation',
                        reservationData['plaque_immatriculation'] ?? 'N/A'),
                    _buildInfoRow('Type de place',
                        reservationData['type_place'] ?? 'N/A'),
                  ],
                ),
                // Champ OTP
                SizedBox(height: 20),
                // Utilisez ce TextEditingController dans votre champ de texte
                TextField(
                  controller: otpController,
                  decoration: InputDecoration(
                    labelText: 'Code OTP',
                    border: OutlineInputBorder(),
                    errorText: otpController.text.isNotEmpty &&
                            otpController.text.length < 8
                        ? 'Le code doit contenir au moins 8 chiffres'
                        : null,
                  ),
                  keyboardType: TextInputType
                      .number, // Définissez le type de clavier pour ne permettre que les chiffres
                  maxLength:
                      8, // Définissez la longueur maximale du texte à 8 chiffres
                ),
                // Prix total
                SizedBox(height: 20),
                Text(
                  'Montant total à payer: $totalPrice FCFA',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Bouton "Terminer Le Payment"
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QrPage(
                          reservationId: widget.reservationId,
                        ),
                      ),
                   );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xffB81736), // Couleur de fond du bouton
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Text(
                        'Payer',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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

  // Fonction pour calculer le prix total en fonction de la durée de réservation
  int calculateTotalPrice(String? dureeReservation) {
    switch (dureeReservation) {
      case '1jour':
        return 500;
      case '3jours':
        return 500 * 3;
      case '1semaine':
        return 500 * 7;
      case '3 semaines':
        return 500 * 21;
      case '1 mois':
        return 500 * 30;
      case '3 mois':
        return 500 * 90;
      case '6 mois':
        return 500 * 180;
      case '1 annee':
        return 500 * 365;
      default:
        return 0; // Prix total par défaut si aucune durée n'est sélectionnée
    }
  }
}
