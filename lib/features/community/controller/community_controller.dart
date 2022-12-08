import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/core/constants/constants.dart';
import 'package:reddit_clone_riverpod/core/utils.dart';
import 'package:reddit_clone_riverpod/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_riverpod/features/community/repository/community_repository.dart';
import 'package:reddit_clone_riverpod/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

/// Creating a provider for the CommunityController class.
final communityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
    communityRepository: ref.watch(communityRepositoryProvider),
    ref: ref,
  );
});

/// Creating a provider for the getUserCommunities() function.
final getUserCommunityProvider = StreamProvider<List<Community>>((ref) {
  return ref.watch(communityControllerProvider.notifier).getUserCommunities();
});

/// A provider that takes a string as a parameter and returns a stream of Community objects.
final getCommunitybyNameProvider = StreamProvider.family<Community,String>((ref,name) {
  return ref.watch(communityControllerProvider.notifier).getCommunityByName(name);
});

/// The CommunityController is a state notifier that takes a CommunityRepository and a Ref as
/// parameters.
class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _repository;
  final Ref _ref;
  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
  })  : _repository = communityRepository,
        _ref = ref,
        super(false);

  /// It takes a string, and returns a stream of Community objects
  ///
  /// Args:
  ///   name (String): The name of the community you want to search for.
  ///
  /// Returns:
  ///   A stream of Community objects.
  Stream<Community> getCommunityByName(String name) {
    return _repository.getCommunityByName(name);
  }

  /// It creates a community and adds the user to the community
  ///
  /// Args:
  ///   name (String): The name of the community
  ///   context (BuildContext): BuildContext
  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid;
    final community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid!],
      mods: [uid],
    );

    final res = await _repository.createCommunity(community);
    state = false;
    res.fold(
      (failer) => showSnackBar(context, failer.message),
      (r) {
        showSnackBar(context, 'Community Created Successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  /// This function returns a stream of a list of communities that the user is a member of.
  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _repository.getUserCommunities(uid);
  }
}
