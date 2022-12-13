import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_riverpod/core/constants/firebase_contsants.dart';
import 'package:reddit_clone_riverpod/core/failer.dart';
import 'package:reddit_clone_riverpod/core/providers/firebase_providers.dart';
import 'package:reddit_clone_riverpod/core/type_def.dart';
import 'package:reddit_clone_riverpod/models/community_model.dart';

/// A provider that is being used to provide the `CommunityRepository` class.
final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository(fireStroe: ref.read(fireFirestoreProvider));
});

/// > This class is a repository for the Community model
class CommunityRepository {
  final FirebaseFirestore _fireStroe;

  CommunityRepository({required FirebaseFirestore fireStroe})
      : _fireStroe = fireStroe;

  /// A getter that returns a collection reference.
  CollectionReference get _communityRef =>
      _fireStroe.collection(FireBaseConsts.communitiesCollection);

  /// It returns a stream of a single document from the collection "communities" with the document ID of
  /// the name of the community
  ///
  /// Args:
  ///   name (String): The name of the community you want to get.
  ///
  /// Returns:
  ///   A Stream of Community objects.
  Stream<Community> getCommunityByName(String name) {
    return _communityRef.doc(name).snapshots().map(
        (event) => Community.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRef
        .where(
          'name',
          isLessThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(query.codeUnitAt(query.length - 1) + 1),
        )
        .snapshots()
        .map(
          (event) => event.docs
              .map((doc) =>
                  Community.fromMap(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  /// It returns a stream of a list of communities that the user is a member of
  ///
  /// Args:
  ///   uid (String): The user's id
  ///
  /// Returns:
  ///   A Stream of a List of Community objects.
  Stream<List<Community>> getUserCommunities(String uid) {
    return _communityRef
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      final communities = <Community>[];
      for (final doc in event.docs) {
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  /// It creates a community in the database
  ///
  /// Args:
  ///   community (Community): Community
  ///
  /// Returns:
  ///   A FutureVoid is being returned.
  FutureVoid createCommunity(Community community) async {
    try {
      final communityDoc = await _communityRef.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name already exists !';
      }

      return right(_communityRef.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      return left(Failer(e.message!));
    } catch (e) {
      return left(Failer(e.toString()));
    }
  }

  FutureVoid editCommunity(Community community) async {
    try {
      return right(_communityRef.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failer(e.toString()));
    }
  }

  FutureVoid joinCommunity(String name, String uid) async {
    try {
      return right(_communityRef.doc(name).update({
        'members': FieldValue.arrayUnion([uid]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failer(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String name, String uid) async {
    try {
      return right(_communityRef.doc(name).update({
        'members': FieldValue.arrayRemove([uid]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failer(e.toString()));
    }
  }

  FutureVoid addModsCommunity(String communityName, List<String> ids) async {
    try {
      return right(_communityRef.doc(communityName).update({
        'mods':ids,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failer(e.toString()));
    }
  }
}
