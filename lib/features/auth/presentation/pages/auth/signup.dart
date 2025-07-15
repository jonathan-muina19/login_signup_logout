import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_app/features/auth/presentation/pages/auth/login.dart';

import '../../../../../core/configs/widget/button/my_button.dart';
import '../../../../../core/configs/widget/textfield/my_textfield.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController againPasswordController =
        TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _loginTitle(context),
                const SizedBox(height: 20),
                MyTextfield(hintText: 'Email', controller: emailController),
                const SizedBox(height: 15),
                MyTextfield(
                  hintText: 'Mot de passe',
                  controller: passwordController,
                ),
                const SizedBox(height: 15),
                MyTextfield(
                  hintText: 'Confirmer le mot de passe',
                  controller: againPasswordController,
                ),
                const SizedBox(height: 20),
                MyButton(onPressed: () {}, text: 'Continuer'),
                const SizedBox(height: 20),
                _signupText(context),
              ],
            ),
          ),
        ),
      ),
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
        ),
      ],
    ),
  );
}
