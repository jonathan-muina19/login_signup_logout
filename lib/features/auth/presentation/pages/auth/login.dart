import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_signup_app/core/configs/theme/app_color.dart';
import 'package:login_signup_app/core/configs/widget/button/my_button.dart';
import 'package:login_signup_app/core/configs/widget/textfield/my_textfield.dart';
import 'package:login_signup_app/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:login_signup_app/features/auth/presentation/pages/auth/signup.dart';
import 'package:login_signup_app/features/auth/presentation/pages/home/home_screen.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    // Verification du login
    void _login() {
      if (_formKey.currentState!.validate()) {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        context.read<AuthBloc>().add(SignInRequested(email, password));
      }
    }

    /// validator pour adresse email
    String? emailValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Veuillez entrer votre email';
      } else if (!value.contains('@')) {
        return 'Email invalide';
      }
    }

    /// Validator pour le mot de passe
    String? passwordValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Veuillez entrer votre mot de passe';
      } else if (value.length <= 8) {
        return 'Mot de passe trop faible';
      }
    }

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(
                content: SingleChildScrollView(
                  child: Container(
                    height: 70,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_rounded),
                        const SizedBox(width: 20),
                        Text(state.message, style: TextStyle(
                          fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                elevation: 20,
                backgroundColor: AppColors.background,
              ));
            } else if (state is AuthSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(
                content: Container(
                  height: 70,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 30),
                      const SizedBox(width: 20),
                      Text('Connexion reussie !', style: TextStyle(
                        fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                ),
                elevation: 20,
                backgroundColor: AppColors.background,
              ));
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
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Mot de passe',
                      controller: passwordController,
                      validator: passwordValidator,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    state is AuthLoading
                        ? const Center(child: CircularProgressIndicator())
                        : MyButton(onPressed: _login),

                    const SizedBox(height: 20),
                    _signupText(context),
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

Widget _loginTitle(BuildContext context) {
  return Text(
    'Connectez-vous',
    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  );
}

Widget _signupText(BuildContext context) {
  return RichText(
    text: TextSpan(
      children: [
        const TextSpan(text: 'Pas de compte?  '),
        TextSpan(
          text: 'Cree un compte',
          style: TextStyle(fontWeight: FontWeight.bold),
          recognizer:
              TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
        ),
      ],
    ),
  );
}
