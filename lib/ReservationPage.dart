import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projetmobile/PayementReservation.dart';

class ReservationPage extends StatelessWidget {
  final List<String> _placeTypes = ['Employé', 'Directeur', 'DG'];
  final List<String> _duree = ['1jour','3jours','1semaine', '3 semaines','1 mois','3 mois','6 mois', '1 annee'];
  String? _selectedPlaceType;
  String? _selectedDurer;
   final String userId;

    // Déclarez reservationRef en dehors de la fonction submitReservation
  late DocumentReference reservationRef;

  // Définissez les contrôleurs pour récupérer les valeurs des champs de formulaire
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController parkingTypeController = TextEditingController();

       ReservationPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {


    void submitReservation(TextEditingController nameController, TextEditingController phoneNumberController, TextEditingController dateController, TextEditingController timeController, TextEditingController durationController, TextEditingController vehicleTypeController, TextEditingController licensePlateController, TextEditingController parkingTypeController) {
  // Récupérer les valeurs à partir des contrôleurs

  // Obtenir la date et l'heure actuelles
  DateTime now = DateTime.now();

  // Formater la date et l'heure selon vos besoins
  String dateReservation = '${now.day}/${now.month}/${now.year}';
  String heureReservation = '${now.hour}:${now.minute}';

  String nomPrenom = nameController.text;
  String numeroTelephone = phoneNumberController.text;
  String? dureeReservation = _selectedDurer;
  String? typePlace = _selectedPlaceType;
  String typeVehicule = vehicleTypeController.text;
  String plaqueImmatriculation = licensePlateController.text;

  // Créer une référence à la collection "reservations" dans Firestore
  CollectionReference reservations = FirebaseFirestore.instance.collection('reservations');

  // Ajouter un document avec les données de réservation
reservations.add({
  'userId': userId, // Ajoutez l'ID de l'utilisateur à la réservation
  'nom': nomPrenom,
  'numero': numeroTelephone,
  'date_reservation': dateReservation,
  'heure_reservation': heureReservation,
  'duree_reservation': dureeReservation,
  'type_vehicule': typeVehicule,
  'plaque_immatriculation': plaqueImmatriculation,
  'type_place': typePlace,
})

  
  .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Reservation Reussie !"),
              duration: Duration(seconds: 2),
            ),
          );
         // Récupérer la référence du document ajouté
   reservationRef = value;
        // Récupérer l'ID du document ajouté
   String reservationId = reservationRef.id;

    // Réinitialiser les champs de texte après la soumission du formulaire
    nameController.clear();
    phoneNumberController.clear();
    dateController.clear();
    timeController.clear();
    durationController.clear();
    vehicleTypeController.clear();
    licensePlateController.clear();
    parkingTypeController.clear();
   
    // Naviguer vers la page suivante en transmettant l'ID de la réservation
   print(reservationId);
   Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PayementReservation(reservationId: reservationId)),
  );
  })
  .catchError((error) {
    print("Erreur lors de l'ajout de la réservation: $error");
  });
}
   
    return Scaffold(
      appBar: AppBar(
        title: Text('Réserver une place'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Remplissez le formulaire pour réserver une place de parking :',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nom et prénom',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
                controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Numéro de téléphone',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
         
          
            SizedBox(height: 10.0),
    
      DropdownButtonFormField<String>(     
              decoration: InputDecoration(
                labelText: 'Durée de la Reservation',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              value: _selectedDurer,
              items: _duree.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Mettre à jour la valeur sélectionnée lorsque l'utilisateur choisit un élément dans le menu déroulant
                _selectedDurer = newValue;
              },
            ),

            SizedBox(height: 10.0),
            TextFormField(
              controller:vehicleTypeController ,
              decoration: InputDecoration(
                labelText: 'Type de véhicule',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller:licensePlateController ,
              decoration: InputDecoration(
                labelText: 'Plaque d\'immatriculation',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Type de place',
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              value: _selectedPlaceType,
              items: _placeTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Mettre à jour la valeur sélectionnée lorsque l'utilisateur choisit un élément dans le menu déroulant
                _selectedPlaceType = newValue;
              },
            ),
          
            SizedBox(height: 20.0),
         ElevatedButton(
  onPressed: () {
    submitReservation(nameController, phoneNumberController, dateController, timeController, durationController, vehicleTypeController, licensePlateController, parkingTypeController);
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xffB81736), // Couleur de fond du bouton
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: Center(
      child: Text(
        'Réserver',
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
      ),
    );
  }
}
