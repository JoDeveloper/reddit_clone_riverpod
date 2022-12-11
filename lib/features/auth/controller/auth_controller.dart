import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/core/utils.dart';
import 'package:reddit_clone_riverpod/features/auth/repository/auth_repository.dart';
import 'package:reddit_clone_riverpod/models/user_model.dart';

/// Creating a provider that returns an instance of AuthController.
final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    ref: ref,
    authRepository: ref.watch(authRepositoryProvider),
  );
});

/// A provider that returns a null value.
final userProvider = StateProvider<UserModel?>((ref) {
  return null;
});

/// A provider that returns a stream of User?.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authCont = ref.watch(authControllerProvider.notifier);
  return authCont.authStateChanges;
});

/// A provider that returns a stream of UserModel?.
final getUserDataProvider = StreamProvider.autoDispose.family<UserModel?, String>((ref, uid) {
  final authCont = ref.watch(authControllerProvider.notifier);
  return authCont.getUserData(uid);
});

/// > This class is a state notifier that holds a boolean value
class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); // loading state

  /// A getter that returns a stream of User?.
  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  /// It returns a stream of UserModel.
  /// 
  /// Args:
  ///   uid (String): The user's unique ID.
  Stream<UserModel> getUserData(String uid) => _authRepository.getUserData(uid);

  /// It signs in the user with google.
  /// 
  /// Args:
  ///   context (BuildContext): The context of the widget that calls the function.
  void signInWithGoogle(BuildContext context) async {
    state = true; //start Loading
    final user = await _authRepository.signInWithGoogle();
    state = false; //stop Loading
    user.fold(
      (failer) => showSnackBar(context, failer.message),
      (user) => _ref.read(userProvider.notifier).update((state) => user),
    );
  }

  void signOut() async => await _authRepository.signOut();
}
