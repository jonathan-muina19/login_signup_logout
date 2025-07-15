import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:login_signup_app/core/configs/widget/button/my_button.dart';
import 'package:login_signup_app/features/auth/presentation/bloc/auth/auth_state.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../auth/login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Firebase Authentification
    final user = FirebaseAuth.instance.currentUser;
    /// Email de l'utilisateur
    final email = user?.email ?? 'Compte ou Email non disponible';

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state){
        if(state is AuthFailure  || state is AuthInitial){
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const LoginScreen()
            ),
              (route) => false
          );
        }
      },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Déconnexion en cours...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 60),
                  child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/vectors/email_sending.svg'),
                      const SizedBox(height: 20),
                      Text('Connecté en tant que ', style: TextStyle(
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
                        icon: Icon(Icons.logout_outlined),
                        onPressed: () {
                          context.read<AuthBloc>().add(SignOutRequested());
                        },
                        text: 'Se deconnecter',
                      )
                    ],
                  )
                  ),
                ),
              )
          );
        }
    );
  }
}
