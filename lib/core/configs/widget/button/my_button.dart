import 'package:flutter/material.dart';
import 'package:login_signup_app/core/configs/theme/app_color.dart';

class MyButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const MyButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.text = 'Se connecter',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.all(18),
        //margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child:
            isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
                : Center(
                  child: Text(
                    text,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
      ),
    );
  }
}
