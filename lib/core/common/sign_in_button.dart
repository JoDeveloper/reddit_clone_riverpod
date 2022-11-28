import 'package:flutter/material.dart';
import 'package:reddit_clone_riverpod/core/constants/constants.dart';
import 'package:reddit_clone_riverpod/theme/pallete.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Image.asset(Constants.googlePath, width: 35),
        label: const Text('Continue With Google', style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
