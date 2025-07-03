import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projetmobile/loginScreen.dart';

class RegScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  RegScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    String? _validateName(String? value) {
      if (value == null || value.isEmpty) {
        return 'Veuillez saisir votre nom d\'Utilisateur';
      }
      return null;
    }

    String? _validateEmail(String? value) {
      if (value == null || value.isEmpty) {
        return 'Veuillez saisir votre adresse e-mail.';
      }
      if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
          .hasMatch(value)) {
        return 'Veuillez saisir une adresse e-mail valide.';
      }
      return null;
    }

    String? _validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Veuillez saisir votre mot de passe.';
      }
      if (value.length < 6) {
        return 'Le mot de passe doit comporter au moins 6 caractères.';
      }
      return null;
    }

    void registerUser(BuildContext context) async {
      // Vérifiez les champs avant de continuer
      String? emailError = _validateEmail(emailController.text);
      String? passwordError = _validatePassword(passwordController.text);
      String? nameError = _validateName(nameController.text);

      // Vérifiez si les mots de passe saisis correspondent
  if (passwordController.text != confirmPasswordController.text) {
    // Affichez un message d'erreur à l'utilisateur
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Les mots de passe ne correspondent pas.'),
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

      if (emailError != null || passwordError != null || nameError != null) {
        // Afficher un message d'erreur à l'utilisateur
        String? errorMessage = emailError ??
            passwordError ??
            nameError; // Utilisez l'erreur non nulle
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage!),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Récupérez l'ID utilisateur créé
        String userId = userCredential.user!.uid;

        // Enregistrez les données de l'utilisateur dans Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set({'email': emailController.text, 'nom': nameController.text});

        // Navigation vers une autre page après l'inscription réussie
        // Par exemple, la page de connexion
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => loginScreen(),
          ),
        );
      } catch (error) {
        // Gérez les erreurs d'inscription ici
        print("Erreur lors de l'inscription: $error");
        // Affichez un message d'erreur à l'utilisateur si nécessaire
        // Par exemple, ScaffoldMessenger.of(context).showSnackBar(...)
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffB81736),
                  Color(0xff281537),
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Inscrivez-Vous !',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.check,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Nom',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        ),
                      ),
                    ),

                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.check,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Mot de Passe',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                      suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Confirmer Mot de Passe',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    GestureDetector(
                      onTap: () {
                        registerUser(context);
                      },
                      child: Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xffB81736),
                              Color(0xff281537),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'INSCRIPTION',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Avez-vous déjà un compte? ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => loginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Connectez-vous !",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
