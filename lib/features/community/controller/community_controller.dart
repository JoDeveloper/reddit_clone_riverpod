import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_riverpod/core/constants/constants.dart';
import 'package:reddit_clone_riverpod/core/failer.dart';
import 'package:reddit_clone_riverpod/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone_riverpod/core/utils.dart';
import 'package:reddit_clone_riverpod/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_riverpod/features/community/repository/community_repository.dart';
import 'package:reddit_clone_riverpod/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

/// Creating a provider for the CommunityController class.
final communityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
    communityRepository: ref.watch(communityRepositoryProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
    ref: ref,
  );
});

/// Creating a provider for the getUserCommunities() function.
final getUserCommunityProvider = StreamProvider<List<Community>>((ref) {
  return ref.watch(communityControllerProvider.notifier).getUserCommunities();
});

/// A provider that takes a string as a parameter and returns a stream of Community objects.
final getCommunityByNameProvider = StreamProvider.family<Community, String>((ref, name) {
  return ref.watch(communityControllerProvider.notifier).getCommunityByName(name);
});

/// A provider that takes a string as a parameter and returns a stream of Community objects.
final searchCommunityProvider = StreamProvider.family<List<Community>, String>(
  (ref, query) => ref.watch(communityControllerProvider.notifier).searchCommunity(query),
);

/// The CommunityController is a state notifier that takes a CommunityRepository and a Ref as
/// parameters.
class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _repository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  CommunityController({
    required CommunityRepository communityRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _repository = communityRepository,
        _storageRepository = storageRepository,
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

  /// This function takes a string and returns a stream of lists of communities.
  /// 
  /// Args:
  ///   query (String): The query string to search for.
  Stream<List<Community>> searchCommunity(String query) => _repository.searchCommunity(query);

  /// This function returns a stream of a list of communities that the user is a member of.
  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _repository.getUserCommunities(uid);
  }

  /// This function is used to edit a community
  /// 
  /// Args:
  ///   community (Community): Community
  ///   bannerImage (File): File?
  ///   profileImage (File): File?
  ///   context (BuildContext): BuildContext
  void editCommunity({required Community community, required File? bannerImage, required File? profileImage, required BuildContext context}) async {
    state = true;
    if (profileImage != null) {
      final profile = await _storageRepository.storeFile(path: 'communities/profile', id: community.name, file: profileImage);
      profile.fold(
        (error) => showSnackBar(context, error.message),
        (image) => community.copyWith(avatar: image),
      );
    }

    if (bannerImage != null) {
      final banner = await _storageRepository.storeFile(path: 'communities/banner', id: community.name, file: bannerImage);
      banner.fold(
        (error) => showSnackBar(context, error.message),
        (image) => community.copyWith(banner: image),
      );
    }

    final res = await _repository.editCommunity(community);

    state = false;
    res.fold(
      (error) => showSnackBar(context, error.message),
      (_) => Routemaster.of(context).pop(),
    );
  }

  /// It takes a community and a context, and if the user is a member of the community, it leaves the
  /// community, otherwise it joins the community
  /// 
  /// Args:
  ///   community (Community): is the community object that is passed to the function
  ///   context (BuildContext): BuildContext
  void joinOrLeaveCommunity(Community community, BuildContext context) async {
    final uid = _ref.read(userProvider)!.uid;
    Either<Failer, void> res;
    if (community.members.contains(uid)) {
      res = await _repository.leaveCommunity(community.name, uid);
    } else {
      res = await _repository.joinCommunity(community.name, uid);
    }

    res.fold(
      (failer) => showSnackBar(context, failer.message),
      (_) {
        if (community.members.contains(uid)) {
          showSnackBar(context, 'you left ${community.name} successfully');
        } else {
          showSnackBar(context, 'you Joined ${community.name}  successfully');
        }
      },
    );
  }

  /// It takes a community name, a list of ids, and a context, and then it calls the repository to add
  /// the mods to the community, and then it either shows a snackbar with the error message or it pops
  /// the current route
  /// 
  /// Args:
  ///   communityName (String): The name of the community
  ///   ids (List<String>): List of mod ids
  ///   context (BuildContext): BuildContext
  void addModsCommunity(String communityName, List<String> ids, BuildContext context) async {
    final res = await _repository.addModsCommunity(communityName, ids);
    res.fold(
      (failer) => showSnackBar(context, failer.message),
      (r) => Routemaster.of(context).pop(),
    );
  }
}
