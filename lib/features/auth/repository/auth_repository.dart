import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone_riverpod/core/constants/constants.dart';
import 'package:reddit_clone_riverpod/core/constants/firebase_contsants.dart';
import 'package:reddit_clone_riverpod/core/failer.dart';
import 'package:reddit_clone_riverpod/core/providers/firebase_providers.dart';
import 'package:reddit_clone_riverpod/core/type_def.dart';
import 'package:reddit_clone_riverpod/models/user_model.dart';

/// Creating a provider for AuthRepository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    firestore: ref.read(fireFirestoreProvider),
    auth: ref.read(firebaseAuthProvider),
    googleSignIn: ref.read(googleSignInProvider),
  );
});

/// > This class is responsible for authenticating the user
class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({required FirebaseFirestore firestore, required FirebaseAuth auth, required GoogleSignIn googleSignIn})
      : _firebaseAuth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  /// A getter that returns a collection reference to the users collection.
  CollectionReference get _users => _firestore.collection(FireBaseConsts.usersCollection);

  /// A getter that returns a stream of the user.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// It signs in with google, gets the user's data, and returns it
  ///
  /// Returns:
  ///   Either<Failer, UserModel>
  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final googleAccount = await _googleSignIn.signIn();

      final userAuthintication = await googleAccount?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: userAuthintication?.accessToken,
        idToken: userAuthintication?.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      UserModel user;
      if (userCredential.additionalUserInfo!.isNewUser) {
        user = UserModel(
          name: userCredential.user!.displayName ?? 'No Name',
          profilePic: userCredential.user!.photoURL ?? Constants.bannerDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isGuest: false,
          karma: 0,
          awards: [],
        );
        await _users.doc(user.uid).set(user.toMap());
      } else {
        user = await getUserData(userCredential.user!.uid).first;
      }

      return right(user);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failer(e.toString()));
    }
  }

  /// It returns a stream of the user data.
  ///
  /// Args:
  ///   uid (String): The user's unique ID.
  Stream<UserModel> getUserData(String uid) => _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
}
