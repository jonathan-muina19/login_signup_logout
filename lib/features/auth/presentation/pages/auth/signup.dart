import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_app/core/configs/widget/scaffoldMessenger/scaffold_messenger.dart';
import 'package:login_signup_app/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:login_signup_app/features/auth/presentation/bloc/auth/auth_state.dart';
import 'package:login_signup_app/features/auth/presentation/pages/auth/login.dart';

import '../../../../../core/configs/theme/app_color.dart';
import '../../../../../core/configs/widget/button/my_button.dart';
import '../../../../../core/configs/widget/textfield/my_textfield.dart';
import '../../bloc/auth/auth_bloc.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController againPasswordController =
        TextEditingController();
    final _formKey = GlobalKey<FormState>();

    /// validator pour le nom du user
    String? nameValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Veuillez entrer votre nom';
      }
      return null;
    }

    /// validator pour le prenom du user
    String? lastValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Veuillez entrer votre prenom';
      }
      return null;
    }

    /// validator pour adresse email
    String? emailValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Veuillez entrer votre email';
      } else if (!value.contains('@')) {
        return 'Email invalide';
      }
      return null;
    }

    /// validator pour le mot de passe
    String? passwordValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Veuillez entrer votre mot de passe';
      } else if (value.length <= 8) {
        return 'Mot de passe trop faible';
      }
      return null;
    }

    /// validator pour confirmer le mot de passe
    String? confirmPassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Veuillez confirmer votre mot de passe';
      } else if (value.length <= 8) {
        return 'Mot de passe trop faible';
      } else if (value.trim() != passwordController.text.trim()) {
        return 'Les mots de passe ne correspondent pas';
      }
      return null;
    }

    void _signUp() {
      if (_formKey.currentState!.validate()) {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        context.read<AuthBloc>().add(SignUpRequested(email, password));
      }
    }

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is EmailVerificationSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: MyScaffoldMessenger(
                  title: 'Confirmation',
                  message: 'Email de confirmation envoyer\nVerifier vos mails',
                  color: Colors.blueAccent,
                  icon: Icon(Icons.info_rounded)
              ),
              elevation: 20,
              backgroundColor: AppColors.background,
            ),
          );
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: SingleChildScrollView(
                child: Container(
                  height: 70,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error),
                      const SizedBox(width: 20),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Erreur!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              state.message,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              elevation: 20,
              backgroundColor: AppColors.background,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 60,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _loginTitle(context),
                      const SizedBox(height: 20),
                      MyTextfield(
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Email',
                        controller: emailController,
                        validator: emailValidator,
                      ),
                      const SizedBox(height: 15),
                      MyTextfield(
                        obscureText: true,
                        prefixIcon: Icon(Icons.lock),
                        hintText: 'Mot de passe',
                        controller: passwordController,
                        validator: passwordValidator,
                      ),
                      const SizedBox(height: 15),
                      MyTextfield(
                        obscureText: true,
                        prefixIcon: Icon(Icons.lock),
                        hintText: 'Confirmer le mot de passe',
                        controller: againPasswordController,
                        validator: confirmPassword,
                      ),
                      const SizedBox(height: 20),
                      state is AuthLoading
                          ? const Center(child: CircularProgressIndicator())
                          : MyButton(
                            onPressed: () {
                              _signUp();
                            },
                            text: 'Continuer',
                          ),
                      const SizedBox(height: 20),
                      _signupText(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _loginTitle(BuildContext context) {
  return Text(
    'Creer un compte',
    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  );
}

Widget _signupText(BuildContext context) {
  return RichText(
    text: TextSpan(
      children: [
        const TextSpan(text: 'Vous-avez un compte ?  '),
        TextSpan(
          text: 'Connectez-vous',
          style: TextStyle(fontWeight: FontWeight.bold),
          recognizer:
              TapGestureRecognizer()
                ..onTap = () {
                  context.read<AuthBloc>().add(ResetAuthEvent());
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
        ),
      ],
    ),
  );
}
