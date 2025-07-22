import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_app/core/configs/theme/app_color.dart';
import 'package:login_signup_app/core/configs/widget/button/my_button.dart';
import 'package:login_signup_app/core/configs/widget/textfield/my_textfield.dart';
import 'package:login_signup_app/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:login_signup_app/features/auth/presentation/bloc/auth/auth_state.dart';
import 'package:login_signup_app/features/auth/presentation/pages/auth/signup.dart';
import 'package:login_signup_app/features/auth/presentation/pages/home/home_screen.dart';
import '../../../../../core/configs/widget/scaffoldMessenger/scaffold_messenger.dart';
import '../../bloc/auth/auth_bloc.dart';
import 'email_not_verified.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    void _login() {
      if (_formKey.currentState!.validate()) {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        context.read<AuthBloc>().add(SignInRequested(email, password));
      }
    }

    String? emailValidator(String? value) {
      if (value == null || value.isEmpty) return 'Veuillez entrer votre email';
      if (!value.contains('@')) return 'Email invalide';
      return null;
    }

    String? passwordValidator(String? value) {
      if (value == null || value.isEmpty)
        return 'Veuillez entrer votre mot de passe';
      if (value.length <= 8) return 'Mot de passe trop faible';
      return null;
    }

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              if (state.message == 'email-not-verified') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const EmailNotVerifiedPage(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:MyScaffoldMessenger(
                      title: 'Erreur',
                      message: state.message,
                      color: Colors.red,
                      icon: Icon(Icons.error),
                    ),
                    backgroundColor: AppColors.background,
                    elevation: 20,
                  ),
                );
              }
            } else if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:MyScaffoldMessenger(
                    title: 'Succes',
                    message: 'Connexion reussie',
                    color: Colors.green,
                    icon: Icon(Icons.check_circle),
                  ),
                  backgroundColor: AppColors.background,
                  elevation: 20,
                ),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connectez-vous',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyTextfield(
                      prefixIcon: const Icon(Icons.email),
                      hintText: 'Email',
                      controller: emailController,
                      validator: emailValidator,
                    ),
                    const SizedBox(height: 15),
                    MyTextfield(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Mot de passe',
                      controller: passwordController,
                      validator: passwordValidator,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    state is AuthLoading
                        ? const Center(child: CircularProgressIndicator())
                        : MyButton(onPressed: _login, text: 'Se connecter'),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(text: 'Pas de compte?  '),
                          TextSpan(
                            text: 'Cree un compte',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    context.read<AuthBloc>().add(
                                      ResetAuthEvent(),
                                    );
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => const SignupPage(),
                                      ),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
