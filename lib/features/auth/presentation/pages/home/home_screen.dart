import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_app/core/configs/widget/button/my_button.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Firebase Authentification
    final user = FirebaseAuth.instance.currentUser;
    /// Email de l'utilisateur
    final email = user?.email ?? 'Compte ou Email non disponible';

    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
            child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Connecté en tant que', style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                    ),
                  ),
                Text('$email', style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal
                ),
                ),
                const SizedBox(height: 20),
                MyButton(
                  onPressed: (){
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                  text: 'Deconnexion',

                )
              ],
            )
            ),
          ),
        )
    );
  }
}
