import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projetmobile/RegScreen.dart';
import 'package:projetmobile/home.dart';

class loginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  loginScreen({Key? key});

  @override
  Widget build(BuildContext context) {
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

    Future<void> loginUser(
        BuildContext context, String email, String password) async {
      try {
        // Vérifiez les champs avant de continuer
        String? emailError = _validateEmail(emailController.text);
        String? passwordError = _validatePassword(passwordController.text);

        if (emailError != null || passwordError != null) {
          // Afficher un message d'erreur à l'utilisateur
          String? errorMessage =
              emailError ?? passwordError; // Utilisez l'erreur non nulle
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage!),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        // Utilisation de FirebaseAuth pour authentifier l'utilisateur avec l'e-mail et le mot de passe
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

 
   // Récupérer l'ID de l'utilisateur connecté
    String userId = FirebaseAuth.instance.currentUser!.uid;



        
         // Naviguer vers la page d'accueil après la connexion réussie
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userId: userId), // Passer l'id à la page d'accueil
          ),
        );


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connexion réussie!'),
            duration: Duration(seconds: 2),
          ),
        );
      } on FirebaseAuthException catch (e) {
        // Gérer les erreurs d'authentification
        if (e.code == 'user-not-found') {
          print('Aucun utilisateur trouvé pour cet e-mail.');
        } else if (e.code == 'wrong-password') {
          print('Mot de passe incorrect.');
        } else {
          print('Erreur lors de la connexion: $e');
        }

        // Afficher un message d'erreur à l'utilisateur en cas d'échec de l'authentification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la connexion: ${e.message}'),
            duration: Duration(seconds: 3),
          ),
        );
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
                'Connectez Vous !',
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
                    const SizedBox(height: 70),
                    Container(
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
                      child: GestureDetector(
                        onTap: () {
                          loginUser(context, emailController.text,
                              passwordController.text);
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
                              'CONNEXION',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 20), // Espace entre le bouton et le texte
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Pas de Compte? ",
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
                                builder: (context) => RegScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Inscrivez-vous !",
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
