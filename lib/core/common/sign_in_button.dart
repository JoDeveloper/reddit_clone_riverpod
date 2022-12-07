import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/core/constants/constants.dart';
import 'package:reddit_clone_riverpod/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_riverpod/theme/pallete.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({Key? key}) : super(key: key);

  void signInWithgoogle(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(ref.context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithgoogle(ref),
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
