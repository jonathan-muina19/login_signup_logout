import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_app/core/configs/widget/button/my_button.dart';
import 'package:login_signup_app/features/auth/presentation/pages/auth/signup.dart';

import '../../../../../core/configs/theme/app_color.dart';
import '../../../../../core/configs/widget/scaffoldMessenger/scaffold_messenger.dart';
import 'login.dart';

class EmailNotVerifiedPage extends StatelessWidget {
  const EmailNotVerifiedPage({super.key});

  // Fonction pour renvoyer le lien de confirmation
  Future<void> _sendVerificationEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: MyScaffoldMessenger(
              title: 'Confirmation',
              message: 'Un nouveau lien envoyer.\nVerifier vos mails',
              color: Colors.blue,
              icon: Icon(Icons.link),
            ),
            backgroundColor: AppColors.background,
            elevation: 20,
          ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi du mail : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email_outlined, size: 80, color: Colors.orange),
              SizedBox(height: 20),
              Text(
                'Votre adresse e-mail n\'est pas encore vérifiée.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Veuillez consulter votre boîte mail (y compris le dossier spam).',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: 200, // Ajuste cette largeur selon ce que tu veux
                child: ElevatedButton(
                  onPressed: () => _sendVerificationEmail(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    backgroundColor: Colors.green, // ta couleur si besoin
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // optionnel pour arrondir
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.link, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Renvoyer le lien',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15, // Réduit aussi la taille du texte
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: 200, // Ajuste cette largeur selon ce que tu veux
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    backgroundColor: Colors.blue, // ta couleur si besoin
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // optionnel pour arrondir
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Icon(Icons.keyboard_backspace, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Connexion',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15, // Réduit aussi la taille du texte
                        ),
                      ),
                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
