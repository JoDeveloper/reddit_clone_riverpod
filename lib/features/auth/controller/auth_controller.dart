import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/core/utils.dart';
import 'package:reddit_clone_riverpod/features/auth/repository/auth_repository.dart';
import 'package:reddit_clone_riverpod/models/user_model.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    ref: ref,
    authRepository: ref.watch(authRepositoryProvider),
  );
});

final userProvider = StateProvider<UserModel?>((ref) {
  return null;
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authCont = ref.watch(authControllerProvider.notifier);
  return authCont.authStateChanges;
});

final getUserDataProvider = StreamProvider.autoDispose.family<UserModel?, String>((ref, uid) {
  final authCont = ref.watch(authControllerProvider.notifier);
  return authCont.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); // loading state

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  Stream<UserModel> getUserData(String uid) => _authRepository.getUserData(uid);

  void signInWithGoogle(BuildContext context) async {
    state = true; //start Loading
    final user = await _authRepository.signInWithGoogle();
    state = false; //stop Loading
    user.fold(
      (failer) => showSnackBar(context, failer.message),
      (user) => _ref.read(userProvider.notifier).update((state) => user),
    );
  }
}
