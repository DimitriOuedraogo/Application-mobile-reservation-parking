import 'package:flutter/material.dart';

class ModifierReservationPage extends StatefulWidget {
  final String reservationId;

  ModifierReservationPage({Key? key, required this.reservationId})
      : super(key: key);

  @override
  _ModifierReservationPageState createState() =>
      _ModifierReservationPageState();
}

class _ModifierReservationPageState extends State<ModifierReservationPage> {
  TextEditingController nomController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController typeVehiculeController = TextEditingController();
  TextEditingController plaqueImmatriculationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier la réservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nomController,
              decoration: InputDecoration(labelText: 'Nom et prénom'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: numeroController,
              decoration: InputDecoration(labelText: 'Numéro de téléphone'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: typeVehiculeController,
              decoration: InputDecoration(labelText: 'Type de véhicule'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: plaqueImmatriculationController,
              decoration:
                  InputDecoration(labelText: 'Plaque d\'immatriculation'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Action de modification ici
                String nom = nomController.text;
                String numero = numeroController.text;
                String typeVehicule = typeVehiculeController.text;
                String plaqueImmatriculation =
                    plaqueImmatriculationController.text;
                // Enregistrer les modifications dans Firestore ou tout autre système de gestion de données
                // ...
              },
              child: Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }
  
}
