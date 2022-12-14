import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_riverpod/core/constants/firebase_contsants.dart';
import 'package:reddit_clone_riverpod/core/failer.dart';
import 'package:reddit_clone_riverpod/core/providers/firebase_providers.dart';
import 'package:reddit_clone_riverpod/core/type_def.dart';
import 'package:reddit_clone_riverpod/models/user_model.dart';

/// A provider that is being used to provide the `UserProfileRepository` class.
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository(fireStroe: ref.read(fireFirestoreProvider));
});


class UserProfileRepository {
  final FirebaseFirestore _fireStroe;

  UserProfileRepository({required FirebaseFirestore fireStroe})
      : _fireStroe = fireStroe;

  /// A getter that returns a collection reference.
  CollectionReference get _usersRef =>
      _fireStroe.collection(FireBaseConsts.usersCollection);

  /// It takes a user object, and updates the user's profile in the database
  /// 
  /// Args:
  ///   user (UserModel): UserModel
  /// 
  /// Returns:
  ///   A FutureVoid is being returned.
  FutureVoid editUserProfile(UserModel user) async {
    try {
      return right(
        _usersRef.doc(user.name).update(user.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failer(e.toString()));
    }
  }
}
